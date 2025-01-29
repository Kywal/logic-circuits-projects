library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtracao2 is
    generic (
        reg_amount : integer := 8;  -- Tamanho de cada registrador
        word_size : integer := 16
    );
    port (
        clk          : in  std_logic;
        entrada      : in  std_logic_vector(word_size-1 downto 0);
        display_valor  : out std_logic_vector(0 to 27);
        display_estado : out std_logic_vector(0 to 6);
        escolher_reg  : in  std_logic;
        setar_val_reg : in  std_logic;
        mostrar_val_reg : in  std_logic;
        executar     : in  std_logic;
        is_finalizado   : out std_logic;
        valor_resto  : out std_logic_vector(15 downto 0);
        tem_resto    : out std_logic
    );
end subtracao2;

architecture behaviour of subtracao2 is

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

    -- Sinais de controle de borda
    signal escolher_reg_prev, setar_val_reg_prev, mostrar_val_reg_prev, executar_prev : std_logic := '0';
    signal escolher_reg_pulse, setar_val_reg_pulse, mostrar_val_reg_pulse, executar_pulse : std_logic;

    -- Máquina de estados
    type state_type is (ESCOLHENDO_REG, SETANDO_VALOR, MOSTRANDO_VALOR, DIVIDINDO, FINALIZADO);
    signal state, next_state : state_type := ESCOLHENDO_REG;

    -- Sinais internos
    signal visor : std_logic_vector(15 downto 0) := (others => '0');
    signal codigo_estado_em_binario : std_logic_vector(3 downto 0) := "1010";
    signal saida_banco : std_logic_vector(15 downto 0);
    signal reg_selecionado : std_logic_vector(15 downto 0);
    signal entrada_banco : std_logic_vector(15 downto 0);
    signal quoc, dividendo, divisor : signed(15 downto 0) := (others => '0');

begin

    -- Detecção de borda de subida
    process(clk)
    begin
        if rising_edge(clk) then
            escolher_reg_prev <= escolher_reg;
            setar_val_reg_prev <= setar_val_reg;
            mostrar_val_reg_prev <= mostrar_val_reg;
            executar_prev <= executar;
        end if;
    end process;

    escolher_reg_pulse <= escolher_reg and not escolher_reg_prev;
    setar_val_reg_pulse <= setar_val_reg and not setar_val_reg_prev;
    mostrar_val_reg_pulse <= mostrar_val_reg and not mostrar_val_reg_prev;
    executar_pulse <= executar and not executar_prev;

    -- Registro de estado
    process(clk)
    begin
        if rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Lógica de próximo estado
    process(state, escolher_reg_pulse, setar_val_reg_pulse, mostrar_val_reg_pulse, executar_pulse, dividendo, divisor)
    begin
        next_state <= state;
        case state is
            when ESCOLHENDO_REG =>
                if setar_val_reg_pulse = '1' then
                    next_state <= SETANDO_VALOR;
                end if;
                
            when SETANDO_VALOR =>
                if executar_pulse = '1' then
                    next_state <= DIVIDINDO;
                elsif mostrar_val_reg_pulse = '1' then
                    next_state <= MOSTRANDO_VALOR;
                end if;
                
            when MOSTRANDO_VALOR =>
                if escolher_reg_pulse = '1' then
                    next_state <= ESCOLHENDO_REG;
                end if;
                
            when DIVIDINDO =>
                if dividendo < divisor then
                    next_state <= FINALIZADO;
                end if;
                
            when FINALIZADO =>
                if escolher_reg_pulse = '1' then
                    next_state <= ESCOLHENDO_REG;
                end if;
                
            when others =>
                next_state <= ESCOLHENDO_REG;
        end case;
    end process;

    -- Lógica principal
    process(clk)
    begin
        if rising_edge(clk) then
            is_finalizado <= '0';
            tem_resto <= '0';
            
            case state is
                when ESCOLHENDO_REG =>
                    codigo_estado_em_binario <= "0001";
                    reg_selecionado <= entrada;
                    entrada_banco <= reg_selecionado;
                    visor <= reg_selecionado;
                    
                when SETANDO_VALOR =>
                    codigo_estado_em_binario <= "0010";
                    entrada_banco <= entrada;
                    visor <= entrada;
                    
                when MOSTRANDO_VALOR =>
                    codigo_estado_em_binario <= "0011";
                    visor <= saida_banco;
                    
                when DIVIDINDO =>
                    codigo_estado_em_binario <= "0100";
                    if divisor /= 0 and dividendo >= divisor then
                        dividendo <= dividendo - divisor;
                        quoc <= quoc + 1;
                    else
                        is_finalizado <= '1';
                        visor <= std_logic_vector(quoc);
                        if dividendo > 0 then
                            tem_resto <= '1';
                            valor_resto <= std_logic_vector(dividendo);
                        end if;
                    end if;
                    
                when FINALIZADO =>
                    codigo_estado_em_binario <= "0101";
                    quoc <= (others => '0');
                    dividendo <= (others => '0');
                    divisor <= (others => '0');
                    
            end case;
        end if;
    end process;

    -- Instanciações
    display_estado_inst: converter4bit
    port map(
        number => codigo_estado_em_binario,
        leds => display_estado
    );

    display_valor_inst: hexaconverter
    port map(
        number => visor,
        display0 => display_valor(0 to 6),
        display1 => display_valor(7 to 13),
        display2 => display_valor(14 to 20),
        display3 => display_valor(21 to 27)
    );

    banco_registradores: register_bank
    port map(
        clock => clk,
        pickReg => escolher_reg_pulse,
        startReading => mostrar_val_reg_pulse,
        startWriting => setar_val_reg_pulse,
        inputBank => entrada_banco,
        outputBank => saida_banco
    );

end behaviour;
