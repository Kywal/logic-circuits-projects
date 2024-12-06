LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY three_comparator IS
	PORT(
			input: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			a_ctrl, b_ctrl, c_ctrl, out_ctrl: IN STD_LOGIC;
			display7, display6, display5, display4, display1, display0: OUT STD_LOGIC_VECTOR(0 to 6);
			s0, s1, s2: OUT STD_LOGIC
		);
END three_comparator;


ARCHITECTURE behavior OF three_comparator IS

COMPONENT hexaconverter PORT (
	number: IN STD_LOGIC_VECTOR(7 downto 0);
	display0: OUT STD_LOGIC_VECTOR(0 to 6);
	display1: OUT STD_LOGIC_VECTOR(0 to 6)
);
END COMPONENT;

SIGNAL a, b, c: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL ctrl: STD_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN

	displayA: hexaconverter PORT MAP(a, display6, display7);
	displayB: hexaconverter PORT MAP(b, display4, display5);
	displayC: hexaconverter PORT MAP(c, display0, display1);
	
	P1: PROCESS(a_ctrl, b_ctrl, c_ctrl, out_ctrl, ctrl)
		BEGIN
		
		IF(a_ctrl = '0' AND b_ctrl = '1' AND c_ctrl = '1' AND out_ctrl = '1') THEN
			ctrl <= "00";
		
		ELSIF(a_ctrl = '1' AND b_ctrl = '0' AND c_ctrl = '1' AND out_ctrl = '1') THEN
			ctrl <= "01";
			
		ELSIF(a_ctrl = '1' AND b_ctrl = '1' AND c_ctrl = '0' AND out_ctrl = '1') THEN
			ctrl <= "10";
		
		ELSIF(a_ctrl = '1' AND b_ctrl = '1' AND c_ctrl = '1' AND out_ctrl = '0') THEN
			ctrl <= "11";
		END IF;
	
	END PROCESS P1;
	
	P2: PROCESS(ctrl, input, a, b ,c)
		BEGIN
			s2 <= '0';
			s1 <= '0';
			s0 <= '0';				
		
			-- 1° Estado -> Salvar valor dos pinos em a
			IF(ctrl = "00") THEN 
				a <= input;
				
			-- Botao 2 -> Salvar valor dos pinosdo em b
			ELSIF(ctrl = "01") THEN
				b <= input;
				
			-- Botao 1 -> Salvar valor dos pinos em c
			ELSIF(ctrl = "10") THEN
				c <= input;
				
			-- Botao 0 -> Computar comparacao
			ELSIF(ctrl = "11") THEN
				
				-- se houver um unico maior, acenda o LED 2
				IF (a > b AND a > c) OR (b > a AND b > c) OR (c > a AND c > b) THEN 
					s2 <= '1';
					s1 <= '0';
					s0 <= '0';
					
				-- se houver 2 maiores, acenda o LED 1
				ELSIF (a = b AND a > c) OR (a = c AND a > b) OR (b = c AND b > a) THEN
					s2 <= '0';
					s1 <= '1';
					s0 <= '0';
				
				-- se todos sao iguais, acenda o LED 0
				ELSIF(a = b AND b = c) THEN
					s2 <= '0';
					s1 <= '0';
					s0 <= '1';
					
				-- se houver algum caso nao previsto, acenda os LEDS 2 e 0	
				ELSE
					s2 <= '1';
					s0 <= '1';
				
				END IF;
			
			-- Caso nenhum estado esteja ligado
			ELSE
				s2 <= '1';
				s1 <= '1';
				s0 <= '1';
			END IF;
			
		END PROCESS P2;
END behavior;