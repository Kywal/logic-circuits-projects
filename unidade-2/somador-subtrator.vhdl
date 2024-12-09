
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador_subtrator IS
PORT (

    val_in        : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    op            : IN STD_LOGIC;                           -- (1: soma, 0: subtração)
    carry_out     : OUT STD_LOGIC;
    resultado     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);      -- Resultado (soma ou subtração)
    op_led        : OUT STD_LOGIC;

    -- estados do programa (indicados pelo último botão pressionado)
    -- 0 é HIGH, 1 é LOW (o sentido dos valores lógicos da placa que usamos é invertido)
    ler_a              : IN STD_LOGIC;
    ler_b              : IN STD_LOGIC;
    exibir_resultado   : IN STD_LOGIC;

    lendo_a : OUT STD_LOGIC;
    lendo_b : OUT STD_LOGIC;
    exibindo : OUT STD_LOGIC;

-- Novas portas de saída para A e B
    A_out         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);      -- Saída do valor de A
    B_out         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)       -- Saída do valor de B
);
END somador_subtrator;

ARCHITECTURE structural OF somador_subtrator IS
    COMPONENT somador PORT (
        a          : IN STD_LOGIC;
        b          : IN STD_LOGIC;
        cin        : IN STD_LOGIC;
        cout       : OUT STD_LOGIC;
        resultado  : OUT STD_LOGIC
    );
    END COMPONENT;

    SIGNAL val_a     : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL val_b     : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL carries     : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
	 SIGNAL signal_resultado     : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');

BEGIN

    PROCESS (ler_a, ler_b, exibir_resultado, op)
    BEGIN
        if ler_a = '0' then -- logica invertida
            lendo_a <= '1';
            lendo_b <= '0';
            exibindo <= '0';

            val_a <= val_in;
        elsif ler_b = '0' then -- logica invertida
            lendo_a  <= '0';
            lendo_b  <= '1';
            exibindo <= '0';

            if op = '0' then
                val_b <= val_in; -- inverte o valor de B caso a operação seja soma (op = 0). XOR exige vetores de mesmo tamanho.
            elsif op = '0' then
                val_b <= NOT val_in; -- inverte o valor de B caso a operação seja subtração (op = 1). XOR exige vetores de mesmo tamanho.
            end if;

        elsif exibir_resultado = '0' then -- logica invertida
            lendo_a  <= '0';
            lendo_b  <= '0';
            exibindo <= '1';
            
        end if;

    END PROCESS;
  -- Atribuição das saídas A_out e B_out com os valores de A e B

    A_out <= val_a;  -- Saída de A
    B_out <= val_b;  -- Saída de B
    op_led <= NOT op;
	 
	 resultado <= val_a;

    -- Instâncias dos somadores
    s1 : somador PORT MAP (a => val_a(0), b => val_b(0), cin => op,  cout => carries(1), resultado => signal_resultado(0)); -- o OP no carry carrega o +1 do complemento de 2 da subtração
    s2 : somador PORT MAP (a => val_a(1), b => val_b(1), cin => carries(1), cout => carries(2), resultado => signal_resultado(1));
    s3 : somador PORT MAP (a => val_a(2), b => val_b(2), cin => carries(2), cout => carries(3), resultado => signal_resultado(2)); 
    s4 : somador PORT MAP (a => val_a(3), b => val_b(3), cin => carries(3), cout => carries(4), resultado => signal_resultado(3)); 
    s5 : somador PORT MAP (a => val_a(4), b => val_b(4), cin => carries(4), cout => carries(5), resultado => signal_resultado(4)); 
    s6 : somador PORT MAP (a => val_a(5), b => val_b(5), cin => carries(5), cout => carries(6), resultado => signal_resultado(5)); 
    s7 : somador PORT MAP (a => val_a(6), b => val_b(6), cin => carries(6), cout => carries(7), resultado => signal_resultado(6)); 
    s8 : somador PORT MAP (a => val_a(7), b => val_b(7), cin => carries(7), cout => carry_out, resultado => signal_resultado(7)); 

END;
