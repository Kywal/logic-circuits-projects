library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank is 
    generic (
        reg_amount: integer := 8;
        word_size: integer := 16
    );
    port (
        clock, pickReg, startReading, startWriting: in  std_logic;
        inputBank:  in  std_logic_vector(word_size-1 downto 0);
        outputBank: out std_logic_vector(word_size-1 downto 0)
    );
end register_bank;

architecture behavior of register_bank is
    type register_array is array(0 to reg_amount-1) of std_logic_vector(word_size-1 downto 0);
    signal registers : register_array := (others => (others => '0'));
    signal selected_reg : integer range 0 to reg_amount-1 := 0;
begin

    process(clock)
    begin
        if rising_edge(clock) then
            -- Seleção do registrador
            if pickReg = '1' then
                selected_reg <= to_integer(unsigned(inputBank(2 downto 0))) mod reg_amount;
            end if;

            -- Escrita
            if startWriting = '1' then
                registers(selected_reg) <= inputBank;
            end if;

            -- Leitura
            if startReading = '1' then
                outputBank <= registers(selected_reg);
            end if;
        end if;
    end process;

end behavior;