library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sequence_tb is
end sequence_tb;

architecture sequence of sequence_tb is 

-- Component Declaration
component sequence
port (
	clk      : IN std_logic;
	clk_enable : IN std_logic;
	rst      : IN std_logic;
	pn_start : IN std_logic;
	load       : OUT std_logic; 
	shift      : OUT std_logic
  );
end component;

for uut : sequence use entity work.sequence(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal rst:  std_logic;
signal clk_enable: std_logic;
signal load: std_logic;
signal shift:  std_logic;
signal pn_start: std_logic;

BEGIN

uut: sequence PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      load => load,
      shift => shift,
      pn_start => pn_start);

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
   BEGIN
        clk_enable <= '1';
        wait for period*2.2;
        rst <= '1';
        wait for period;
        rst <='0';
        wait for period*1;

	FOR i IN 0 TO 11 LOOP
		pn_start <= '1';
		WAIT FOR period * 1;
		pn_start <= '0';
		WAIT FOR period*30; 
	END LOOP;
                        
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;






