LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY logico IS
PORT (
    a, b      : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
    sel       : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
    resultado_logico : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
);
END logico;

ARCHITECTURE comportamental OF logico IS

BEGIN
    PROCESS (a, b, sel)
    BEGIN
        CASE sel IS
        WHEN "00" => resultado_logico <= a AND b;
        WHEN "01" => resultado_logico <= a OR b;
        WHEN "10" => resultado_logico <= a XOR b;
        WHEN "11" => resultado_logico <= a XNOR b;
        WHEN OTHERS => resultado_logico <= (others => '0');
        END CASE;
    END PROCESS;
END comportamental;
