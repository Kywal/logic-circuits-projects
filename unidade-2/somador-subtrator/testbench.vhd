
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is
    -- Componente DUT (Dispositivo sob Teste)
    component somador_subtrator is
        port (
            val_in        : in  std_logic_vector(7 downto 0);
            op            : in  std_logic;
            carry_out     : out std_logic;
            resultado     : out std_logic_vector(7 downto 0);
            default_state : out std_logic;
            ler_a         : in  std_logic;
            ler_b         : in  std_logic
        );
    end component;

    -- Sinais para o testbench
    signal val_in   : std_logic_vector(7 downto 0);
    signal op       : std_logic;
    signal A_out    : std_logic_vector(7 downto 0);
    signal B_out    : std_logic_vector(7 downto 0);
    signal Resultado_out : std_logic_vector(7 downto 0);
    signal CarryOut_out  : std_logic;
    signal DefaultState_out : std_logic;
    signal ler_a    : std_logic;
    signal ler_b    : std_logic;

begin
    -- Instância do DUT
    DUT: somador_subtrator
        port map (
            val_in => val_in,
            op => op,
            carry_out => CarryOut_out,
            resultado => Resultado_out,
            default_state => DefaultState_out,
            ler_a => ler_a,
            ler_b => ler_b
        );

    -- Processo de teste
    process
    begin
        -- Teste de soma (A = 1, B = 1)
        val_in <= "00000001";  -- Entrada = 15
        ler_a <= '1';          -- Ler A
        ler_b <= '0';          -- Não ler B
        wait for 10 ns;        -- Espera 10 ns para propagar

	ler_a <= '0';          -- Não ler A
	ler_b <= '1';          -- Ler B
	wait for 10 ns;


        op <= '0';             -- Soma (OP = 0)
        wait for 50 ns;        -- Espera 50 ns para propagar

        assert (Resultado_out = "00000010") report "Falha na soma (1 + 1)" severity error;  -- Resultado esperado = 2
        assert (A_out = "00000001") report "Falha na leitura de A" severity error;
        assert (B_out = "00000001") report "Falha na leitura de B" severity error;

        -- Intervalo entre os testes
        wait for 50 ns;        -- Intervalo de 50 ns antes do próximo teste

        -- Teste de soma (A = 5, B = 5)
        val_in <= "00000101";  -- Entrada = 5
        ler_a <= '1';          -- Ler A
        ler_b <= '0';          -- Não ler B
        wait for 10 ns;        -- Espera 10 ns para propagar

        ler_a <= '0';          -- Não ler A
        ler_b <= '1';          -- Ler B
        wait for 10 ns;

        op <= '0';             -- Soma (OP = 1)
        wait for 50 ns;        -- Espera 50 ns para propagar

        assert (Resultado_out = "00001010") report "Falha na soma (5 + 5)" severity error;  -- Resultado esperado = 10
        assert (A_out = "00000101") report "Falha na leitura de A" severity error;
        assert (B_out = "00000101") report "Falha na leitura de B" severity error;

        -- Intervalo entre os testes
        wait for 50 ns;        -- Intervalo de 50 ns antes do próximo teste

        -- Teste de subtração simples (A = 1, B = 1)
        val_in <= "00000001";  -- A = 1
        ler_a <= '1';          -- Ler A
        ler_b <= '0';          -- Não ler B
        wait for 10 ns;        -- Espera 10 ns para propagar

        ler_a <= '0';          -- Não ler A
        ler_b <= '1';          -- Ler B
        wait for 10 ns;        -- Espera 10 ns para propagar

        op <= '1';             -- Subtração (OP = 1)
        wait for 50 ns;        -- Espera 50 ns para propagar

        assert (Resultado_out = "00000000") report "Falha na subtração" severity error;  -- Resultado esperado = 0
        assert (A_out = "00000001") report "Falha na leitura de A" severity error;
        assert (B_out = "00000001") report "Falha na leitura de B" severity error;

        -- Intervalo entre os testes
        wait for 50 ns;        -- Intervalo de 50 ns antes do próximo teste


        -- Teste de subtração menos simples (A = 10, B = 8)
        val_in <= "00001010";  -- A = 10
        ler_a <= '1';          -- Ler A
        ler_b <= '0';          -- Não ler B
        wait for 10 ns;        -- Espera 10 ns para propagar

        val_in <= "00000010";  -- A = 10
        ler_a <= '0';          -- Não ler A
        ler_b <= '1';          -- Ler B
        wait for 10 ns;        -- Espera 10 ns para propagar

        op <= '1';             -- Subtração (OP = 1)
        wait for 50 ns;        -- Espera 50 ns para propagar

        assert (Resultado_out = "00000010") report "Falha na subtração" severity error;  -- Resultado esperado = 2
        assert (A_out = "00001010") report "Falha na leitura de A" severity error;
        assert (B_out = "00000010") report "Falha na leitura de B" severity error;

        -- Intervalo entre os testes
        wait for 50 ns;        -- Intervalo de 50 ns antes do próximo teste


        -- Finaliza o teste
        assert false report "Teste finalizado." severity note;
        wait;
    end process;
end tb;
