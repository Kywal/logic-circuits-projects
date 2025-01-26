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
		outputBank: OUT STD_LOGIC_VECTOR(word_size-1 downto 0)
	);
END register_bank;

ARCHITECTURE behavior OF register_bank IS
	
	TYPE rb_states IS (pickingReg, reading, writing);
	SIGNAL state : rb_states := pickingReg;
	
	TYPE register_array IS ARRAY(0 to reg_amount-1) OF STD_LOGIC_VECTOR(word_size-1 downto 0);
	SIGNAL registers : register_array := (OTHERS => (OTHERS => '0'));

	SIGNAL selected_reg : INTEGER;
	
BEGIN
	
	PROCESS(clock)
	BEGIN
		IF RISING_EDGE(clock) THEN
			
			CASE state IS
				
				WHEN pickingReg => 
					
					selected_reg <=  TO_INTEGER(UNSIGNED(inputBank(2 downto 0)));
					outputBank <= "0000000000000" & inputBank(2 downto 0);
					
					IF startReading = '1' AND startWriting = '0' THEN
						state <= reading;
					ELSIF startWriting = '1' AND startReading = '0' THEN
						state <= writing;
					END IF;
					
				WHEN writing =>
					
					registers(selected_reg) <= inputBank;
					outputBank <= inputBank;
					
					IF pickReg = '1' AND startReading = '0' THEN
						state <= pickingReg;
					ELSIF startReading = '1' AND pickReg = '0' THEN
						state <= reading;
					END IF;					
				
				WHEN reading => 
				
					outputBank <= registers(selected_reg); 
					
					IF pickReg = '1' AND startWriting = '0' THEN
						state <= pickingReg;
					ELSIF startWriting = '1' AND pickReg = '0' THEN
						state <= writing;
					END IF;					
			
			END CASE;
		END IF;
	END PROCESS;

END;