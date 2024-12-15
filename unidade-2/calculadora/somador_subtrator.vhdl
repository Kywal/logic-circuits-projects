
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador_subtrator IS
PORT (
    a, b        : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    op            : IN STD_LOGIC;	 
    carry_out     : OUT STD_LOGIC;
    resultado     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)      -- Resultado (soma ou subtração)
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
	 
	 SIGNAL novo_b, carries: STD_LOGIC_VECTOR(7 downto 0);
BEGIN

	 novo_b <= b WHEN op = '0' ELSE NOT b;
	 
    -- Instâncias dos somadores
    s1 : somador PORT MAP (a => a(0), b => novo_b(0), cin => op,  cout => carries(1), resultado => resultado(0));
    s2 : somador PORT MAP (a => a(1), b => novo_b(1), cin => carries(1), cout => carries(2), resultado => resultado(1));
    s3 : somador PORT MAP (a => a(2), b => novo_b(2), cin => carries(2), cout => carries(3), resultado => resultado(2)); 
    s4 : somador PORT MAP (a => a(3), b => novo_b(3), cin => carries(3), cout => carries(4), resultado => resultado(3)); 
    s5 : somador PORT MAP (a => a(4), b => novo_b(4), cin => carries(4), cout => carries(5), resultado => resultado(4)); 
    s6 : somador PORT MAP (a => a(5), b => novo_b(5), cin => carries(5), cout => carries(6), resultado => resultado(5)); 
    s7 : somador PORT MAP (a => a(6), b => novo_b(6), cin => carries(6), cout => carries(7), resultado => resultado(6)); 
    s8 : somador PORT MAP (a => a(7), b => novo_b(7), cin => carries(7), cout => carry_out, resultado => resultado(7)); 

END;
