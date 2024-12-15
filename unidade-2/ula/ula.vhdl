LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ula IS
PORT (
    val_a, val_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    val_seletor : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    resultado   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- Resultado da operação
    cout        : OUT STD_LOGIC                      -- Carry-out
);
END ula;

ARCHITECTURE structural OF ula IS

    -- Declaração dos componentes aritmético e lógico

    COMPONENT aritmetico
    PORT (
        a, b : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        sel : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
        resultado_arit : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT logico
    PORT (
        a, b      : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        sel       : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
        resultado_logico : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    END COMPONENT;

    SIGNAL resultado_arit : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL resultado_logico : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    WITH val_seletor(2) SELECT
        resultado <= resultado_arit WHEN '0',
                     resultado_logico WHEN '1';

    -- Instância do componente lógico
    logico_inst: entity work.logico
     port map(
        a => val_a,
        b => val_b,
        sel => val_seletor(1 DOWNTO 0),
        resultado_logico => resultado_logico
    );

    -- Instância do componente aritmético
    aritmetico_inst : aritmetico
    PORT MAP (
        a      => val_a,
        b      => val_b,
        sel    => val_seletor(1 DOWNTO 0),
        resultado_arit => resultado_arit
    );

END structural;
