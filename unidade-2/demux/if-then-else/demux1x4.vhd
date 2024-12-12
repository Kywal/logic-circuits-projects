LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY demux1x4 IS PORT (
	f: IN STD_LOGIC_VECTOR(1 downto 0);
	a, b, c, d: OUT STD_LOGIC_VECTOR(1 downto 0);
	s: IN STD_LOGIC_VECTOR(1 downto 0)
	);
END demux1x4;

ARCHITECTURE demux OF demux1x4 IS

BEGIN
	P1: PROCESS(f, s)
	BEGIN
		IF s = "00" THEN
			a <= f;
			b <= "00";
			c <= "00";
			d <= "00";
		ELSIF s = "01" THEN
			a <= "00";
			b <= f;
			c <= "00";
			d <= "00";
		ELSIF s = "10" THEN
			a <= "00";
			b <= "00";
			c <= f;
			d <= "00";
		ELSE
			a <= "00";
			b <= "00";
			c <= "00";
			d <= f;
		END IF;
	END PROCESS P1;
END demux;
	