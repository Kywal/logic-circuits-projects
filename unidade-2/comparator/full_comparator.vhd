LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY full_comparator IS
	PORT(
			a, b: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			s: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
		);
END full_comparator;


ARCHITECTURE behavior OF full_comparator IS

COMPONENT comparator_1_bit
	PORT(
			a, b: IN STD_LOGIC;
			i: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			s: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
		);
END COMPONENT;		
	
	SIGNAL f_b4: STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL f_b3: STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL f_b2: STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL f_b1: STD_LOGIC_VECTOR (2 DOWNTO 0);
	
BEGIN
	cb4: comparator_1_bit PORT MAP(a(4), b(4),"100",f_b4);
	cb3: comparator_1_bit PORT MAP(a(3), b(3),f_b4,f_b3);
	cb2: comparator_1_bit PORT MAP(a(2), b(2),f_b3,f_b2);
	cb1: comparator_1_bit PORT MAP(a(1), b(1),f_b2,f_b1);
	cb0: comparator_1_bit PORT MAP(a(0), b(0),f_b1,s);
END behavior;