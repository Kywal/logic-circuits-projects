
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY tb_calculadora IS
END tb_calculadora;

ARCHITECTURE behavior OF tb_calculadora IS
    -- Componentes internos da calculadora
    COMPONENT calculadora
    PORT (
        val_in      : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);  -- Valor de entrada para A ou B
        op          : IN  STD_LOGIC;                     -- OP=0 para soma, OP=1 para subtração
        ler_a_ctrl  : IN  STD_LOGIC;                     -- Controle para leitura de A
        ler_b_ctrl  : IN  STD_LOGIC;                     -- Controle para leitura de B
        resultado   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Resultado da operação
        luz_soma    : OUT STD_LOGIC;                     -- Acende se for soma
        luz_subt    : OUT STD_LOGIC                      -- Acende se for subtração
    );
    END COMPONENT;

    -- Sinais para conectar o componente de teste
    SIGNAL val_in      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL op          : STD_LOGIC := '0';
    SIGNAL ler_a_ctrl  : STD_LOGIC := '1';
    SIGNAL ler_b_ctrl  : STD_LOGIC := '1';
    SIGNAL resultado   : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL luz_soma    : STD_LOGIC := '0'; -- estágio inicial de soma
    SIGNAL luz_subt    : STD_LOGIC := '1';

BEGIN
    -- Instância da calculadora
    uut: calculadora
    PORT MAP (
        val_in      => val_in,
        op          => op,
        ler_a_ctrl  => ler_a_ctrl,
        ler_b_ctrl  => ler_b_ctrl,
        resultado   => resultado,
        luz_soma    => luz_soma,
        luz_subt    => luz_subt
    );

    -- Processo de estímulo para testar a calculadora
    PROCESS
    BEGIN
        -- Teste 1: Soma de 1 + 1
        -- Configuração
        val_in <= "00000001";  -- Entrada = 1
        ler_a_ctrl <= '1';     -- Ler A
        ler_b_ctrl <= '1';     -- Ler B
        op <= '0';             -- Soma

        -- Espera por 20 ns para verificar os resultados
        WAIT FOR 20 ns;

        -- Testa o resultado da soma
        ASSERT resultado = "00000010" REPORT "Erro no teste 1: 1 + 1" SEVERITY WARNING;
        -- Reset entradas
        ler_a_ctrl <= '0';     -- Reset
        ler_b_ctrl <= '0';     -- Reset

        -- Teste 2: Soma de 5 + 5
        val_in <= "00000101";  -- Entrada = 5
        ler_a_ctrl <= '1';     -- Ler A
        ler_b_ctrl <= '1';     -- Ler B
        op <= '0';             -- Soma

        WAIT FOR 20 ns;

        ASSERT resultado = "00001010" REPORT "Erro no teste 2: 5 + 5"
        SEVERITY WARNING;
        ler_a_ctrl <= '0';     -- Reset
        ler_b_ctrl <= '0';     -- Reset

        -- Teste 3: Subtração de 1 - 1
        val_in <= "00000001";  -- Entrada = 1
        ler_a_ctrl <= '1';     -- Ler A
        ler_b_ctrl <= '1';     -- Ler B
        op <= '1';             -- Subtração

        WAIT FOR 20 ns;

        ASSERT resultado = "00000000" REPORT "Erro no teste 3: 1 - 1"
        SEVERITY WARNING;
        ler_a_ctrl <= '0';     -- Reset
        ler_b_ctrl <= '0';     -- Reset

        -- Teste 4: Subtração de 10 - 2
        val_in <= "00001010";  -- A = 10
        ler_a_ctrl <= '1';     -- Ler A
        ler_b_ctrl <= '0';     -- Não ler B
        
        val_in <= "00000010";  -- B = 2
        ler_a_ctrl <= '0';     -- Não ler A
        ler_b_ctrl <= '1';     -- Ler B
        op <= '1';             -- Subtração

        WAIT FOR 20 ns;

        ASSERT resultado = "00001000" REPORT "Erro no teste 4: 20 - 2"
        SEVERITY WARNING;
        ler_a_ctrl <= '0';     -- Reset
        ler_b_ctrl <= '0';     -- Reset
        
        wait;
        
    END PROCESS;
END behavior;
