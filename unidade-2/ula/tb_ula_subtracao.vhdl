
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
        -- Teste 1: Subtração sem borrow
        val_a <= "0000000000001010"; -- 10
        val_b <= "0000000000000011"; -- 3
        val_seletor <= "001"; -- Seleciona subtração (aritmetico, sel="01")
        WAIT FOR 10 ns;
        
        ASSERT (resultado = "0000000000000111")
        REPORT "Teste 1 falhou" SEVERITY ERROR;

        -- Teste 2: Subtração resultando em zero
        val_a <= "0000000000001010"; -- 10
        val_b <= "0000000000001010"; -- 10
        val_seletor <= "001"; -- Seleciona subtração (aritmetico, sel="01")
        WAIT FOR 10 ns;

        ASSERT (resultado = "0000000000000000")
        REPORT "Teste 2 falhou" SEVERITY ERROR;

        -- Teste 3: Subtração com zero
        val_a <= "0000000000001010"; -- 10
        val_b <= "0000000000000000"; -- 0
        val_seletor <= "001"; -- Seleciona subtração (aritmetico, sel="01")
        WAIT FOR 10 ns;

        ASSERT (resultado = "0000000000001010")
        REPORT "Teste 3 falhou" SEVERITY ERROR;

        -- Finaliza a simulação
        WAIT;
    END PROCESS;

END behavior;
