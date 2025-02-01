LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.TO_INTEGER;
USE IEEE.NUMERIC_STD.UNSIGNED;

ENTITY register_bank IS 
	GENERIC (
		reg_amount: INTEGER := 8;
		word_size: INTEGER := 16
	);
	PORT (
		clock, pickReg, startReading, startWriting: IN STD_LOGIC;
		inputBank: IN STD_LOGIC_VECTOR(word_size-1 downto 0);
		
		outputReg: OUT STD_LOGIC_VECTOR(2 downto 0);
		outputState: OUT STD_LOGIC_VECTOR(1 downto 0);
		outputBank: OUT STD_LOGIC_VECTOR(word_size-1 downto 0)
	);
END register_bank;

ARCHITECTURE behavior OF register_bank IS
	
	SIGNAL state : STD_LOGIC_VECTOR(1 downto 0) := "00";
	-- 00 => IDLE
	-- 01 => PICKING_REG
	-- 10 => WRITING
	-- 11 => READING
	
	TYPE register_array IS ARRAY(0 to reg_amount-1) OF STD_LOGIC_VECTOR(word_size-1 downto 0);
	SIGNAL registers : register_array := (OTHERS => (OTHERS => '0'));

	SIGNAL selected_reg : INTEGER;
	
BEGIN
	
	PROCESS(clock)
	BEGIN
		IF RISING_EDGE(clock) THEN
			
			CASE state IS
			
				WHEN "00" =>  -- WHEN IDLE
					outputState <= "00";  -- IDLE
					
					IF pickReg = '0' THEN
<<<<<<< Updated upstream
						state <= "01";
					ELSIF startReading = '0' THEN
						state <= "11";
					ELSIF startWriting = '0'THEN
						state <= "10";
=======
						state <= pickingReg;
>>>>>>> Stashed changes
					END IF;
				
				
				WHEN "01" => -- WHEN PICKREG
					
					selected_reg <=  TO_INTEGER(UNSIGNED(inputBank(2 downto 0)));
					outputReg <= inputBank(2 downto 0);
					outputState <= "01"; -- PICKING REG
					
					IF startReading = '0' THEN
						state <= "11"; -- READING
					ELSIF startWriting = '0'THEN
						state <= "10"; -- WRITING
					END IF;
					
				WHEN "10" => -- WHEN WRITING
					
					registers(selected_reg) <= inputBank;
					outputBank <= inputBank;
					outputState <= "10"; -- WRITING
					
					IF pickReg = '0' THEN
						state <= "01"; -- PICKING REG
					ELSIF startReading = '0' THEN
						state <= "11"; -- READING
					END IF;					
				
				WHEN "11"=>  --  WHEN READING
				
					outputBank <= registers(selected_reg); 
					outputState <= "11"; -- READING
					
					IF pickReg = '0' THEN
						state <= "01"; -- PICKING REG
					ELSIF startWriting = '0'THEN
						state <= "10"; -- WRITING
					END IF;
			
			END CASE;
		END IF;
	END PROCESS;

END;
