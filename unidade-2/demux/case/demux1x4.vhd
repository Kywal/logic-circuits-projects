LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY demux1x4 IS PORT (
	f: IN STD_LOGIC;
	x: OUT STD_LOGIC_VECTOR(3 downto 0);
	s: IN STD_LOGIC_VECTOR(1 downto 0)
	);
END demux1x4;

ARCHITECTURE demux OF demux1x4 IS

BEGIN
	P1: PROCESS(f, s)
	BEGIN
		CASE s IS
			WHEN "00" =>
				x(0) <= f; x(1) <= '0'; x(2) <= '0'; x(3) <= '0';
			WHEN "01" => 
				x(0) <= '0'; x(1) <= f; x(2) <= '0'; x(3) <= '0';
			WHEN "10" =>
				x(0) <= '0'; x(1) <= '0'; x(2) <= f; x(3) <= '0';
			WHEN OTHERS => 
				x(0) <= '0'; x(1) <= '0'; x(2) <= '0'; x(3) <= f;
		END CASE;
	END PROCESS P1;
END demux;
	