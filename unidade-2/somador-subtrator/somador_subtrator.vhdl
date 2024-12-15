
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador_subtrator IS
PORT (

    val_in        : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    op            : IN STD_LOGIC;     
	 
	 -- estados do programa (indicados pelo último botão pressionado)
    -- 0 é HIGH, 1 é LOW (o sentido dos valores lógicos da placa que usamos é invertido)
	 ler_a              : IN STD_LOGIC;
    ler_b              : IN STD_LOGIC;
    exibir_resultado   : IN STD_LOGIC;	 -- (1: soma, 0: subtração)
	 
	 
    carry_out     : OUT STD_LOGIC;
    resultado     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);      -- Resultado (soma ou subtração)
    op_led        : OUT STD_LOGIC
	 
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
	
	 SIGNAL novo_b           : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL val_a            : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL val_b            : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL saida            : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL carries          : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    SIGNAL resultado_signal : STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');

BEGIN

    PROCESS (ler_a, ler_b, exibir_resultado, op)
    BEGIN
        if ler_a = '0' then -- logica invertida
            val_a <= val_in;
        elsif ler_b = '0' then -- logica invertida
            val_b <= val_in;
        elsif exibir_resultado = '0' then -- logica invertida
            resultado <= resultado_signal;
        end if;

    END PROCESS;
  -- Atribuição das saídas A_out e B_out com os valores de A e B

    op_led <= op;
	 novo_b <= val_b WHEN op = '0' ELSE NOT val_b;

    -- Instâncias dos somadores
    s1 : somador PORT MAP (a => val_a(0), b => novo_b(0), cin => op,  cout => carries(1), resultado => resultado_signal(0));
    s2 : somador PORT MAP (a => val_a(1), b => novo_b(1), cin => carries(1), cout => carries(2), resultado => resultado_signal(1));
    s3 : somador PORT MAP (a => val_a(2), b => novo_b(2), cin => carries(2), cout => carries(3), resultado => resultado_signal(2)); 
    s4 : somador PORT MAP (a => val_a(3), b => novo_b(3), cin => carries(3), cout => carries(4), resultado => resultado_signal(3)); 
    s5 : somador PORT MAP (a => val_a(4), b => novo_b(4), cin => carries(4), cout => carries(5), resultado => resultado_signal(4)); 
    s6 : somador PORT MAP (a => val_a(5), b => novo_b(5), cin => carries(5), cout => carries(6), resultado => resultado_signal(5)); 
    s7 : somador PORT MAP (a => val_a(6), b => novo_b(6), cin => carries(6), cout => carries(7), resultado => resultado_signal(6)); 
    s8 : somador PORT MAP (a => val_a(7), b => novo_b(7), cin => carries(7), cout => carry_out, resultado => resultado_signal(7)); 

END;
