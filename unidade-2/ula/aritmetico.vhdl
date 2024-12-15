LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY aritmetico IS
PORT (
    a, b      : IN  std_logic_vector (15 DOWNTO 0);
    sel       : IN  std_logic_vector (1 DOWNTO 0);
    resultado_arit    : OUT std_logic_vector (15 DOWNTO 0)
);
END aritmetico;

ARCHITECTURE arit_comportamental OF aritmetico IS

    COMPONENT somador_subtrator
    PORT (
        a, b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        op :   IN STD_LOGIC;
        resultado     : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT deslocador
    PORT (
        entrada       : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        modo_deslocamento : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
        saida       : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    END COMPONENT;

    SIGNAL resultado_somador : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL resultado_deslocador : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL sel_somador_adapter : STD_LOGIC;

BEGIN
        WITH sel SELECT
            resultado_arit <= resultado_somador WHEN "00",
                              resultado_somador WHEN "01",
                              resultado_deslocador WHEN "10",
                              resultado_deslocador WHEN "11";

    deslocador_inst: deslocador
     port map(
        entrada => a,
        modo_deslocamento => sel,
        saida => resultado_deslocador
    );

    somador_subtrator_inst: somador_subtrator
     port map(
        a => a,
        b => b,
        op => sel(0),
        resultado => resultado_somador
    );
END arit_comportamental;
