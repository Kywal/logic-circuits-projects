
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador IS
PORT (
    a, b, cin    : IN STD_LOGIC;   -- Primeiro bit de entrada
    cout, resultado: OUT STD_LOGIC
);
END somador;

ARCHITECTURE behavioral OF somador IS
BEGIN
    -- Lógica do Somador Completo
    resultado  <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND (a XOR b));
END behavioral;

