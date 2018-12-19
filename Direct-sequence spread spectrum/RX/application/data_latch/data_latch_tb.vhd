library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.ALL;

entity data_latch_tb is
end data_latch_tb;

architecture data_latch of data_latch_tb is 

-- Component Declaration
component data_latch
port (
	clk : in std_logic;
	rst : in std_logic;
	clk_enable : in std_logic;
	chip_sample : in std_logic;
	data_in : in std_logic_vector(10 downto 0);
	data_out : out std_logic_vector(3 downto 0)
  );
end component;

for uut : data_latch use entity work.data_latch(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal data_inn : std_logic_vector (10 downto 0);

signal clk:  std_logic;
signal rst:  std_logic;
signal clk_enable: std_logic;
signal chip_sample: std_logic;
signal	data_in: std_logic_vector(10 downto 0);
signal	data_out: std_logic_vector(3 downto 0);


BEGIN

	uut: data_latch PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      chip_sample => chip_sample,
      data_in => data_in,
      data_out => data_out);

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
        rst <= '1';
        wait for period;
        rst <='0';
        chip_sample <= '0';
        for i in 0 to 2047 loop
          data_inn <= CONV_STD_LOGIC_VECTOR(i,data_inn'length);
          data_in <= data_inn;
          wait for period;
        end loop;
        chip_sample <= '1';
        for i in 0 to 2047 loop
          data_inn <= CONV_STD_LOGIC_VECTOR(i,data_inn'length);
          data_in <= data_inn;
          wait for period;
        end loop;                
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;






