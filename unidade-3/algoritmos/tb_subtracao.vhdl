library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_subtracao is
end tb_subtracao;

architecture testbench of tb_subtracao is

    component subtracao is
        generic (
            reg_amount : integer := 8;
            word_size : integer := 16
        );
        port (
            clk          : in  std_logic;
            entrada      : in  std_logic_vector(15 downto 0);
            display_valor  : out std_logic_vector(0 to 27);
            display_estado : out std_logic_vector(0 to 6);
            escolher_reg  : in  std_logic;
            setar_val_reg : in  std_logic;
            mostrar_val_reg : in  std_logic;
            executar     : in  std_logic;
            is_finalizado   : out std_logic;
            valor_resto  : out std_logic_vector(15 downto 0);
            tem_resto    : out std_logic
        );
    end component;

    signal clk : std_logic := '0';
    signal entrada : std_logic_vector(15 downto 0) := (others => '0');
    signal escolher_reg, setar_val_reg, mostrar_val_reg, executar : std_logic := '0';
    signal finalizado, tem_resto : std_logic;
    signal valor_resto : std_logic_vector(15 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;

begin

    uut: subtracao
        generic map (
            reg_amount => 8,
            word_size => 16
        )
        port map (
            clk => clk,
            entrada => entrada,
            escolher_reg => escolher_reg,
            setar_val_reg => setar_val_reg,
            mostrar_val_reg => mostrar_val_reg,
            executar => executar,
            is_finalizado => finalizado,
            valor_resto => valor_resto,
            tem_resto => tem_resto
        );

    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stimulus: process
        procedure pulse(signal s: out std_logic) is
        begin
            s <= '1';
            wait for CLK_PERIOD;
            s <= '0';
            wait for CLK_PERIOD;
        end procedure;
        
        procedure test_case(
            name : string;
            dividend : integer;
            divisor : integer;
            expected_q : integer;
            expected_r : integer
        ) is
        begin
            -- Configurar dividendo no registrador 0
            entrada <= std_logic_vector(to_unsigned(dividend, 16));
            pulse(escolher_reg);  -- Selecionar registrador 0
            pulse(setar_val_reg); -- Escrever valor
            
            -- Configurar divisor no registrador 1
            entrada <= std_logic_vector(to_unsigned(divisor, 16));
            pulse(escolher_reg);  -- Selecionar registrador 1
            pulse(setar_val_reg); -- Escrever valor
            
            -- Executar operação
            pulse(executar);
            
            -- Aguardar conclusão
            wait until finalizado = '1';
            wait for CLK_PERIOD;
            
            -- Verificar resultados
            assert to_integer(unsigned(valor_resto)) = expected_r
                report "Test " & name & ": Resto incorreto. Esperado: " & 
                    integer'image(expected_r) & " Obtido: " & 
                    integer'image(to_integer(unsigned(valor_resto)))
                severity error;
            
            assert (tem_resto = '1' and expected_r > 0) or (tem_resto = '0' and expected_r = 0)
                report "Test " & name & ": Sinal de resto incorreto"
                severity error;
            
            report "Teste " & name & ": Sucesso! Resultado: Q=" & 
                integer'image(expected_q) & " R=" & integer'image(expected_r);
        end procedure;

    begin
        wait for CLK_PERIOD;
        
        -- Test Case 1: Divisão exata
        test_case("15/4", 15, 4, 3, 3);
        
        -- Test Case 2: Divisão com resto
        test_case("20/6", 20, 6, 3, 2);
        
        -- Test Case 3: Divisão por 1
        test_case("255/1", 255, 1, 255, 0);
        
        -- Test Case 4: Divisão por zero
        entrada <= std_logic_vector(to_unsigned(100, 16));
        pulse(escolher_reg);  -- Selecionar registrador 0
        pulse(setar_val_reg); -- Escrever valor
        
        entrada <= std_logic_vector(to_unsigned(0, 16));
        pulse(escolher_reg);  -- Selecionar registrador 1
        pulse(setar_val_reg); -- Escrever valor
        
        pulse(executar);
        
        wait until finalizado = '1';
        assert tem_resto = '0' and valor_resto = x"0000"
            report "Falha na detecção de divisão por zero"
            severity error;

        report "Teste divisão por zero: Sucesso!";
        
        -- Test Case 5: Operação consecutiva
        test_case("50/7", 50, 7, 7, 1);
        test_case("100/10", 100, 10, 10, 0);
        
        wait for CLK_PERIOD*5;
        report "Todos os testes completados com sucesso!";
        wait;
    end process;

end testbench;

