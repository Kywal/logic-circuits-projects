
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY deslocador_tb IS
END deslocador_tb;

ARCHITECTURE testbench OF deslocador_tb IS
    -- Declaração do componente a ser testado
    COMPONENT deslocador
    PORT (
        e       : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        desloca : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
        s       : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
    END COMPONENT;

    -- Sinais para conectar ao componente
    SIGNAL e       : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL desloca : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL s       : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    -- Instanciação do deslocador
    uut: deslocador PORT MAP (
        e => e,
        desloca => desloca,
        s => s
    );

    -- Processo de estimulação
    stim_proc: PROCESS
    BEGIN
        -- Teste 1: Carga Paralela
        desloca <= "00";
        e <= "11001010";
        WAIT FOR 10 ns;
        ASSERT s = "11001010"
        REPORT "Erro no Teste 1: Carga Paralela" SEVERITY WARNING;

        -- Teste 2: Deslocamento à Direita
        desloca <= "01";
        e <= "11001010";
        WAIT FOR 10 ns;
        ASSERT s = "01100101"
        REPORT "Erro no Teste 2: Deslocamento à Direita" SEVERITY WARNING;

        -- Teste 3: Deslocamento à Esquerda
        desloca <= "10";
        e <= "11001010";
        WAIT FOR 10 ns;
        ASSERT s = "10010100"
        REPORT "Erro no Teste 3: Deslocamento à Esquerda" SEVERITY WARNING;

        -- Teste 4: Carga Paralela (Valor Diferente)
        desloca <= "00";
        e <= "10101010";
        WAIT FOR 10 ns;
        ASSERT s = "10101010"
        REPORT "Erro no Teste 4: Carga Paralela com outro valor" SEVERITY WARNING;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;

END testbench;
