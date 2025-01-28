LIBRARY IEEE;
LIBRARY KAILIB;
USE KAILIB.REGBANK_STATES.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY interface IS
	GENERIC ( 
		word_size: INTEGER := 16
	);
	PORT (
		display0: OUT STD_LOGIC_VECTOR(0 to 6);
		display1: OUT STD_LOGIC_VECTOR(0 to 6);
		display2: OUT STD_LOGIC_VECTOR(0 to 6);
		display3: OUT STD_LOGIC_VECTOR(0 to 6);
		display4: OUT STD_LOGIC_VECTOR(0 to 6);
	
		clock, pickReg, startReading, startWriting: IN STD_LOGIC;
		input: IN STD_LOGIC_VECTOR(word_size-1 downto 0)
	);
END interface;

ARCHITECTURE behavior OF interface IS

COMPONENT register_bank 
PORT(
		clock, pickReg, startReading, startWriting: IN STD_LOGIC;
		inputBank: IN STD_LOGIC_VECTOR(word_size-1 downto 0);
		outputReg: OUT STD_LOGIC_VECTOR(2 downto 0);
		outputState: OUT RegBank_states;
		outputBank: OUT STD_LOGIC_VECTOR(word_size-1 downto 0)	
);
END COMPONENT;

COMPONENT hexaconverter 
PORT(
	state: IN RegBank_states;
	reg: IN STD_LOGIC_VECTOR(2 downto 0);
	number: IN STD_LOGIC_VECTOR(15 downto 0);
	display0: OUT STD_LOGIC_VECTOR(0 to 6);
	display1: OUT STD_LOGIC_VECTOR(0 to 6);
	display2: OUT STD_LOGIC_VECTOR(0 to 6);
	display3: OUT STD_LOGIC_VECTOR(0 to 6);
	display4: OUT STD_LOGIC_VECTOR(0 to 6)
);
END COMPONENT;

SIGNAL result: STD_LOGIC_VECTOR(word_size-1 downto 0) := (OTHERS => '0');
SIGNAL interface_reg: STD_LOGIC_VECTOR(2 downto 0) := (OTHERS => '0');
SIGNAL interface_state: RegBank_states;

BEGIN
	
	reg_bank_inst : register_bank
	PORT MAP(
		clock => clock,
		pickReg => pickReg,
		startReading => startReading,
		startWriting => startWriting,
		inputBank => input,
		
		outputReg => interface_reg,
		outputState => interface_state,
		outputBank => result
	);
	
	hexconv_inst : hexaconverter
	PORT MAP(
		state => interface_state,
		reg => interface_reg,
		number => result,
		display0 => display0,
		display1 => display1,
		display2 => display2,
		display3 => display3,
		display4 => display4
	);
	
END;
	