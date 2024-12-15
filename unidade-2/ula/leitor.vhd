LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY leitor IS
    PORT (
	clk: IN STD_LOGIC;
        entrada: IN STD_LOGIC_VECTOR(15 downto 0);
	botao_ler_a, botao_ler_b, botao_ler_seletor, botao_exibir_resultado: IN STD_LOGIC;

        display0, display1, display2, display3: OUT STD_LOGIC_VECTOR(0 to 6);
        display_estado: OUT STD_LOGIC_VECTOR(0 to 6)
    );
END leitor;

ARCHITECTURE arqLeitor OF leitor IS
	 -- Armazena o estado atual da ULA, usado para decidir o que exibir nos displays
	 TYPE estado_t IS (IDLE, A, B, C, D);
	 SIGNAL estado_atual: estado_t := IDLE;
	
	 -- sinais para armazenar os valores de a, b e seletor
	 SIGNAL val_a, val_b: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	 SIGNAL val_seletor: STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
	 
	 SIGNAL numero_para_exibir, seletor_display, resultado: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	 
	 -- Armazena estado anterior dos botoes para identificar borda de descida
	 SIGNAL botao_ler_a_last, botao_ler_b_last, botao_ler_seletor_last, botao_exibir_resultado_last: STD_LOGIC := '0';
	
	 COMPONENT hexaconverter PORT (
		number: IN STD_LOGIC_VECTOR(15 downto 0);
		display0: OUT STD_LOGIC_VECTOR(0 to 6);
		display1: OUT STD_LOGIC_VECTOR(0 to 6);
		display2: OUT STD_LOGIC_VECTOR(0 to 6);
		display3: OUT STD_LOGIC_VECTOR(0 to 6)
	);
	END COMPONENT;
BEGIN
    -- Process to Update `a` and `numberToDisplay`
    PROCESS (entrada, botao_ler_a, botao_ler_b, botao_ler_seletor, botao_exibir_resultado)
    BEGIN
        IF rising_edge(clk) THEN
            IF botao_ler_a = '0' and botao_ler_a_last = '1' THEN
					-- Apertei o botao ler A
					val_a <= entrada;
					estado_atual <= A;
				ELSIF botao_ler_b = '0' and botao_ler_b_last = '1' THEN
					val_b <= entrada;
					estado_atual <= B;
				ELSIF botao_ler_seletor = '0' and botao_ler_seletor_last = '1' THEN
					val_seletor <= entrada(2 downto 0);
					estado_atual <= C;
				ELSIF botao_exibir_resultado = '0' and botao_exibir_resultado_last = '1' THEN
					estado_atual <= D;
				END IF;
				
				botao_ler_a_last <= botao_ler_a;
				botao_ler_b_last <= botao_ler_b;
				botao_ler_seletor_last <= botao_ler_seletor;
				botao_exibir_resultado_last <= botao_exibir_resultado;
        END IF;
    END PROCESS;

	
    WITH estado_atual SELECT 
		display_estado <= "1111111" WHEN IDLE,					-- exibe o estado no display
								"0001000" WHEN A,
								"1100000" WHEN B,
								"0110001" WHEN C,
								"1000010" WHEN D;
	 
	 seletor_display(2 downto 0) <= val_seletor;


    WITH estado_atual SELECT
		numero_para_exibir <= (others => '0') WHEN IDLE,			-- escolhe o objeto atual a ser mostrado (A, B, operação, resultado) com base no estado
								val_a WHEN A,
								val_b WHEN B,
								seletor_display WHEN C,
								resultado WHEN D;


		
    hexa1: hexaconverter PORT MAP (numero_para_exibir, display0, display1, display2, display3);

END arqLeitor;
