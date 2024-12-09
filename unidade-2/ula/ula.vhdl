LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ula IS
PORT (
    val_in      : IN  std_logic_vector (7 DOWNTO 0);  -- Valor de entrada para A ou B
    sel         : IN  std_logic_vector (2 DOWNTO 0);  -- Seletor de operação
    ler_a       : IN  std_logic;                     -- Controle de leitura para A
    ler_b       : IN  std_logic;                     -- Controle de leitura para B
    resultado   : OUT std_logic_vector (7 DOWNTO 0); -- Resultado da operação
    cout        : OUT std_logic                      -- Carry-out
);
END ula;

ARCHITECTURE structural OF ula IS

    -- Declaração dos componentes aritmético e lógico
    COMPONENT aritmetico
    PORT (
        a, b      : IN  std_logic_vector (7 DOWNTO 0);
        sel       : IN  std_logic_vector (2 DOWNTO 0);
        i1, i2    : OUT std_logic_vector (7 DOWNTO 0);
        c0        : OUT std_logic
    );
    END COMPONENT;

    COMPONENT logico
    PORT (
        a, b      : IN  std_logic_vector (7 DOWNTO 0);
        sel       : IN  std_logic_vector (2 DOWNTO 0);
        i1, i2    : OUT std_logic_vector (7 DOWNTO 0);
        c0        : OUT std_logic
    );
    END COMPONENT;

    COMPONENT somador
    PORT (
        a, b      : IN  std_logic_vector (7 DOWNTO 0);
        cin       : IN  std_logic;
        s         : OUT std_logic_vector (7 DOWNTO 0);
        cout      : OUT std_logic
    );
    END COMPONENT;

    SIGNAL a_sig, b_sig : std_logic_vector (7 DOWNTO 0); -- Valores armazenados de A e B
    SIGNAL i1_sig, i2_sig : std_logic_vector (7 DOWNTO 0); -- Saídas intermediárias
    SIGNAL c0_sig : std_logic;

BEGIN

    -- Processamento de leitura dos valores A e B
    PROCESS (ler_a, ler_b, val_in)
    BEGIN
        IF ler_a = '0' THEN
            a_sig <= val_in;
        END IF;
        IF ler_b = '0' THEN
            b_sig <= val_in;
        END IF;
    END PROCESS;

    -- Instância do componente lógico
    logico_inst : logico
    PORT MAP (
        a      => a_sig,
        b      => b_sig,
        sel    => sel,
        i1     => i1_sig,
        i2     => i2_sig,
        c0     => c0_sig
    );

    -- Instância do componente aritmético
    aritmetico_inst : aritmetico
    PORT MAP (
        a      => a_sig,
        b      => b_sig,
        sel    => sel,
        i1     => i1_sig,
        i2     => i2_sig,
        c0     => c0_sig
    );

    -- Instância do somador para combinar os resultados
    somador_inst : somador
    PORT MAP (
        a      => i1_sig,
        b      => i2_sig,
        cin    => c0_sig,
        s      => resultado,
        cout   => cout
    );

END structural;
