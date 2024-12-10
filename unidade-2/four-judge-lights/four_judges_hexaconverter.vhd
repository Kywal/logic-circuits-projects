LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY hexaconverter IS PORT (
	j0, j1, j2, j3: IN STD_LOGIC;
	display0, display1, display2, display3: OUT STD_LOGIC_VECTOR(0 to 6)
);
END hexaconverter;

ARCHITECTURE behavior OF hexaconverter IS

COMPONENT converter4bit PORT (
	number: IN STD_LOGIC;
	leds: OUT STD_LOGIC_VECTOR(0 to 6)
);
END COMPONENT;
BEGIN
	first_display: converter4bit PORT MAP (j0, display0);
	second_display: converter4bit PORT MAP (j1, display1);
	third_display: converter4bit PORT MAP (j2, display2);
	fourth_display: converter4bit PORT MAP (j3, display3);
END;