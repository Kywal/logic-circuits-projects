library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hexaconverter is
    port (
        number: in STD_LOGIC_VECTOR(15 downto 0);
        display0: out STD_LOGIC_VECTOR(0 to 6);
        display1: out STD_LOGIC_VECTOR(0 to 6);
        display2: out STD_LOGIC_VECTOR(0 to 6);
        display3: out STD_LOGIC_VECTOR(0 to 6)
    );
end hexaconverter;

architecture behavior of hexaconverter is
    component converter4bit
        port (
            number: in STD_LOGIC_VECTOR(3 downto 0);
            leds: out STD_LOGIC_VECTOR(0 to 6)
        );
    end component;
begin
    first_display: converter4bit port map (number(3 downto 0), display0);
    second_display: converter4bit port map (number(7 downto 4), display1);
    third_display: converter4bit port map (number(11 downto 8), display2);
    fourth_display: converter4bit port map (number(15 downto 12), display3);
end behavior;

