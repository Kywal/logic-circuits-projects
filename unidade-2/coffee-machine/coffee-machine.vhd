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
	o(0) <= NOT v OR s(0);
	o(1) <= NOT v OR s(1);
	o(2) <= NOT v OR s(2);
	o(3) <= NOT v OR s(3);
	o(4) <= NOT v OR s(4);
	o(5) <= NOT v OR s(5);
	o(6) <= NOT v OR s(6);
	o(7) <= NOT v OR s(7);
END arq;