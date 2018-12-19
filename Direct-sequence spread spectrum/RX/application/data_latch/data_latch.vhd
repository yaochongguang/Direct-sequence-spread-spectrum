-- Author: Felix Lerner

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity data_latch is
port(
	clk : in std_logic;
	rst : in std_logic;
	clk_enable : in std_logic;
	chip_sample : in std_logic;
	data_in : in std_logic_vector(10 downto 0);
	data_out : out std_logic_vector(3 downto 0)
);
end data_latch;

architecture behav of data_latch is

signal latch_pres,latch_next: std_logic_vector(3 downto 0);
signal preamble_in: std_logic_vector(6 downto 0);
constant correct_preamble: std_logic_vector(6 downto 0) := "0111110";

begin
  
preamble_in <= data_in(10 downto 4);
data_out <= latch_pres;

syn_latch: process(clk)
begin
  if (rising_edge(clk) and clk_enable = '1') then
    if (rst = '1') then
      latch_pres <= "0000";
    else
      latch_pres <= latch_next;
    end if;
  end if;
end process syn_latch;
      
com_latch: process(chip_sample,preamble_in,latch_pres)
begin
  if (chip_sample = '1') then
    if preamble_in = correct_preamble then 
     latch_next <= data_in(3 downto 0);
    else
     latch_next <= latch_pres;
    end if;
  else
    latch_next <= latch_pres;
  end if;
  
end process com_latch;  
end behav;    
      
    
