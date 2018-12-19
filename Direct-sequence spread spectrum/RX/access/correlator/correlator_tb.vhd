-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY correlator_test IS
END correlator_test;

ARCHITECTURE structural OF correlator_test IS

COMPONENT correlator
	PORT
	(
		clk          	: IN  std_logic;
		clk_enable   	: IN  std_logic;
		rst          	: IN  std_logic;
		sdi_despread 	: IN  std_logic;
		bit_sample   	: IN  std_logic;
		chip_sample2 	: IN  std_logic;
		data_out			: OUT std_logic
	);
END COMPONENT;

FOR uut : correlator USE ENTITY work.correlator(behav);

	CONSTANT period   	: TIME := 100 ns;
	CONSTANT delay    	: TIME := 10 ns;
	SIGNAL end_of_sim 	: BOOLEAN := false;

	SIGNAL clk        	: std_logic;
	SIGNAL clk_enable  	: std_logic;
	SIGNAL rst        	: std_logic;
	SIGNAL sdi_despread	: std_logic;
	SIGNAL bit_sample 	: std_logic;
	SIGNAL chip_sample2	: std_logic;
	SIGNAL data_out    	: std_logic;

BEGIN

uut: correlator PORT MAP
    (
      	clk    	   		=> clk,
      	clk_enable 		=> clk_enable,
      	rst    		   	=> rst,
      	sdi_despread 	=> sdi_despread,
      	bit_sample 		=> bit_sample,
				chip_sample2	=> chip_sample2,
				data_out    	=> data_out
    );

clock : PROCESS
	BEGIN
    	clk <= '0';
    	WAIT FOR period/2;
    	LOOP
			clk <= '0';
			WAIT FOR period/2;
			clk <= '1';
			WAIT FOR period/2;
			EXIT WHEN end_of_sim;
		END LOOP;
	WAIT;
  END PROCESS clock;

tb : PROCESS

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(3 DOWNTO 0))IS
	BEGIN
		chip_sample2 <= stimvect(3);
		bit_sample <= stimvect(2);
		sdi_despread <= stimvect(1);
		rst <= stimvect(0);
		WAIT FOR period;
	END tbvector;
	BEGIN

		clk_enable <= '1';
		WAIT FOR period*5;
		tbvector("0001");
		WAIT FOR period*5;
		tbvector("0100");
		WAIT FOR period*5;
		FOR i IN 0 TO 30 LOOP
			tbvector("1010");
			tbvector("0010");
			WAIT FOR period*5;
		END LOOP;
		tbvector("0100");
		tbvector("0000");
		WAIT FOR period*5;
		FOR i IN 0 TO 30 LOOP
			tbvector("1000");
			tbvector("0000");
			WAIT FOR period*5;
		END LOOP;
		tbvector("0100");
		tbvector("0000");
		WAIT FOR period*5;
		FOR i IN 0 TO 10 LOOP
			tbvector("1010");
			tbvector("0010");
			WAIT FOR period*5;
		END LOOP;
		FOR i IN 0 TO 20 LOOP
			tbvector("1000");
			tbvector("0000");
			WAIT FOR period*5;
		END LOOP;
		tbvector("0100");
		tbvector("0000");
		WAIT FOR period*10;

		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;
