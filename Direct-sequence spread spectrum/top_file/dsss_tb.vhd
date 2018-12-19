LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY dsss_tb IS
END dsss_tb;

ARCHITECTURE structural OF dsss_tb IS

	CONSTANT PERIOD   : TIME := 100 ns;
	CONSTANT DELAY    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;

	SIGNAL clk        : std_logic := '0';
	SIGNAL clk_enable : std_logic := '1';
	SIGNAL rst        : std_logic := '0';
	SIGNAL up         : std_logic := '0';
	SIGNAL down       : std_logic := '0';
	SIGNAL pn_select  : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL display  : std_logic_vector(6 DOWNTO 0) := "1111111";
BEGIN

uut : ENTITY work.dsss(behav)
	PORT MAP
	(
		clk       => clk,
		clk_enable => clk_enable,
		rst       => rst,
		up        => up,
		down      => down,
		pn_select => pn_select,
		display => display
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

	PROCEDURE test  IS
	BEGIN
		up <= '1';
		down <= '0';
		WAIT FOR PERIOD*500;
		up <= '0';
		down <= '0';
		WAIT FOR PERIOD;
	END test;
BEGIN
	wait for period*5;
	rst <= '1';
	wait for period;
	rst <= '0';
	wait for period;	
	FOR i IN 0 TO 3 LOOP
		pn_select <= CONV_STD_LOGIC_VECTOR(i, 2);
		test;
		WAIT FOR PERIOD*50000;
	END LOOP;
	end_of_sim <= true;
	WAIT;
END PROCESS;
END;
