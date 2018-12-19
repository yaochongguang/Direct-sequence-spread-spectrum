-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY access_top_tb IS
END access_top_tb;

ARCHITECTURE structural of access_top_tb is

COMPONENT access_top
   PORT
    (
		clk     	 	: IN std_logic;			
		clk_enable  	 	: IN std_logic;	
		rst     	 	: IN std_logic;		
		sdi_spread		: IN std_logic;
		pn_sel			: IN std_logic_vector(1 DOWNTO 0);
		bit_sample		: OUT std_logic;
		databit			: OUT std_logic
  );
END COMPONENT;

FOR uut : access_top USE ENTITY work.access_top(behav);

	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;

	SIGNAL clk        : std_logic;
	SIGNAL clk_enable : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL sdi_spread : std_logic;
	SIGNAL pn_sel     : std_logic_vector(1 DOWNTO 0);
	SIGNAL bit_sample : std_logic;
	SIGNAL databit 	  : std_logic;

BEGIN

uut: access_top PORT MAP 
    (
      	clk    => clk,
      	clk_enable => clk_enable,
      	rst    => rst,
	     sdi_spread   => sdi_spread,
	     pn_sel   => pn_sel,
	     bit_sample => bit_sample,
	     databit => databit
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
			pn_sel(1) <= stimvect(2); 
			pn_sel(0) <= stimvect(1);
			rst <= stimvect(0);

			WAIT FOR period;
	END tbvector;
	BEGIN	
		clk_enable <= '1';
		tbvector("0001");
		WAIT FOR period*5;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*100;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*100;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*100;
		tbvector("0010");
		WAIT FOR period*100;
		tbvector("1010");
		WAIT FOR period*100;
		tbvector("0010");
		WAIT FOR period*100;
		tbvector("1010");
		WAIT FOR period*100;
		tbvector("0010");
		WAIT FOR period*100;
		tbvector("1010");
		WAIT FOR period*100;
		tbvector("0010");
		WAIT FOR period*100;

		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;
