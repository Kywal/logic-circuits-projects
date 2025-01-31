library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_bank is
    generic (
        addr_width : integer := 4;
        data_width : integer := 8
    );
    port (
        clk       : in  std_logic;
        we        : in  std_logic;
        addr1     : in  std_logic_vector(addr_width-1 downto 0);
        addr2     : in  std_logic_vector(addr_width-1 downto 0);
        data_in   : in  std_logic_vector(data_width-1 downto 0);
        data_out1 : out std_logic_vector(data_width-1 downto 0);
        data_out2 : out std_logic_vector(data_width-1 downto 0)
    );
end register_bank;

architecture Behavioral of register_bank is
    type reg_array is array (0 to 2**addr_width - 1) of std_logic_vector(data_width-1 downto 0);
    signal registers : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                registers(to_integer(unsigned(addr1))) <= data_in;
            end if;
        end if;
    end process;
    
    data_out1 <= registers(to_integer(unsigned(addr1)));
    data_out2 <= registers(to_integer(unsigned(addr2)));
end Behavioral;
