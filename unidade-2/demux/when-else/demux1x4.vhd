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
	x(0) <= f WHEN s = "00" ELSE '0';
	x(1) <= f WHEN s = "01" ELSE '0';
	x(2) <= f WHEN s = "10" ELSE '0';
	x(3) <= f WHEN s = "11" ELSE '0';
END demux;
	