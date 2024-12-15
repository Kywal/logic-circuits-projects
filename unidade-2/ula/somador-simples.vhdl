
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador IS
PORT (
    a    : IN std_logic;
    b    : IN std_logic;
    cin  : IN std_logic;
    cout : OUT std_logic;
    resultado  : OUT std_logic
);
END somador;

ARCHITECTURE behavioral OF somador IS
BEGIN
    resultado  <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND (a XOR b));
END behavioral;

