
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY deslocador IS
PORT (
    e       : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    desloca : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);  --  "10" <== pra esquerda |  "00" == Carga paralela | "01" ==> pra direita 
    executa : IN  STD_LOGIC;
    s       : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END deslocador;

ARCHITECTURE behavior OF deslocador IS
BEGIN
    PROCESS(executa)
    BEGIN
        CASE desloca IS
            WHEN "00" => s <= e;
            WHEN "01" => s <= '0' & e(7 DOWNTO 1); -- appenda '0' no bit mais significativo
            WHEN "10" => s <= e(6 DOWNTO 0) & '0'; -- appenda '0' no bit menos significativo
            WHEN OTHERS => s <= e;
        END CASE;
    END PROCESS;
END behavior;

