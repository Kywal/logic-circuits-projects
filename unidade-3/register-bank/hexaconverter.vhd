LIBRARY IEEE;
LIBRARY KAILIB;
USE KAILIB.REGBANK_STATES.ALL;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY hexaconverter IS PORT (
	state: IN RegBank_states;
	reg: IN STD_LOGIC_VECTOR(2 downto 0);
	number: IN STD_LOGIC_VECTOR(15 downto 0);
	display0: OUT STD_LOGIC_VECTOR(0 to 6);
	display1: OUT STD_LOGIC_VECTOR(0 to 6);
	display2: OUT STD_LOGIC_VECTOR(0 to 6);
	display3: OUT STD_LOGIC_VECTOR(0 to 6);
	display4: OUT STD_LOGIC_VECTOR(0 to 6)
);
END hexaconverter;

ARCHITECTURE behavior OF hexaconverter IS

COMPONENT converter4bit PORT (
	state: IN RegBank_states;
	number: IN STD_LOGIC_VECTOR(3 downto 0);
	leds: OUT STD_LOGIC_VECTOR(0 to 6)
);
END COMPONENT;
BEGIN
	first_display: converter4bit PORT MAP (state, number(3 downto 0), display0);
	second_display: converter4bit PORT MAP (state, number(7 downto 4), display1);
	third_display: converter4bit PORT MAP (state, number(11 downto 8), display2);
	fourth_display: converter4bit PORT MAP (state, number(15 downto 12), display3);
	
	fifth_display: converter4bit PORT MAP (state, '0' & reg, display4);
END;