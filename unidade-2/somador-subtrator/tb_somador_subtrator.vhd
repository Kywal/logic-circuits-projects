
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; -- Para conversões e operações matemáticas

ENTITY tb_somador_subtrator IS
END tb_somador_subtrator;

ARCHITECTURE behavior OF tb_somador_subtrator IS
    -- Component do módulo a ser testado
    COMPONENT somador_subtrator
    PORT(
        val_in        : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        op            : IN STD_LOGIC;
        carry_out     : OUT STD_LOGIC;
        resultado     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        ler_a         : IN STD_LOGIC;
        ler_b         : IN STD_LOGIC;
        default_state : OUT STD_LOGIC;
        A_out         : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        B_out         : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
    END COMPONENT;

    -- Sinais internos para conectar ao DUT
    SIGNAL val_in        : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL op            : STD_LOGIC;
    SIGNAL carry_out     : STD_LOGIC;
    SIGNAL resultado     : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL ler_a         : STD_LOGIC;
    SIGNAL ler_b         : STD_LOGIC;
    SIGNAL default_state : STD_LOGIC;
    SIGNAL A_out         : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL B_out         : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
    -- Instância do módulo DUT
    uut: somador_subtrator PORT MAP (
        val_in        => val_in,
        op            => op,
        carry_out     => carry_out,
        resultado     => resultado,
        ler_a         => ler_a,
        ler_b         => ler_b,
        default_state => default_state,
        A_out         => A_out,
        B_out         => B_out
    );

    -- Processo de estímulos
    stim_proc: PROCESS
    BEGIN
        -- Caso 1: 1 + 1
        val_in <= "00000001"; -- Entrada 1
        ler_a <= '0'; -- Carrega A
        ler_b <= '1';
        WAIT FOR 10 ns;
        
        ler_a <= '1';
        ler_b <= '0'; -- Carrega B
        WAIT FOR 10 ns;

        op <= '0'; -- Operação de soma
        WAIT FOR 20 ns;

        -- Caso 2: 5 + 5
        val_in <= "00000101"; -- Entrada 5
        ler_a <= '0'; -- Carrega A
        ler_b <= '1';
        WAIT FOR 10 ns;

        ler_a <= '1';
        ler_b <= '0'; -- Carrega B
        WAIT FOR 10 ns;

        op <= '0'; -- Operação de soma
        WAIT FOR 20 ns;

        -- Caso 3: 1 - 1
        val_in <= "00000001"; -- Entrada 1
        ler_a <= '0'; -- Carrega A
        ler_b <= '1';
        WAIT FOR 10 ns;

        ler_a <= '1';
        ler_b <= '0'; -- Carrega B
        WAIT FOR 10 ns;

        op <= '1'; -- Operação de subtração
        WAIT FOR 20 ns;

        -- Caso 4: 10 - 2
        val_in <= "00001010"; -- Entrada 10
        ler_a <= '0'; -- Carrega A
        ler_b <= '1';
        WAIT FOR 10 ns;

        val_in <= "00000010"; -- Entrada 2
        ler_a <= '1';
        ler_b <= '0'; -- Carrega B
        WAIT FOR 10 ns;

        op <= '1'; -- Operação de subtração
        WAIT FOR 20 ns;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;

END behavior;
