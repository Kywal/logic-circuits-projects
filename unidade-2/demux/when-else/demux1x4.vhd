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
	a <= f WHEN s = "00" ELSE '0';
	b <= f WHEN s = "01" ELSE '0';
	c <= f WHEN s = "10" ELSE '0';
	d <= f WHEN s = "11" ELSE '0';
END demux;
	