LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY coffeeMachine IS PORT (
	s: IN STD_LOGIC_VECTOR(0 to 7);
	o: OUT STD_LOGIC_VECTOR(0 to 7)
	);
END coffeeMachine;

ARCHITECTURE arq OF coffeeMachine IS
	COMPONENT codificador PORT (
		s: IN STD_LOGIC_VECTOR(0 to 7);
		o: OUT STD_LOGIC_VECTOR(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT decodificador  PORT (
		s: IN STD_LOGIC_VECTOR(2 downto 0);
		o: OUT STD_LOGIC_VECTOR(0 to 7)
		);
	END COMPONENT;
	
	COMPONENT verificador PORT (
		s: IN STD_LOGIC_VECTOR(0 to 7);
		o: OUT STD_LOGIC
		);
	END COMPONENT;
		
	
	SIGNAL f: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL f2: STD_LOGIC_VECTOR(0 to 7);
	SIGNAL valido: STD_LOGIC;
BEGIN
	ver: verificador PORT MAP (s, valido);
	cod: codificador PORT MAP (s, f);
	decod: decodificador PORT MAP (f, f2);
	o <= f2 WHEN valido = '1' ELSE "00000000";
END arq;