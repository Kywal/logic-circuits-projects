LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY coffeeMachine IS PORT (
	s: IN STD_LOGIC_VECTOR(0 to 7);
	o: OUT STD_LOGIC_VECTOR(0 to 7)
	);
END coffeeMachine;

ARCHITECTURE arq OF coffeeMachine IS
	SIGNAL v: STD_LOGIC;
	
	COMPONENT verificador IS PORT (
		s: IN STD_LOGIC_VECTOR(0 to 7);
		o: OUT STD_LOGIC
	);
	END COMPONENT;
		
BEGIN
	ver: verificador PORT MAP (s, v);
	o(0) <= v AND s(0);
	o(1) <= v AND s(1);
	o(2) <= v AND s(2);
	o(3) <= v AND s(3);
	o(4) <= v AND s(4);
	o(5) <= v AND s(5);
	o(6) <= v AND s(6);
	o(7) <= v AND s(7);
END arq;