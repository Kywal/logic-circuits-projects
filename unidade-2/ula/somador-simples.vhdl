
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador_simples IS
PORT (
    a    : IN std_logic;
    b    : IN std_logic;
    cin  : IN std_logic;
    cout : OUT std_logic;
    resultado  : OUT std_logic
);
END somador_simples;

ARCHITECTURE behavioral OF somador_simples IS
BEGIN
    resultado  <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND (a XOR b));
END behavioral;

