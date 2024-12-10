LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY converter4bit IS PORT (
	number: IN STD_LOGIC;
	leds: OUT STD_LOGIC_VECTOR(0 to 6)
	);
END converter4bit;

ARCHITECTURE behavior OF converter4bit IS

BEGIN
	WITH number SELECT
		leds <= 
			"0000001" WHEN '0', -- 0
			"1001111" WHEN '1', -- 1
			"1111110" WHEN OTHERS;  -- Default (shouldn't happen)
END;