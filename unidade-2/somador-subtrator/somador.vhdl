
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador IS
PORT (
    a    : IN BIT;
    b    : IN BIT;
    cin  : IN BIT;
    cout : OUT BIT;
    resultado  : OUT BIT
);
END somador;

ARCHITECTURE behavioral OF somador IS
BEGIN
    resultado  <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND (a XOR b));
END behavioral;

