LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY calculadora IS
PORT (
	 clk         : IN  STD_LOGIC;                     -- Clock para gerenciamento dos estados
    val_in      : IN  STD_LOGIC_VECTOR (7 DOWNTO 0); -- Valor de entrada para A ou B
    op          : IN  STD_LOGIC;                     -- OP=0 para soma, OP=1 para subtração
    ler_a_ctrl  : IN  STD_LOGIC;                     -- Controle para leitura de A
    ler_b_ctrl  : IN  STD_LOGIC;                     -- Controle para leitura de B
    resultado   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Resultado da operação
    luz_soma    : OUT STD_LOGIC;                     -- Acende se for soma
    luz_subt    : OUT STD_LOGIC;                     -- Acende se for subtração
	 carry_out   : OUT STD_LOGIC
);
END calculadora;

ARCHITECTURE structural OF calculadora IS
    -- Declaração do componente somador_subtrator
    COMPONENT somador_subtrator 
    PORT (
       a, b          : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		 op            : IN STD_LOGIC;	 
		 carry_out     : OUT STD_LOGIC;
		 resultado     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
    END COMPONENT;

	 SIGNAL val_a, val_b: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
		
	 
BEGIN

   -- Logica do input
	PROCESS (val_in, ler_a_ctrl, ler_b_ctrl, op)
	BEGIN
		IF rising_edge(clk) THEN
			IF ler_a_ctrl = '0' THEN
				val_a <= val_in;
			ELSIF ler_b_ctrl = '0' THEN
				val_b <= val_in;
			END IF;
		END IF;
	END PROCESS;
	
	
    s1: somador_subtrator PORT MAP (val_a, val_b, op, carry_out, resultado);
    -- Controle das luzes
    luz_soma <= NOT op; -- Luz para soma
    luz_subt <= op;     -- Luz para subtração

END structural;
