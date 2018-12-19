-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY despreader_test IS
END despreader_test;

ARCHITECTURE structural OF despreader_test IS

COMPONENT despreader
	PORT
	(
		clk          : IN  std_logic;
		clk_enable   : IN  std_logic;
		rst          : IN  std_logic;
		sdi_spread   : IN  std_logic;
		pn_seq       : IN  std_logic;
		chip_sample2 : IN  std_logic;
		sdi_despread : OUT std_logic
	);
END COMPONENT;

FOR uut : despreader USE ENTITY work.despreader(behav);

	CONSTANT period   	: TIME := 100 ns;
	CONSTANT delay    	: TIME := 10 ns;
	SIGNAL end_of_sim 	: BOOLEAN := false;

	SIGNAL clk        	: std_logic;
	SIGNAL clk_enable  	: std_logic;
	SIGNAL rst        	: std_logic;
	SIGNAL sdi_spread  	: std_logic;
	SIGNAL pn_seq 	  	: std_logic;
	SIGNAL chip_sample2	: std_logic;
	SIGNAL sdi_despread	: std_logic;

BEGIN

uut: despreader PORT MAP
    (
      	clk    	   	=> clk,
      	clk_enable  => clk_enable,
      	rst    		  => rst,
      	sdi_spread 	=> sdi_spread,
      	pn_seq 		  => pn_seq,
	     chip_sample2	=> chip_sample2,
	     sdi_despread	=> sdi_despread
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

	PROCEDURE tbvector (CONSTANT stimvect : IN std_logic_vector(3 DOWNTO 0)) IS
		BEGIN
		sdi_spread <= stimvect(3);
		pn_seq <= stimvect(2);
		chip_sample2 <= stimvect(1);
		rst <= stimvect(0);
			WAIT FOR period;
	END tbvector;
	BEGIN
		clk_enable <= '1';
		WAIT FOR period*5;
		tbvector("0001");
		WAIT FOR period*5;
		tbvector("1000");
		WAIT FOR period*15;
		tbvector("1100");
		WAIT FOR period*15;
		tbvector("1110");
		tbvector("1100");
		WAIT FOR period*15;
		tbvector("0110");
		tbvector("0100");
		WAIT FOR period*15;
		end_of_sim <= true;
		WAIT;
	END PROCESS;
END;
