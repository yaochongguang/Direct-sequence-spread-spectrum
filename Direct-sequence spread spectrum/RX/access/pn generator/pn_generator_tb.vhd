-- Felix Lerner
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY pn_generator_tb IS
END pn_generator_tb;

ARCHITECTURE structural OF pn_generator_tb IS

COMPONENT pn_generator
	PORT
	(
		clk        	: IN std_logic;
		clk_enable     	: IN std_logic;
		rst        	: IN std_logic;
		seq_det    	: IN std_logic;
		chip_sample1	: IN std_logic;
		bit_sample  	: OUT std_logic;
		pn_ml1      	: OUT std_logic;
		pn_ml2       	: OUT std_logic;
		pn_gold      	: OUT std_logic
	);
END COMPONENT;

FOR uut : pn_generator USE ENTITY work.pn_generator(behav); 

	CONSTANT period   	: TIME := 100 ns;
	CONSTANT delay    	: TIME := 10 ns;
	SIGNAL end_of_sim 	: BOOLEAN := false;

	SIGNAL clk        	: std_logic;
	SIGNAL clk_enable     	: std_logic;
	SIGNAL rst        	: std_logic;
	SIGNAL seq_det 		: std_logic;
	SIGNAL chip_sample1 	: std_logic;
	SIGNAL bit_sample	: std_logic;
	SIGNAL pn_ml1    	: std_logic;
	SIGNAL pn_ml2    	: std_logic;
	SIGNAL pn_gold    	: std_logic;

BEGIN

uut: pn_generator PORT MAP
    (
      	clk    	   		=> clk,
      	clk_enable 		   	=> clk_enable,
      	rst    		   	=> rst,
      	seq_det 		=> seq_det,
      	chip_sample1 		=> chip_sample1,
	bit_sample		=> bit_sample,
	pn_ml1    		=> pn_ml1,
	pn_ml2			=> pn_ml2,
	pn_gold    		=> pn_gold
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

	PROCEDURE tbvector (CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0)) IS
	BEGIN
		seq_det <= stimvect(2);
		chip_sample1 <= stimvect(1);
		rst <= stimvect(0); -- inputs "linken" met de vector
		WAIT FOR period;
	END tbvector;
	BEGIN

		clk_enable <= '1';
		tbvector("011");
		WAIT FOR period*5;
		tbvector("010");
		WAIT FOR period*15;
		tbvector("110");
		WAIT FOR period*5;
		tbvector("010");
		WAIT FOR period*50;

		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;
