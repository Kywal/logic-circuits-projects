LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY demux1x4 IS PORT (
	f: IN STD_LOGIC;
	a,b,c,d : OUT STD_LOGIC;
	s: IN STD_LOGIC_VECTOR(1 downto 0)
	);
END demux1x4;

ARCHITECTURE demux OF demux1x4 IS

BEGIN
	P1: PROCESS(f, s)
	BEGIN
		CASE s IS
			WHEN "00" =>
				a <= f; b <= '0'; c <= '0'; d <= '0';
			WHEN "01" => 
				a <= '0'; b <= f; c <= '0'; d <= '0';
			WHEN "10" =>
				a <= '0'; b <= '0'; c <= f; d <= '0';
			WHEN OTHERS => 
				a <= '0'; b <= '0'; c <= '0'; d <= f;
		END CASE;
	END PROCESS P1;
END demux;
	