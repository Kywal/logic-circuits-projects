LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY four_judges IS
	PORT(
			j0, j1, j2, j3: IN STD_LOGIC;
			greenLight, redLight: OUT STD_LOGIC;
			display0, display1, display2, display3: OUT STD_LOGIC_VECTOR(0 to 6)
	);
END four_judges;

ARCHITECTURE behavior OF four_judges IS 

COMPONENT hexaconverter 
	PORT (
		j0, j1, j2, j3: IN STD_LOGIC;
		display0, display1, display2, display3: OUT STD_LOGIC_VECTOR(0 to 6)
	);
END COMPONENT;

	BEGIN
	
	hexaConv: hexaconverter PORT MAP(j0, j1, j2, j3, display0, display1, display2, display3);
	
	P1: PROCESS(j0, j1, j2, j3)
	BEGIN
	
		-- Maioria aprovou, acende apenas LED GREEN 7
		IF( (j0 ='1' AND j1='1' AND j2='1') OR (j0='1' AND j1='1' AND j3='1') OR (j0='1' AND j2='1' AND j3='1') OR (j1='1' AND j2='1' AND j3='1') ) THEN
			redLight <= '0';
			greenLight <= '1';
	
		-- Maioria reprovou, acende apenas LED RED 0
		ELSIF( NOT(j0='1' OR j1='1' OR j2='1') OR NOT(j0='1' OR j1='1' OR j3='1') OR NOT(j0='1' OR j2='1' OR j3='1') OR NOT(j1='1' OR j2='1' OR j3='1') ) THEN
			redLight <= '1';
			greenLight <= '0';
		
		-- Empate, acende LED RED 0 e LED GREEN 7
		ELSE
			redLight <= '1';
			greenLight <= '1';
		
		END IF;
	
	END PROCESS P1;
	
END behavior;