
library ieee;
use ieee.std_logic_1164.all;

entity somador is
port (
	a, b : in  std_logic_vector (7 downto 0);
	cin  : in  std_logic;
	s    : out std_logic_vector (7 downto 0);
	cout : out std_logic
);
end somador;

architecture comportamental of somador is
	component somador_simples port (
		a, b, cin	: in std_logic;
		cout, resultado : out std_logic
	);
	end component;

	signal b_signal : std_logic_vector (7 downto 0); -- se for uma subtração esse valor é invertido (complemento de 1)  
	signal c	: std_logic_vector (7 downto 1);

begin
    gen_b_mod: for i in 0 to 7 generate
        b_signal(i) <= b(i);
    end generate;

    -- instâncias dos somadores
    s1 : somador_simples port map (a => a(0), b => b_signal(0), cin => '0',  cout => c(1), resultado => s(0)); 
    s2 : somador_simples port map (a => a(1), b => b_signal(1), cin => c(1), cout => c(2), resultado => s(1));
    s3 : somador_simples port map (a => a(2), b => b_signal(2), cin => c(2), cout => c(3), resultado => s(2)); 
    s4 : somador_simples port map (a => a(3), b => b_signal(3), cin => c(3), cout => c(4), resultado => s(3)); 
    s5 : somador_simples port map (a => a(4), b => b_signal(4), cin => c(4), cout => c(5), resultado => s(4)); 
    s6 : somador_simples port map (a => a(5), b => b_signal(5), cin => c(5), cout => c(6), resultado => s(5)); 
    s7 : somador_simples port map (a => a(6), b => b_signal(6), cin => c(6), cout => c(7), resultado => s(6)); 
    s8 : somador_simples port map (a => a(7), b => b_signal(7), cin => c(7), cout => cout, resultado => s(7)); 
end;
