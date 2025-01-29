library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtracao is
    generic (
        reg_amount : integer := 8;  -- Tamanho de cada registrador
        word_size : integer := 16
    );
    port (
        clk         : in  std_logic;
        entrada     : in std_logic_vector(word_size-1 downto 0);

        display_valor  : out std_logic_vector(0 to 27); -- Valor atual em HEX

        -- Indica o estado atual 
        -- Escolhendo reg ==> A
        -- Escrevendo valor do reg ==> b
        -- Mostrando valor do reg ==> C
        -- Mostrando resultado da operação ==> D
        display_estado : out std_logic_vector(0 to 6); 

        -- ==== Estados ====
        escolher_reg : in std_logic; -- Escolher o registrador
        setar_val_reg : in std_logic; -- Encaminha valor dos switches pro estado interno
        mostrar_val_reg      : in std_logic; -- Exibe o valor do estado interno no display
        executar     : in std_logic; -- Executa operação de subtração com os registradores convencionados (0 é dividendo, 1 é divisor)
        
        finalizado : out std_logic; -- Indica que o processamento da subtração chegou ao fim e o valor exibido no display é o resultado final
 
	    valor_resto : out std_logic_vector(15 downto 0);
	    tem_resto   : out std_logic
    );
end projeto;

architecture behaviour of projeto is

    -- Componente do display de estado
    component converter4bit is 
        port (
            number: in std_logic_vector(3 downto 0);
            leds: out std_logic_vector(0 to 6)
        );
    end component;
    
    -- Componente do display do valor atual
    component hexaconverter is 
        port (
            number: IN STD_LOGIC_VECTOR(15 downto 0);
            display0: OUT STD_LOGIC_VECTOR(0 to 6);
            display1: OUT STD_LOGIC_VECTOR(0 to 6);
            display2: OUT STD_LOGIC_VECTOR(0 to 6);
            display3: OUT STD_LOGIC_VECTOR(0 to 6)
        );
    end component;

    component register_bank is 
        port (
            clock, pickReg, startReading, startWriting: IN STD_LOGIC;
		    inputBank: IN STD_LOGIC_VECTOR(word_size-1 downto 0);
		    outputBank: OUT STD_LOGIC_VECTOR(word_size-1 downto 0)
        );
    end component;

    -- Estados gerais
    signal visor       : std_logic_vector(15 downto 0) := (others => '0');
    signal codigo_estado_em_binario : std_logic_vector(3 downto 0) := "1010";
    signal saida_banco : std_logic_vector(15 downto 0);
    signal reg_selecionado : std_logic_vector(15 downto 0);

    -- Estados da divisão
    signal quoc : signed(15 downto 0) := (others => '0');
    signal dividendo : signed(15 downto 0) := (others => '0');
    signal divisor : signed(15 downto 0) := (others => '0');
    signal temp : signed(15 downto 0) := (others => '0');  -- Auxiliar para o loop de divisão

    -- Estados de entrada
    signal entrada_banco : std_logic_vector(TAM_REG-1 downto 0) := (others => '0');

    -- Estados de saída
    signal set_reg_control : std_logic := '1';
    signal set_val_control : std_logic := '1';
    signal get_val_control : std_logic := '0';
    signal contador_divisao: std_logic_vector(15 downto 0);

    signal sig_escolher_reg     : in std_logic; -- escolher o registrador
    signal sig_setar_val_reg : in std_logic; -- Encaminha valor dos switches pro estado interno
    signal sig_mostrar_val_reg  : in std_logic; -- Exibe o valor do estado interno no display
    signal sig_executar         : in std_logic; -- Executa operação de subtração com os registradores convencionados (0 é dividendo, 1 é divisor)

    -- Estado de controle para a divisão
    -- type state_type is (IDLE, SET_A, READ_A, SET_B, READ_B, DIVIDE, DONE);
    type state_type is (ESCOLHENDO_REG, SETANDO_VALOR, MOSTRANDO_VALOR, DIVIDINDO, FINALIZADO);
    signal state, next_state : state_type := ESCOLHENDO_REG;

begin

    -- Instâncias dos componentes
    seg_estado : hex_to_seg port map (
        entry => codigo_estado_em_binario,
        segs => display_estado
    );

   display_estado : converter4bit port map (
        number => 
        leds => 
   );

   display_valor : hexaconverter port map (
        number =>
        display0 =>
        display1 =>
        display2 =>
        display3 =>
   );

   banco : bank_register port map (
            clock => clock,
            pickReg => sig_escolher_reg,
            startReading => sig_mostrar_val_reg,
            startWriting => sig_setar_val_reg,
		    inputBank => entrada_banco
		    outputBank => saida_banco
   );

    

    -- Processo de controle de estado
    process(clk)
    begin
        if rising_edge(clk) then

            -- TODO: implementar detecção de subida de borda, revisar máquina de estados, revisar divisão, mapear conexões de componentes

            -- type state_type is (ESCOLHENDO_REG, SETANDO_VALOR, MOSTRANDO_VALOR, DIVIDINDO, FINALIZADO);
            case state is
                when ESCOLHENDO_REG =>

                    sig_escolher_reg     <= '0';
                    sig_setar_val_reg  <= '1';
                    sig_mostrar_val_reg  <= '1';
                    sig_executar         <= '1';
                    
                    reg_selecionado <= entrada;
                    entrada_banco <= reg_selecionado;         
				
                when SETANDO_VALOR =>

                    sig_escolher_reg     <= '1';
                    sig_setar_val_reg  <= '0';
                    sig_mostrar_val_reg  <= '1';
                    sig_executar         <= '1';

                    entrada_banco <= entrada;

                when MOSTRANDO_VALOR =>
                    codigo_estado_em_binario <= "1010";
                    entrada_banco <= entrada;  -- Use input directly
                    entrada_var <= entrada;
                    set_reg_control <= '1';
                    set_val_control <= '0';
                    get_val_control <= '1';
                    dividendo <= signed(entrada);

				when DIVIDINDO =>
                	entrada_banco <= "0000000000000001";
                    set_reg_control <= '0';
                    set_val_control <= '1';
                    get_val_control <= '1';


                    codigo_estado_em_binario <= "1100";
                    if divisor /= 0 then 
                        if dividendo >= divisor then
                            dividendo <= dividendo - divisor;
                            quoc <= quoc + 1;
                        else
                        end if;
                    else
                        codigo_estado_em_binario <= "1111"; -- Erro quando divisor for 0
                    end if;


                when FINALIZADO =>
                    codigo_estado_em_binario <= "1011";
                    entrada_banco <= entrada;  -- Use input directly
                    entrada_var <= entrada;
                    set_reg_control <= '1';
                    set_val_control <= '0';
                    get_val_control <= '1';
                    divisor <= signed(entrada);

                when DIVIDE =>


                when DONE =>
                    entrada_var <= std_logic_vector(quoc);
                    finalizado <= '1';
                    codigo_estado_em_binario <= "1101"; 

						  if dividendo > to_signed(0, 16) then
							tem_resto <= '1';
							valor_resto <= std_logic_vector(dividendo);
						  end if;
                when others =>
            end case;
        end if;
    end process;
end behaviour;
