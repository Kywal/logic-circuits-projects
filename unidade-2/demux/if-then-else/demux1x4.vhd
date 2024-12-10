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
		IF s = "00" THEN
			x(0) <= f;
			x(1) <= '0';
			x(2) <= '0';
			x(3) <= '0';
		ELSIF s = "01" THEN
			x(0) <= '0';
			x(1) <= f;
			x(2) <= '0';
			x(3) <= '0';
		ELSIF s = "10" THEN
			x(0) <= '0';
			x(1) <= '0';
			x(2) <= f;
			x(3) <= '0';
		ELSE
			x(0) <= '0';
			x(1) <= '0';
			x(2) <= '0';
			x(3) <= f;
		END IF;
	END PROCESS P1;
END demux;
	