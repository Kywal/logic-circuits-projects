
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY deslocador IS
PORT (
    entrada       : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
    modo_deslocamento : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);  --  "10" <== pra esquerda |  "00" == Carga paralela | "01" ==> pra direita 
    saida       : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
END deslocador;

ARCHITECTURE behavior OF deslocador IS

BEGIN

        WITH modo_deslocamento SELECT
            saida <= entrada WHEN "00",
                     '0' & entrada(15 DOWNTO 1) WHEN "01",
                     entrada(14 DOWNTO 0) & '0' WHEN "10",
                     entrada WHEN others;
END behavior;

