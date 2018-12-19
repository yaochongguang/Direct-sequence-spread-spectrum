library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.ALL;

entity data_shiftreg_tb is
end data_shiftreg_tb;

architecture data_shiftreg of data_shiftreg_tb is 

-- Component Declaration
component data_shiftreg
port(
	clk : in std_logic;
	clk_enable : in std_logic;
	rst : in std_logic;
	bit_sample : in std_logic;
	databit : in std_logic;
	data : out std_logic_vector(10 DOWNTO 0)
);
end component;

for uut : data_shiftreg use entity work.data_shiftreg(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal rst:  std_logic;
signal clk_enable: std_logic;
signal data: std_logic_vector(10 downto 0);
signal	databit:  std_logic;
signal	bit_sample: std_logic;

BEGIN

uut: data_shiftreg PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      data => data,
      databit => databit,
      bit_sample => bit_sample
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
        wait for period*5.2;    -- delay
        rst <= '1';		       	   -- reset
        wait for period;
        rst <= '0';
        bit_sample <= '0';
        databit <= '0';
        wait for period*1;
        
        databit <= '1';
        wait for period*5;
        
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        databit <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        databit <= '1';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        bit_sample <= '1';
        wait for period;
        bit_sample <= '0';
        wait for period*10;
        rst <= '1';
        wait for period*5;
          
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;

