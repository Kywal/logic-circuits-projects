library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtracao3 is
    generic (
        reg_amount : integer := 8;  
        word_size : integer := 16
    );
    port (
        clk          : in  std_logic;
        entrada      : in  std_logic_vector(word_size-1 downto 0);
        display_valor  : out std_logic_vector(0 to 27);
        display_estado : out std_logic_vector(0 to 6);
        leds_resto : out std_logic_vector(15 downto 0);
        escolher_reg  : in  std_logic;
        setar_val_reg : in  std_logic;
        mostrar_val_reg : in  std_logic;
        executar     : in  std_logic;
        is_finalizado   : out std_logic;
        valor_resto  : out std_logic_vector(15 downto 0);
        tem_resto    : out std_logic
    );
end subtracao3;

architecture behaviour of subtracao3 is

    component converter4bit is 
        port (
            number: in  std_logic_vector(3 downto 0);
            leds: out std_logic_vector(0 to 6)
        );
    end component;
    
    component hexaconverter is 
        port (
            number:    in  std_logic_vector(15 downto 0);
            display0: out std_logic_vector(0 to 6);
            display1: out std_logic_vector(0 to 6);
            display2: out std_logic_vector(0 to 6);
            display3: out std_logic_vector(0 to 6)
        );
    end component;

    component register_bank is 
        port (
            clock, pickReg, startReading, startWriting: in  std_logic;
            inputBank:  in  std_logic_vector(word_size-1 downto 0);
            outputBank: out std_logic_vector(word_size-1 downto 0)
        );
    end component;

    type state_type is (ESCOLHENDO_REG, SETANDO_VALOR, MOSTRANDO_VALOR, CARREGAR_DIVIDENDO, CARREGAR_DIVISOR, DIVIDINDO, FINALIZADO);
    signal state, next_state : state_type := ESCOLHENDO_REG;

    signal escolher_reg_pulse, setar_val_reg_pulse, mostrar_val_reg_pulse, executar_pulse : std_logic;
    signal escolher_reg_prev, setar_val_reg_prev, mostrar_val_reg_prev, executar_prev : std_logic;

    signal visor, saida_banco, entrada_banco : std_logic_vector(15 downto 0);
    signal codigo_estado_em_binario : std_logic_vector(3 downto 0);
    signal quoc, dividendo, divisor, temp_dividendo, temp_divisor : unsigned(15 downto 0) := (others => '0');

begin

    -- Detecção de pulsos (borda de subida)
    escolher_reg_pulse <= escolher_reg and not escolher_reg_prev;
    setar_val_reg_pulse <= setar_val_reg and not setar_val_reg_prev;
    mostrar_val_reg_pulse <= mostrar_val_reg and not mostrar_val_reg_prev;
    executar_pulse <= executar and not executar_prev;

    -- Registro de estados anteriores
    process(clk) begin
        if rising_edge(clk) then
            escolher_reg_prev <= escolher_reg;
            setar_val_reg_prev <= setar_val_reg;
            mostrar_val_reg_prev <= mostrar_val_reg;
            executar_prev <= executar;
        end if;
    end process;

    -- Máquina de estados principal
    process(clk) begin
        if rising_edge(clk) then
            state <= next_state;

            -- Reset de sinais temporários
            is_finalizado <= '0';
            tem_resto <= '0';

            case state is
                when ESCOLHENDO_REG =>
                    entrada_banco <= "0000000000000" & entrada(2 downto 0); -- Captura índice do registrador
                    visor <= entrada;

                when SETANDO_VALOR =>
                    entrada_banco <= entrada; -- Valor a ser escrito
                    visor <= entrada;

                when CARREGAR_DIVIDENDO =>
                    dividendo <= unsigned(saida_banco);
                    temp_dividendo <= unsigned(saida_banco);

                when CARREGAR_DIVISOR =>
                    divisor <= unsigned(saida_banco);
                    temp_divisor <= unsigned(saida_banco);

                when DIVIDINDO =>
                    if temp_divisor = 0 then
                        valor_resto <= (others => '0');
                        is_finalizado <= '1';
                    elsif temp_dividendo >= temp_divisor then
                        temp_dividendo <= temp_dividendo - temp_divisor;
                        quoc <= quoc + 1;
                    else
                        valor_resto <= std_logic_vector(temp_dividendo);
                        tem_resto <= '1' when temp_dividendo > 0 else '0';
                        is_finalizado <= '1';
                    end if;

                when FINALIZADO =>
                    visor <= std_logic_vector(quoc);
                    leds_resto <= valor_resto;
                    quoc <= (others => '0');
                    dividendo <= (others => '0');
                    divisor <= (others => '0');

                when others => null;
            end case;
        end if;
    end process;

    -- Lógica de próximo estado
    process(state, escolher_reg_pulse, setar_val_reg_pulse, mostrar_val_reg_pulse, executar_pulse, is_finalizado) begin
        next_state <= state;

        case state is
            when ESCOLHENDO_REG =>
                if setar_val_reg_pulse = '1' then next_state <= SETANDO_VALOR;
                elsif mostrar_val_reg_pulse = '1' then next_state <= MOSTRANDO_VALOR; end if;

            when SETANDO_VALOR =>
                if executar_pulse = '1' then next_state <= CARREGAR_DIVIDENDO;
                elsif escolher_reg_pulse = '1' then next_state <= ESCOLHENDO_REG; end if;

            when MOSTRANDO_VALOR =>
                if escolher_reg_pulse = '1' then next_state <= ESCOLHENDO_REG; end if;

            when CARREGAR_DIVIDENDO => next_state <= CARREGAR_DIVISOR;
            when CARREGAR_DIVISOR => next_state <= DIVIDINDO;

            when DIVIDINDO =>
                if temp_divisor = 0 or temp_dividendo < temp_divisor then
                    next_state <= FINALIZADO;
                end if;
            when FINALIZADO =>
                if escolher_reg_pulse = '1' then next_state <= ESCOLHENDO_REG; end if;


        end case;
    end process;

    -- Conexão dos componentes
    banco_registradores: register_bank port map(
        clock => clk,
        pickReg => escolher_reg_pulse,
        startReading => mostrar_val_reg_pulse,
        startWriting => setar_val_reg_pulse,
        inputBank => entrada_banco,
        outputBank => saida_banco
    );

    display_estado_inst: converter4bit port map(
        codigo_estado_em_binario, 
        display_estado
    );

    display_valor_inst: hexaconverter port map(
        visor, 
        display_valor(0 to 6), 
        display_valor(7 to 13), 
        display_valor(14 to 20), 
        display_valor(21 to 27)
    );

end behaviour;