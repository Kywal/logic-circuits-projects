LIBRARY IEEE;
LIBRARY KAILIB;
USE KAILIB.REGBANK_STATES.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY converter4bit IS 
	PORT (
		state: IN RegBank_states;
		number: IN STD_LOGIC_VECTOR(3 downto 0);
		leds: OUT STD_LOGIC_VECTOR(0 to 6)
	);
END converter4bit;

ARCHITECTURE behavior OF converter4bit IS

BEGIN
	PROCESS(state, number)
	BEGIN
	
		CASE state IS
		
			WHEN IDLE =>
			
				leds <= "1111110";
				
			WHEN OTHERS =>
			
				CASE number IS
                    when "0000" => leds <= "0000001"; -- 0
                    when "0001" => leds <= "1001111"; -- 1
                    when "0010" => leds <= "0010010"; -- 2
                    when "0011" => leds <= "0000110"; -- 3
                    when "0100" => leds <= "1001100"; -- 4
                    when "0101" => leds <= "0100100"; -- 5
                    when "0110" => leds <= "0100000"; -- 6
                    when "0111" => leds <= "0001111"; -- 7
                    when "1000" => leds <= "0000000"; -- 8
                    when "1001" => leds <= "0000100"; -- 9
                    when "1010" => leds <= "0001000"; -- A
                    when "1011" => leds <= "1100000"; -- b
                    when "1100" => leds <= "0110001"; -- C
                    when "1101" => leds <= "1000010"; -- d
                    when "1110" => leds <= "0110000"; -- E
                    when "1111" => leds <= "0111000"; -- F
                    when others => leds <= "1111111"; -- Default
				END CASE;
		END CASE;
	END PROCESS;
END;
