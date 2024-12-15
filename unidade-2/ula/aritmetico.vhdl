LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY aritmetico IS
PORT (
    a, b      : IN  std_logic_vector (15 DOWNTO 0);
    sel       : IN  std_logic_vector (1 DOWNTO 0);
    resultado_arit    : OUT std_logic_vector (15 DOWNTO 0);
    cout : OUT STD_LOGIC
);
END aritmetico;

ARCHITECTURE arit_comportamental OF aritmetico IS

    COMPONENT somador_subtrator
    PORT (
        a, b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        op :   IN STD_LOGIC;
        resultado     : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
    END COMPONENT;

    COMPONENT deslocador
    PORT (
        entrada           : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        modo_deslocamento : IN  STD_LOGIC;  --  "0" <== pra esquerda | "1" ==> pra direita 
        saida             : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        cout              : OUT STD_LOGIC
    );
    END COMPONENT;

    SIGNAL resultado_somador : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL resultado_deslocador : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL cout_somador : STD_LOGIC;
    SIGNAL cout_deslocador : STD_LOGIC;

BEGIN

    PROCESS (sel, resultado_somador, resultado_deslocador)
    BEGIN
        CASE sel(1) IS
            WHEN '0' => 
                resultado_arit <= resultado_somador;
                cout <= cout_somador;
            WHEN '1' => 
                resultado_arit <= resultado_deslocador;
                cout <= cout_deslocador;
            WHEN OTHERS => resultado_arit <= (OTHERS => '0'); -- Valor padrão para casos não especificados
        END CASE;
    END PROCESS;

    deslocador_inst: deslocador
     port map(
        entrada => a,
        modo_deslocamento => sel(0),
        saida => resultado_deslocador,
        cout => cout_deslocador
    );

    somador_subtrator_inst: somador_subtrator
     port map(
        a => a,
        b => b,
        op => sel(0),
        resultado => resultado_somador,
        cout => cout_somador
   );

END arit_comportamental;
