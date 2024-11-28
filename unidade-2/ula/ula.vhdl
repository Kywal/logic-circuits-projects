
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ula IS 
PORT (
	a, b      : IN  std_logic_vector (7 DOWNTO 0);
	sel       : IN  std_logic_vector (3 DOWNTO 0);
	cout      : OUT std_logic;
	f         : OUT std_logic_vector (7 DOWNTO 0)
);
END ula;

ARCHITECTURE estrutural OF ula IS

COMPONENT logico 
port (  a, b      : IN  std_logic_vector (7 DOWNTO 0);
	sel       : IN  std_logic_VECTOR (3 DOWNTO 0);
	i1, i2    : OUT std_Logic_vector (7 DOWNTO 0);
	c0 	  : OUT std_logic);
END COMPONENT;

COMPONENT somador
port (
	a, b : IN  std_logic_vector (7 DOWNTO 0);
	cin  : IN  std_logic;
	s    : OUT std_Logic_vector (7 DOWNTO 0);
	cout : OUT std_logic
);
END COMPONENT;


SIGNAL ia, ib : std_logic_vector (7 DOWNTO 0);
SIGNAL cin    : std_logic;

BEGIN
	i0 : logico  PORT MAP (a, b, sel, ia, ib, cin);
	i1 : somador PORT MAP (ia, ib, cin, f, cout);
END estrutural;





