library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity up_down_counter_tb is
end up_down_counter_tb;

architecture structural of up_down_counter_tb is 

-- Component Declaration
component up_down_counter
 port (
  clk: in std_logic;
	up: in std_logic;
	down: in std_logic;
	rst: in std_logic;
	clk_enable: in std_logic;
	count_out: out std_logic_vector(3 downto 0)
);
end component;

for uut : up_down_counter use entity work.up_down_counter(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  25 ns;
signal end_of_sim : boolean := false;


signal clk:  std_logic;
signal rst:  std_logic;
signal up:  std_logic;
signal down:  std_logic;
signal clk_enable : std_logic;
signal count_out: std_logic_vector (3 downto 0);

BEGIN

uut: up_down_counter PORT MAP(
      clk => clk,
      rst => rst,
      up => up,
      down => down,
      clk_enable => clk_enable,
      count_out => count_out);
      
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
   procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
     begin
      down <= stimvect(0);
      up <= stimvect(1);
      rst <= stimvect(2);

       wait for period;
   end tbvector;
   BEGIN
        wait for delay;
        tbvector("100");     -- reset
        tbvector("111");     -- reset
        tbvector("000");
        wait for period*5;
        tbvector("010");
        wait for period*18;  -- up 19 times
        tbvector("011");
        wait for period*3;   -- wat als toevallig 2 knoppen tegelijkertijd ingedrukt worden
        tbvector("001");
        wait for period*7;   -- down 8 times
        tbvector("100");     -- reset
        wait for period*5;
        end_of_sim <= true;
        wait;
   END PROCESS;

  END;


