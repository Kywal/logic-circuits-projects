
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador_subtrator IS
PORT (
    a    : IN BIT_VECTOR (7 DOWNTO 0);
    b    : IN BIT_VECTOR (7 DOWNTO 0);
    op   : IN BIT;                           -- (0: soma, 1: subtração)
    cout : OUT BIT;
    resultado  : OUT BIT_VECTOR (7 DOWNTO 0) -- Resultado (soma ou subtração)
);
END somador_subtrator;

ARCHITECTURE mixed OF somador_subtrator IS
    COMPONENT somador PORT (
        a    : IN BIT;
        b    : IN BIT;
        cin  : IN BIT;
        cout : OUT BIT;
        resultado  : OUT BIT
    );
    END COMPONENT;

    SIGNAL b_signal     : BIT_VECTOR (7 DOWNTO 0); -- se for uma subtração esse valor é invertido (complemento de 1)  
    SIGNAL c     : BIT_VECTOR (7 DOWNTO 1);
BEGIN
    -- inversão de B com base na operação (op)
    GEN_B_MOD: FOR i IN 0 TO 7 GENERATE
        b_signal(i) <= b(i) XOR op;
    END GENERATE;

    -- Instâncias dos somadores
    s1 : somador PORT MAP (a => a(0), b => b_signal(0), cin => op,  cout => c(1), resultado => resultado(0)); 
    s2 : somador PORT MAP (a => a(1), b => b_signal(1), cin => c(1), cout => c(2), resultado => resultado(1));
    s3 : somador PORT MAP (a => a(2), b => b_signal(2), cin => c(2), cout => c(3), resultado => resultado(2)); 
    s4 : somador PORT MAP (a => a(3), b => b_signal(3), cin => c(3), cout => c(4), resultado => resultado(3)); 
    s5 : somador PORT MAP (a => a(4), b => b_signal(4), cin => c(4), cout => c(5), resultado => resultado(4)); 
    s6 : somador PORT MAP (a => a(5), b => b_signal(5), cin => c(5), cout => c(6), resultado => resultado(5)); 
    s7 : somador PORT MAP (a => a(6), b => b_signal(6), cin => c(6), cout => c(7), resultado => resultado(6)); 
    s8 : somador PORT MAP (a => a(7), b => b_signal(7), cin => c(7), cout => cout, resultado => resultado(7)); 
END;

