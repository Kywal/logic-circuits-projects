LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY deslocador IS
PORT (
    entrada           : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
    modo_deslocamento : IN  STD_LOGIC;  --  "0" <== pra esquerda | "1" ==> pra direita 
    saida             : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
    cout              : OUT STD_LOGIC
);
END deslocador;

ARCHITECTURE behavior OF deslocador IS

BEGIN

    PROCESS (entrada, modo_deslocamento)
    BEGIN

        IF ((entrada(15) = '1' AND modo_deslocamento = '0') OR (entrada(0) = '1' AND modo_deslocamento = '1')) THEN
            cout <= '1';
        ELSE
            cout <= '0';
        END IF;

        CASE modo_deslocamento IS
            WHEN '0' => saida <= entrada(14 DOWNTO 0) & '0'; -- Deslocamento para a esquerda
            WHEN '1' => saida <= '0' & entrada(15 DOWNTO 1); -- Deslocamento para a direita
            WHEN OTHERS => saida <= entrada; -- Valor padrão
        END CASE;
    END PROCESS;


END behavior;
