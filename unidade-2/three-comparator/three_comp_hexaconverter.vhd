LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY hexaconverter IS PORT (
	number: IN STD_LOGIC_VECTOR(7 downto 0);
	display0: OUT STD_LOGIC_VECTOR(0 to 6);
	display1: OUT STD_LOGIC_VECTOR(0 to 6)
);
END hexaconverter;

ARCHITECTURE behavior OF hexaconverter IS

COMPONENT converter4bit PORT (
	number: IN STD_LOGIC_VECTOR(3 downto 0);
	leds: OUT STD_LOGIC_VECTOR(0 to 6)
);
END COMPONENT;
BEGIN
	first_display: converter4bit PORT MAP (number(3 downto 0), display0);
	second_display: converter4bit PORT MAP (number(7 downto 4), display1);
END;