LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY coffeeMachine IS PORT (
	s: IN STD_LOGIC_VECTOR(2 downto 0);
	o: OUT STD_LOGIC_VECTOR(0 to 7)
	);
END coffeeMachine;

ARCHITECTURE arq OF coffeeMachine IS

BEGIN
	WITH s SELECT
		o <= 
			"10000000" WHEN "000",
			"01000000" WHEN "001",
			"00100000" WHEN "010",
			"00010000" WHEN "011",
			"00001000" WHEN "100",
			"00000100" WHEN "101",
			"00000010" WHEN "110",
			"00000001" WHEN "111";
			
			
END arq;