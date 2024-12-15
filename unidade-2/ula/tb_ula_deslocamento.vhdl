
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_ula IS
END tb_ula;

ARCHITECTURE behavior OF tb_ula IS

    -- Componentes a serem testados
    COMPONENT ula
    PORT (
        val_a, val_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        val_seletor  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        resultado    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        cout         : OUT STD_LOGIC
    );
    END COMPONENT;

    -- Sinais para estimular o DUT (Device Under Test)
    SIGNAL val_a, val_b     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL val_seletor      : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL resultado        : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL cout             : STD_LOGIC;

BEGIN

    -- Instância da ULA
    uut: ula
        PORT MAP (
            val_a => val_a,
            val_b => val_b,
            val_seletor => val_seletor,
            resultado => resultado,
            cout => cout
        );

    -- Processo de estímulos
    stim_proc: PROCESS
    BEGIN

        -- Teste 4: Deslocamento à esquerda sem overflow
        val_a <= "0000000000000101"; -- 5
        val_b <= (OTHERS => '0'); -- Não utilizado
        val_seletor <= "010"; -- Seleciona deslocamento à esquerda (aritmetico, sel="10")
        WAIT FOR 10 ns;

        ASSERT (resultado = "0000000000001010") AND (cout = '0')
        REPORT "Teste 4 falhou" SEVERITY ERROR;

        -- Teste 5: Deslocamento à esquerda com overflow
        val_a <= "1000000000000000"; -- Valor com bit mais significativo em 1
        val_b <= (OTHERS => '0'); -- Não utilizado
        val_seletor <= "010"; -- Seleciona deslocamento à esquerda (aritmetico, sel="10")
        WAIT FOR 10 ns;

        ASSERT (resultado = "0000000000000000") AND (cout = '1')
        REPORT "Teste 5 falhou" SEVERITY ERROR;

        -- Teste 6: Deslocamento à direita sem sinal (bit de sinal preservado)
        val_a <= "0000000000001010"; -- 10
        val_b <= (OTHERS => '0'); -- Não utilizado
        val_seletor <= "011"; -- Seleciona deslocamento à direita (aritmetico, sel="01")
        WAIT FOR 10 ns;

        ASSERT (resultado = "0000000000000101") AND (cout = '0')
        REPORT "Teste 6 falhou" SEVERITY ERROR;

        -- Teste 7: Deslocamento à direita com sinal (bit mais significativo 1)
        val_a <= "1000000000000001"; -- Valor com bit mais significativo em 1
        val_b <= (OTHERS => '0'); -- Não utilizado
        val_seletor <= "011"; -- Seleciona deslocamento à direita (aritmetico, sel="01")
        WAIT FOR 10 ns;

        ASSERT (resultado = "0100000000000000") AND (cout = '1')
        REPORT "Teste 7 falhou" SEVERITY ERROR;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;

END behavior;
