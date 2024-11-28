LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY calculadora IS
PORT (
    a    : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);  -- Número A (8 bits)
    b    : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);  -- Número B (8 bits)
    op   : IN  STD_LOGIC;                      -- OP=0 para soma, OP=1 para subtração
    s    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);  -- Resultado da operação
    luz_soma : OUT STD_LOGIC;                      -- Luz1 acende se for soma
    luz_subt : OUT STD_LOGIC                       -- Luz2 acende se for subtração
);
END calculadora;

ARCHITECTURE arch OF calculadora IS
    SIGNAL b_compl_2 : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
    PROCESS (a, b, op)
    BEGIN

        IF op = '1' THEN
            b_compl_2 <= std_logic_vector(unsigned(b) + 1);
            S <= std_logic_vector(unsigned(a) - unsigned(b_compl_2));
        ELSE
            S <= std_logic_vector(unsigned(a) + unsigned(b));
        END IF;

        luz_soma <= op;
        luz_subt <= NOT op;

    END PROCESS;

END arch;

