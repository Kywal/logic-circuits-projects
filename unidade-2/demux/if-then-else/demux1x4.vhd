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
		IF s = "00" THEN
			a <= f;
			b <= '0';
			c <= '0';
			d <= '0';
		ELSIF s = "01" THEN
			a <= '0';
			b <= f;
			c <= '0';
			d <= '0';
		ELSIF s = "10" THEN
			a <= '0';
			b <= '0';
			c <= f;
			d <= '0';
		ELSE
			a <= '0';
			b <= '0';
			c <= '0';
			d <= f;
		END IF;
	END PROCESS P1;
END demux;
	