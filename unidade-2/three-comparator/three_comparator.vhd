LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY three_comparator IS
	PORT(
			a, b, c: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			s1, s2, s3: OUT STD_LOGIC
		);
END three_comparator;

ARCHITECTURE behavior OF three_comparator IS
BEGIN
	
	a <=
	

	P1: PROCESS(a, b, c)
		BEGIN
			IF (a > b AND a > c) OR (b > a AND b > c) OR (c > a AND c > b) THEN 
				s1 <= '1';
				s2 <= '0';
				s3 <= '0';
			ELSIF (a = b AND a > c) OR (a = c AND a > b) OR (b = c AND b > a) THEN
				s1 <= '0';
				s2 <= '1';
				s3 <= '0';
			ELSE
				s1 <= '0';
				s2 <= '0';
				s3 <= '1';
			END IF;
		END PROCESS P1;	
END behavior;