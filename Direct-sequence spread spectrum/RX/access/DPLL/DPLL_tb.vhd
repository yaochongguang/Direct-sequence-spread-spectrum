library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.ALL;

entity DPLL_tb is
end DPLL_tb;

architecture DPLL of DPLL_tb is 

-- Component Declaration
component DPLL
port(
	clk : in std_logic;
	rst : in std_logic;
	sdi_spread : in std_logic;
	clk_enable : in std_logic;
	chip_sample : out std_logic;
	chip_sample1 : out std_logic;
	chip_sample2 : out std_logic
);
end component;

for uut : DPLL use entity work.DPLL(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal rst:  std_logic;
signal clk_enable: std_logic;
signal sdi_spread: std_logic;
signal	chip_sample:  std_logic;
signal	chip_sample1: std_logic;
signal	chip_sample2: std_logic;

BEGIN

uut: DPLL PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      sdi_spread => sdi_spread,
      chip_sample => chip_sample,
      chip_sample1 => chip_sample1,
      chip_sample2 => chip_sample2
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
	PROCEDURE tbvector (CONSTANT testvector : IN std_logic_vector(1 DOWNTO 0)) IS
	BEGIN
		rst <= testvector(1);
		sdi_spread <= testvector(0);
		WAIT FOR period * 1; 
	END tbvector;


   BEGIN
        clk_enable <= '1';
        wait for period*1.2;
        rst <= '1';			-- reset
        wait for period;
        rst <= '0';
        wait for period*1;
        for i in 0 to 10 loop
        sdi_spread <= '1';
        wait for period*14;
        sdi_spread <= '0';
        wait for period;
        end loop;        
      end_of_sim <= true;
      wait;
   END PROCESS;
  END;