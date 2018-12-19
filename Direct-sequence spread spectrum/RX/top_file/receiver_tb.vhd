LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
ENTITY receiver_tb IS
END receiver_tb;

ARCHITECTURE structural OF receiver_tb IS

	CONSTANT PERIOD        : TIME := 100 ns;
	CONSTANT DELAY         : TIME := 10 ns;
	SIGNAL end_of_sim      : BOOLEAN := false;

	SIGNAL clk             : std_logic := '0';
	SIGNAL clk_enable      : std_logic;
	SIGNAL rst             : std_logic := '0';
	SIGNAL rx	       : std_logic := '0';
	SIGNAL display	       : std_logic_vector(6 DOWNTO 0);
	SIGNAL pn_select       : std_logic_vector(1 DOWNTO 0) := "00";
	
	CONSTANT NO_PTRN: std_logic_vector(30 DOWNTO 0) := (OTHERS => '0');
	CONSTANT PTRN_1 : std_logic_vector(30 DOWNTO 0) := "0100001010111011000111110011010"; 
	CONSTANT PTRN_2 : std_logic_vector(30 DOWNTO 0) := "1110000110101001000101111101100";
	CONSTANT PTRN_3 : std_logic_vector(30 DOWNTO 0) := "1010001100010010000010001110110";
BEGIN

uut : ENTITY work.receiver(behav)
	PORT MAP
	(
		clk		=> clk,
		clk_enable	=> clk_enable,
		rst		=> rst,
		rx		=> rx,
		pn_select	=> pn_select,
		display		=> display
	);

clock : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR PERIOD/2;
	LOOP
		clk <= '0';
		WAIT FOR PERIOD/2;
		clk <= '1';
		WAIT FOR PERIOD/2;
		EXIT WHEN end_of_sim;
	END LOOP;
	WAIT;
END PROCESS clock;

tb : PROCESS

	PROCEDURE test (CONSTANT TESTPN: IN std_logic_vector(1 DOWNTO 0); CONSTANT TESTDATA: IN std_logic) IS
	BEGIN
		pn_select <= TESTPN;
		rx <= TESTDATA;
		WAIT FOR PERIOD;
	END test;
BEGIN
	clk_enable <= '1';
	wait for period*3;
	rst <= '1';
	wait for period;
	rst <= '0';
	wait for period*1.2;
	FOR k IN 0 TO 3 LOOP
		FOR i IN 0 TO 30 LOOP
			test(CONV_STD_LOGIC_VECTOR(k, 2), '1');
		END LOOP;
	END LOOP;
	FOR i IN 0 TO 30 LOOP
		test("01", PTRN_1(30-i));
	END LOOP;
	FOR i IN 0 TO 30 LOOP
		test("01", PTRN_1(30-i));
	END LOOP;
	WAIT FOR PERIOD*3;
	-- pn2
	FOR i IN 0 TO 30 LOOP
		test("10", PTRN_2(30-i));
	END LOOP;
	FOR i IN 0 TO 30 LOOP
		test("10", PTRN_2(30-i));
	END LOOP;
	WAIT FOR PERIOD*3;
	-- pn3
	FOR i IN 0 TO 30 LOOP
		test("11", PTRN_3(30-i));
	END LOOP;FOR i IN 0 TO 30 LOOP
		test("11", PTRN_3(30-i));
	END LOOP;
	WAIT FOR PERIOD*3;
	end_of_sim <= true;
	WAIT;
END PROCESS;
END;
