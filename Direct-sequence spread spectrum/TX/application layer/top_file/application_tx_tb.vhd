library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity application_tx_tb is
end application_tx_tb;

architecture structural of application_tx_tb is 

-- Component Declaration
component application_tx
 port (
    clk:  in std_logic;
    clk_enable: in std_logic;
    global_input_up: in std_logic;
    global_input_down: in std_logic;
    global_rst: in std_logic;
    global_output:  out std_logic_vector (3 downto 0);
    global_display: out std_logic_vector(6 downto 0)
);
end component;

for uut : application_tx use entity work.application_tx(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;


signal clk:  std_logic;
signal global_rst:  std_logic;
signal clk_enable : std_logic;
signal global_input_up: std_logic;
signal global_input_down: std_logic;
signal global_output: std_logic_vector(3 downto 0);
signal global_display: std_logic_vector(6 downto 0);

BEGIN

uut: application_tx PORT MAP(
      clk => clk,
      global_rst => global_rst,
      clk_enable => clk_enable,
      global_input_up => global_input_up,
      global_input_down => global_input_down,
      global_output => global_output,
      global_display => global_display);
      
clk_enable <= '1';

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
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin
      global_input_up <= stimvect(0);
      global_input_down <= stimvect(1);
       wait for period*10;
   end tbvector;
   BEGIN
        wait for delay;
	wait for period*5;
        global_rst <= '1';
	wait for period;
	global_rst <= '0';
	wait for period;
	tbvector("00");
	tbvector("01");
	tbvector("01");
	tbvector("01");
	tbvector("01");
	tbvector("01");
	tbvector("01");
	tbvector("01");
	tbvector("01");
	tbvector("10");
	tbvector("11");
	tbvector("10");
	tbvector("10");
	tbvector("10");
	tbvector("10");
	tbvector("10");
        end_of_sim <= true;
        wait;
   END PROCESS;

  END;


