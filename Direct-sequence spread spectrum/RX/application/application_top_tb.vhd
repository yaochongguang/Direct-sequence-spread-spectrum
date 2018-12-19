-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY application_top_tb IS
END application_top_tb;

ARCHITECTURE structural of application_top_tb is

COMPONENT application_top
   PORT
    (
		clk     	 	     : IN std_logic;			                      -- globale klok
		clk_enable  	 	 : IN std_logic;			                      -- klok enable om frequentie te verlagen
		rst     	 	     : IN std_logic;			                      -- globale reset
		data_in         : IN std_logic_vector(10 downto 0);     -- data: binnenkomende data
		bit_sample      : IN std_logic;                         -- controle: sample
		display         : OUT std_logic_vector(6 downto 0)      -- data: 7-segmenten-display
  );
END COMPONENT;

FOR uut : application_top USE ENTITY work.application_top(behav);

	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;

	SIGNAL clk        : std_logic;
	SIGNAL clk_enable : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL data_in    : std_logic_vector(10 downto 0);
	SIGNAL bit_sample : std_logic;
	SIGNAL display    : std_logic_vector(6 DOWNTO 0);

BEGIN

uut: application_top PORT MAP 
    (
      	clk    => clk,
      	clk_enable => clk_enable,
      	rst    => rst,
	     data_in   => data_in,
	     bit_sample => bit_sample,
	     display => display
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

	PROCEDURE tbvector (CONSTANT stimvect : IN std_logic_vector(12 DOWNTO 0)) IS 
		BEGIN
			data_in <= stimvect(12 DOWNTO 2);
			bit_sample <= stimvect(1);
			rst <= stimvect(0);

			WAIT FOR period;
	END tbvector;
	BEGIN	
		clk_enable <= '1';
		wait for period*5;
		tbvector("0000000000001");   -- reset actief
		tbvector("0000000000000");
		tbvector("0000000000110");
		tbvector("0000000001110");
		tbvector("0000000011110");
		tbvector("0000000111110");
		tbvector("0000001111110");
		tbvector("0000011111010");
		tbvector("0000111110010");
		tbvector("0001111100110");
		tbvector("0011111000110"); 
		tbvector("0111110001110"); -- preamble correct --> data_out => 3
		tbvector("0111110001111"); -- reset            --> data_out => 0
		tbvector("0111110001100"); -- bit_sample niet actief --> geen data latchen
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;
