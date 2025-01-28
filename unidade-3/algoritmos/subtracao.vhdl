library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity projeto is
    generic (
        TAM_REG : integer := 16  -- Tamanho de cada registrador
    );
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        entrada     : in std_logic_vector(TAM_REG-1 downto 0);

        display_valor  : out  std_logic_vector(0 to 27); -- valor atual em HEX
        display_estado : out std_logic_vector(0 to 6); -- represetação de estado atual

        definir_estado       : in std_logic;
        executar_acao_estado : in std_logic; -- executa o tipo de ação do estado selecionado
        finalizado           : out std_logic;
 
	valor_resto : out std_logic_vector(15 downto 0);
	tem_resto   : out std_logic
    );
end projeto;

architecture behaviour of projeto is

    component hex_to_seg is 
        port (
            entry: in std_logic_vector(3 downto 0);
            segs: out std_logic_vector(0 to 6)
        );
    end component;


    component converter4bit is 
        port (
            number: in std_logic_vector(3 downto 0);
            leds: out std_logic_vector(0 to 6)
        );
    end component;


    component register_bank is 
        port (
            clk, reset : in std_logic;
            estado     : in std_logic_vector(2 downto 0);
            entrada    : in std_logic_vector(15 downto 0);
            saida      : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Estados gerais
    signal visor       : std_logic_vector(15 downto 0) := (others => '0');
    signal codigo_estado_em_binario : std_logic_vector(3 downto 0) := "1010";
    signal saida_banco : std_logic_vector(15 downto 0);

    -- Estados da divisão
    signal quoc : signed(15 downto 0) := (others => '0');
    signal dividendo : signed(15 downto 0) := (others => '0');
    signal divisor : signed(15 downto 0) := (others => '0');
    signal temp : signed(15 downto 0) := (others => '0');  -- Auxiliar para o loop de divisão

    -- Estados de entrada
    signal entrada_var   : std_logic_vector(TAM_REG-1 downto 0) := (others => '0');
    signal entrada_banco : std_logic_vector(TAM_REG-1 downto 0) := (others => '0');

    -- Estados de saída
    signal set_reg_control : std_logic := '1';
    signal set_val_control : std_logic := '1';
    signal get_val_control : std_logic := '0';
    signal counter_divisao: std_logic_vector(15 downto 0);

    -- Estado de controle para a divisão
    type state_type is (IDLE, SET_A, READ_A, SET_B, READ_B, DIVIDE, DONE);
    signal state, next_state : state_type := IDLE;

begin

    -- Instâncias dos componentes
    seg_a : hex_to_seg port map(
        entry => entrada_var(3 downto 0),
        segs => display(0 to 6)
    );
    seg_b : hex_to_seg port map(
        entry => entrada_var(7 downto 4),
        segs => display(7 to 13)
    );
    seg_c : hex_to_seg port map(
        entry => entrada_var(11 downto 8),
        segs => display(14 to 20)
    );
    seg_d : hex_to_seg port map(
        entry => entrada_var(15 downto 12),
        segs => display(21 to 27)
    );
    seg_estado : hex_to_seg port map(
        entry => codigo_estado_em_binario,
        segs => display_estado
    );

    

    -- Processo de controle de estado
    process(clk, reset)
    begin
        if reset = '0' then  -- Active-low reset
            state <= IDLE;
            codigo_estado_em_binario <= "1010";
            entrada_banco <= (others => '0');
            set_reg_control <= '1';
            set_val_control <= '1';
            get_val_control <= '0';
            quoc <= (others => '0');
            dividendo <= (others => '0');
            divisor <= (others => '0');
            entrada_var <= (others => '0');
            finalizado <= '0';
				tem_resto <= '0';
				valor_resto <= (others => '0');
        elsif rising_edge(clk) then
            state <= next_state;

            case state is
                when IDLE =>
                    set_reg_control <= '1';
                    set_val_control <= '1';
                    get_val_control <= '0';

                    if ler_a = '0' then  -- Active-low buttons
                        next_state <= SET_A;
                    elsif ler_b = '0' then
                        next_state <= SET_B;
                    elsif executar_calculo = '0' then
                        next_state <= DIVIDE;
                    else
                        codigo_estado_em_binario <= "1100";
                        next_state <= IDLE;
                    end if;
				
                when SET_A =>
                	entrada_banco <= "0000000000000000";
					set_reg_control <= '0';
                    set_val_control <= '1';
                    get_val_control <= '1';
                    next_state <= READ_A;
                when READ_A =>
                    codigo_estado_em_binario <= "1010";
                    entrada_banco <= entrada;  -- Use input directly
                    entrada_var <= entrada;
                    set_reg_control <= '1';
                    set_val_control <= '0';
                    get_val_control <= '1';
                    dividendo <= signed(entrada);
                    next_state <= IDLE;
				when SET_B =>
                	entrada_banco <= "0000000000000001";
                    set_reg_control <= '0';
                    set_val_control <= '1';
                    get_val_control <= '1';
                    next_state <= READ_B;
                when READ_B =>
                    codigo_estado_em_binario <= "1011";
                    entrada_banco <= entrada;  -- Use input directly
                    entrada_var <= entrada;
                    set_reg_control <= '1';
                    set_val_control <= '0';
                    get_val_control <= '1';
                    divisor <= signed(entrada);
                    next_state <= IDLE;

              when DIVIDE =>
                    codigo_estado_em_binario <= "1100";
                    if divisor /= 0 then 
                        if dividendo >= divisor then
                            dividendo <= dividendo - divisor;
                            quoc <= quoc + 1;
                            next_state <= DIVIDE;
                        else
                            next_state <= DONE;
                        end if;
                    else
                        codigo_estado_em_binario <= "1111"; -- Erro quando divisor for 0
                        next_state <= IDLE;  -- volta pra idle quando divisor for 0
                    end if;

                when DONE =>
                    entrada_var <= std_logic_vector(quoc);
                    finalizado <= '1';
                    codigo_estado_em_binario <= "1101"; 

						  if dividendo > to_signed(0, 16) then
							tem_resto <= '1';
							valor_resto <= std_logic_vector(dividendo);
						  end if;
                when others =>
                    next_state <= IDLE;  
            end case;
        end if;
    end process;
end behaviour;
