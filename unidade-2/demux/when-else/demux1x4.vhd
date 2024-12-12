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
	a <= f WHEN s = "00" ELSE "00";
	b <= f WHEN s = "01" ELSE "00";
	c <= f WHEN s = "10" ELSE "00";
	d <= f WHEN s = "11" ELSE "00";
END demux;
	