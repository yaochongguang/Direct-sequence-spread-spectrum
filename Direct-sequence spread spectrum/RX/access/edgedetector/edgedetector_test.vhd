-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY edge_detector_tb IS
END edge_detector_tb;

ARCHITECTURE structural OF edge_detector_tb IS

COMPONENT edge_detector
	PORT
	(
		clk     : IN std_logic;
		clk_enable  : IN std_logic;
		rst     : IN std_logic;
	  input  : IN std_logic;
	  output : OUT std_logic
	);
END COMPONENT;

FOR uut : edge_detector USE ENTITY work.edge_detector(behav);

	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;

	SIGNAL clk        : std_logic;
	SIGNAL clk_enable     : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL input     : std_logic;
	SIGNAL output    : std_logic;

BEGIN

uut: edge_detector PORT MAP
    (
      	clk     => clk,
      	clk_enable  => clk_enable,
      	rst     => rst,
      	input  => input,
      	output => output
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
PROCEDURE tbvector (CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0)) IS
		BEGIN
			input <= stimvect(1); -- inputs "linken" met de vector
			rst <= stimvect(0);
		WAIT FOR period;
	END tbvector;

	BEGIN
		clk_enable <= '1';
		WAIT FOR period*5;
		tbvector("01");
		WAIT FOR period*50;
		tbvector("10");
		WAIT FOR period*50;
		tbvector("00");
		tbvector("10");
		WAIT FOR period*50;
		tbvector("10");
		tbvector("01");
		WAIT FOR period*50;
		end_of_sim <= true;
		WAIT;
	END PROCESS;
END;
