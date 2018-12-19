-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY matched_filter_tb IS
END matched_filter_tb;

ARCHITECTURE structural OF matched_filter_tb IS

COMPONENT matched_filter
	PORT
	(
		clk         : IN std_logic;
		clk_enable  : IN std_logic;
		rst         : IN std_logic;
		sdi_spread  : IN std_logic;
		chip_sample : IN std_logic;
		sel_pn      : IN std_logic_vector(1 DOWNTO 0);
		seq_det     : OUT std_logic
	);
END COMPONENT;

FOR uut : matched_filter USE ENTITY work.matched_filter(behavior);

	CONSTANT period   	: TIME := 100 ns;
	CONSTANT delay    	: TIME := 10 ns;
	SIGNAL end_of_sim 	: BOOLEAN := false;

	SIGNAL clk        	: std_logic;
	SIGNAL clk_enable     	: std_logic;
	SIGNAL rst        	: std_logic;
	SIGNAL sdi_spread  	: std_logic;
	SIGNAL chip_sample 		: std_logic;
	SIGNAL sel_pn		: std_logic_vector(1 DOWNTO 0);
	SIGNAL seq_det	: std_logic;

	CONSTANT ml1_ptrn 	: std_logic_vector(30 DOWNTO 0) := "0100001010111011000111110011010";
	CONSTANT ml2_ptrn 	: std_logic_vector(30 DOWNTO 0) := "1110000110101001000101111101100";
	CONSTANT gold_ptrn 	: std_logic_vector(30 DOWNTO 0) := "1010001100010010000010001110110";

BEGIN

uut: matched_filter PORT MAP
    (
      	clk    	   	=> clk,
      	clk_enable  => clk_enable,
      	rst    			=> rst,
      	sdi_spread 	=> sdi_spread,
      	chip_sample => chip_sample,
	     sel_pn				=> sel_pn,
	     seq_det			=> seq_det
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

	PROCEDURE tbvector (CONSTANT stimvect : IN std_logic_vector(4 DOWNTO 0)) IS
		BEGIN
		sel_pn <= stimvect(4 DOWNTO 3);
		chip_sample <= stimvect(2);
		sdi_spread <= stimvect(1);
		rst <= stimvect(0);
			WAIT FOR period;
	END tbvector;

	BEGIN

		clk_enable <= '1';
		wait for period*5;
		tbvector("00001");
		wait for period*5;

		FOR i IN 0 TO 30 LOOP
      tbvector("00000");
      wait for period*7;
      tbvector("00110");
      tbvector("00010");
      wait for period*6;
    end loop;

    FOR i IN 0 TO 30 LOOP
      tbvector("01000");
      wait for period*7;
      tbvector("011" & not(ml1_ptrn(i))&"0");
      tbvector("01000");
      wait for period*6;
    end loop;

    FOR i IN 0 TO 30 LOOP
      tbvector("10000");
      wait for period*7;
      tbvector("101" & not(ml2_ptrn(i))&"0");
      tbvector("10010");
      wait for period*6;
    end loop;

    FOR i IN 0 TO 30 LOOP
      tbvector("11000");
      wait for period*7;
      tbvector("111" & not(gold_ptrn(i))&"0");
      tbvector("11010");
      wait for period*6;
    end loop;


		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;
