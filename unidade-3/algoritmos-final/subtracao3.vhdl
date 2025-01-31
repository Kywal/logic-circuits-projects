library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity subtracao3 is
    generic (
        reg_amount : integer := 8;  
        word_size : integer := 16
    );
    port (
        clk          : in  std_logic;
        entrada      : in  std_logic_vector(word_size-1 downto 0);

        display_valor  : out std_logic_vector(0 to 27);
        display_estado : out std_logic_vector(0 to 6);
        leds_resto : out std_logic_vector(15 downto 0);

        escolher_reg  : in  std_logic;
        setar_val_reg : in  std_logic;
        mostrar_val_reg : in  std_logic;
        executar     : in  std_logic;

        is_finalizado   : out std_logic;
        valor_resto  : out std_logic_vector(15 downto 0); -- Mantido como out
        tem_resto    : out std_logic
    );
end subtracao3;

architecture Behavioral of subtracao3 is
    component register_bank
        generic (
            addr_width : integer := 4;
            data_width : integer := 8
        );
        port (
            clk       : in  std_logic;
            we        : in  std_logic;
            addr1     : in  std_logic_vector(3 downto 0);
            addr2     : in  std_logic_vector(3 downto 0);
            data_in   : in  std_logic_vector(7 downto 0);
            data_out1 : out std_logic_vector(7 downto 0);
            data_out2 : out std_logic_vector(7 downto 0)
        );
    end component;

    component hexaconverter
        port (
            number: in STD_LOGIC_VECTOR(15 downto 0);
            display0: out STD_LOGIC_VECTOR(0 to 6);
            display1: out STD_LOGIC_VECTOR(0 to 6);
            display2: out STD_LOGIC_VECTOR(0 to 6);
            display3: out STD_LOGIC_VECTOR(0 to 6)
        );
    end component;

    signal selected_reg_addr : std_logic_vector(3 downto 0) := "0000";
    signal reg_write_enable : std_logic := '0';
    signal reg_data_in : std_logic_vector(7 downto 0);
    signal reg_data_out1, reg_data_out2 : std_logic_vector(7 downto 0);
    signal display_number : std_logic_vector(15 downto 0) := (others => '0');
    signal display0, display1, display2, display3 : std_logic_vector(0 to 6);
    
    type state_type is (IDLE, INIT, SUBTRACT, CHECK, FINISHED);
    signal state : state_type := IDLE;
    signal divisor, dividend : unsigned(7 downto 0);
    signal quotient, remainder : unsigned(7 downto 0);
    signal valor_resto_int : std_logic_vector(15 downto 0);
begin

    valor_resto <= valor_resto_int;
    leds_resto <= valor_resto_int;

    reg_bank: register_bank
        generic map (4, 8)
        port map (
            clk => clk,
            we => reg_write_enable,
            addr1 => selected_reg_addr,
            addr2 => "0000",
            data_in => reg_data_in,
            data_out1 => reg_data_out1,
            data_out2 => reg_data_out2
        );

    hex_conv: hexaconverter
        port map (
            number => display_number,
            display0 => display0,
            display1 => display1,
            display2 => display2,
            display3 => display3
        );

    display_valor <= display3 & display2 & display1 & display0;

    process(clk)
    begin
        if rising_edge(clk) then
            reg_write_enable <= '0';

            if escolher_reg = '1' then
                selected_reg_addr <= entrada(3 downto 0);
            end if;

            if setar_val_reg = '1' then
                reg_data_in <= entrada(7 downto 0);
                reg_write_enable <= '1';
            end if;
        end if;
    end process;

    process(mostrar_val_reg, reg_data_out1)
    begin
        if mostrar_val_reg = '1' then
            display_number <= "00000000" & reg_data_out1;
        else
            display_number <= (others => '0');
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when IDLE =>
                    if executar = '1' then
                        state <= INIT;
                    end if;
                    is_finalizado <= '0';
                    quotient <= (others => '0');
                    remainder <= (others => '0');
                    
                when INIT =>
                    divisor <= unsigned(reg_data_out2); -- Divisor (R0)
                    dividend <= unsigned(reg_data_out1); -- Dividendo (R1)
                    remainder <= unsigned(reg_data_out1);
                    state <= CHECK;
                    
                when CHECK =>
                    if remainder >= divisor then
                        state <= SUBTRACT;
                    else
                        state <= FINISHED;
                    end if;
                    
                when SUBTRACT =>
                    remainder <= remainder - divisor;
                    quotient <= quotient + 1;
                    state <= CHECK;
                    
                when FINISHED =>
                    is_finalizado <= '1';
                    state <= IDLE;
            end case;
        end if;
    end process;

    valor_resto_int <= std_logic_vector(quotient) & std_logic_vector(remainder);
    tem_resto <= '1' when remainder /= 0 else '0';

    process(state)
    begin
        case state is
            when IDLE =>
                display_estado <= "0000001"; -- 0
            when INIT =>
                display_estado <= "1001111"; -- 1
            when CHECK =>
                display_estado <= "0010010"; -- 2
            when SUBTRACT =>
                display_estado <= "0000110"; -- 3
            when FINISHED =>
                display_estado <= "0110000"; -- E
        end case;
    end process;

end Behavioral;