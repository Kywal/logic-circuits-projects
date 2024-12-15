LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY somador_subtrator IS
PORT (
    a, b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    op :   IN STD_LOGIC;
    resultado     : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
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
	
    SIGNAL val_a_interno            : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
    SIGNAL val_b_interno            : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
    SIGNAL carries          : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
    SIGNAL resultado_signal : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
    SIGNAL carry_out : STD_LOGIC;

BEGIN

    val_b_interno <= b WHEN op = '0' ELSE NOT b;
    resultado <= resultado_signal;

    -- Instâncias dos somadores
    s1 : somador PORT MAP (a => a(0), b => val_b_interno(0), cin => op,  cout => carries(1), resultado => resultado_signal(0));
    s2 : somador PORT MAP (a => a(1), b => val_b_interno(1), cin => carries(1), cout => carries(2), resultado => resultado_signal(1));
    s3 : somador PORT MAP (a => a(2), b => val_b_interno(2), cin => carries(2), cout => carries(3), resultado => resultado_signal(2)); 
    s4 : somador PORT MAP (a => a(3), b => val_b_interno(3), cin => carries(3), cout => carries(4), resultado => resultado_signal(3)); 
    s5 : somador PORT MAP (a => a(4), b => val_b_interno(4), cin => carries(4), cout => carries(5), resultado => resultado_signal(4)); 
    s6 : somador PORT MAP (a => a(5), b => val_b_interno(5), cin => carries(5), cout => carries(6), resultado => resultado_signal(5)); 
    s7 : somador PORT MAP (a => a(6), b => val_b_interno(6), cin => carries(6), cout => carries(7), resultado => resultado_signal(6)); 
    s8 : somador PORT MAP (a => a(7), b => val_b_interno(7), cin => carries(7), cout => carries(8), resultado => resultado_signal(7)); 
    s9 : somador PORT MAP (a => a(8), b => val_b_interno(8), cin => carries(8), cout => carries(9), resultado => resultado_signal(8)); 
    s10 : somador PORT MAP (a => a(9), b => val_b_interno(9), cin => carries(9), cout => carries(10), resultado => resultado_signal(9)); 
    s11 : somador PORT MAP (a => a(10), b => val_b_interno(10), cin => carries(10), cout => carries(11), resultado => resultado_signal(10)); 
    s12 : somador PORT MAP (a => a(11), b => val_b_interno(11), cin => carries(11), cout => carries(12), resultado => resultado_signal(11)); 
    s13 : somador PORT MAP (a => a(12), b => val_b_interno(12), cin => carries(12), cout => carries(13), resultado => resultado_signal(12)); 
    s14 : somador PORT MAP (a => a(13), b => val_b_interno(13), cin => carries(13), cout => carries(14), resultado => resultado_signal(13)); 
    s15 : somador PORT MAP (a => a(14), b => val_b_interno(14), cin => carries(14), cout => carries(15), resultado => resultado_signal(14)); 
    s16 : somador PORT MAP (a => a(15), b => val_b_interno(15), cin => carries(15), cout => carry_out, resultado => resultado_signal(15)); 

END;
