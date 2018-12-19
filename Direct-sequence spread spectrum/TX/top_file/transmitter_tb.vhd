library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity transmitter_tb is
end transmitter_tb;

architecture structural of transmitter_tb is 

-- Component Declaration
component transmitter
	PORT
	(
		clk		: IN std_logic;
		clk_enable	: IN std_logic;
		rst		: IN std_logic;
		up		: IN std_logic;
		down		: IN std_logic;
		pn_select	: IN std_logic_vector(1 DOWNTO 0);
		display		: OUT std_logic_vector(6 DOWNTO 0);
		tx		: OUT std_logic
	);
end component;

for uut : transmitter use entity work.transmitter(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal rst:  std_logic;
signal clk_enable: std_logic;
signal pn_select: std_logic_vector(1 downto 0);
signal display: std_logic_vector(6 downto 0);
signal up:  std_logic;
signal down: std_logic;
signal tx: std_logic;

BEGIN

uut: transmitter PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      pn_select => pn_select,
      display => display,
      up => up,
      down => down,
      tx => tx);

clock : process
   begin 
       clk <= '0';
       wait for period/2;
     loop
       clk <= '0';
       wait for period/2;
       clk <= '1';
       wait for period/2;
       exit when end_of_sim;
     end loop;
     wait;
end process clock;
	
tb : PROCESS
PROCEDURE tbvector (CONSTANT vector : IN std_logic_vector(1 DOWNTO 0)) IS
	BEGIN
		up   <= vector(0);
		down <= vector(1);
		WAIT FOR PERIOD*100;
	END tbvector;
   BEGIN
        clk_enable <= '1';
        wait for period*2.2;
        rst <= '1';
        wait for period;
        rst <='0';
        wait for period*1;

	FOR i IN 0 TO 3 LOOP
		pn_select <= CONV_STD_LOGIC_VECTOR(i, 2); 
		tbvector("01"); 
		tbvector("00");
		tbvector("11");
		tbvector("00"); 
		tbvector("10"); 
		tbvector("00");
	END LOOP;
                        
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;

