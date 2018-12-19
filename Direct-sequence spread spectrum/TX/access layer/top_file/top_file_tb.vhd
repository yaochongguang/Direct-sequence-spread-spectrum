library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity top_file_tb is
end top_file_tb;

architecture structural of top_file_tb is 

-- Component Declaration
component top_file
port (
    clk:  in std_logic;
    clk_enable: in std_logic;
    global_dip: in std_logic_vector(1 downto 0);
    global_rst: in std_logic;
    data: in std_logic;
    pn_start: out std_logic;
    global_sdo_spread: out std_logic
  );
end component;

for uut : top_file use entity work.top_file(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal global_rst:  std_logic;
signal clk_enable: std_logic;
signal global_dip: std_logic_vector(1 downto 0);
signal	data: std_logic;
signal	pn_start: std_logic;
signal 	global_sdo_spread: std_logic;

BEGIN

uut: top_file PORT MAP(
      clk => clk,
     global_rst => global_rst,
      clk_enable => clk_enable,
      global_dip => global_dip,
      data => data,
      pn_start => pn_start,
      global_sdo_spread => global_sdo_spread
      );

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
        wait for period*1.2;
        global_rst <= '1';
        wait for period;
	global_rst <= '0';
	wait for period;
	for i in 0 to 3 loop
		global_dip <= conv_std_logic_vector(i,2);
		data <= '0';
		wait for period*10;
	end loop;
	wait for period*5;
	for i in 0 to 3 loop
		global_dip <= conv_std_logic_vector(i,2);
		data <= '1';
		wait for period*10;
	end loop;
	end_of_sim <= true;
      wait;
   END PROCESS;

  END;