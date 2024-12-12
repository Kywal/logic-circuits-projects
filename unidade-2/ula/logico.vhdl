LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY logico IS
PORT (
    a, b      : IN  std_logic_vector (15 DOWNTO 0);
    sel       : IN  std_logic_vector (3 DOWNTO 0);
    i1, i2    : OUT std_logic_vector (15 DOWNTO 0);
    c0        : OUT std_logic
);
END logico;

ARCHITECTURE comportamental OF logico IS

BEGIN
    PROCESS (a, b, sel)
    BEGIN
        CASE sel IS
        WHEN "100" =>  -- AND
            i1 <= a AND b;
            i2 <= "00000000";
            c0 <= '0';
        WHEN "101" =>  -- OR
            i1 <= a OR b;
            i2 <= "00000000";
            c0 <= '0';
        WHEN "110" =>  -- XOR
            i1 <= a XOR b;
            i2 <= "00000000";
            c0 <= '0';
        WHEN "111" =>  -- XNOR
            i1 <= a XNOR b;
            i2 <= "00000000";
            c0 <= '0';
        WHEN OTHERS =>
            i1 <= "00000000";
            i2 <= "00000000";
            c0 <= '0';
        END CASE;
    END PROCESS;
END comportamental;
