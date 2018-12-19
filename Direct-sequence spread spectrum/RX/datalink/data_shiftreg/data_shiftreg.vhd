-- Author: Felix Lerner

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity data_shiftreg is
port(
	clk : in std_logic;
	clk_enable : in std_logic;
	rst : in std_logic;
	bit_sample : in std_logic;
	databit : in std_logic;
	data : out std_logic_vector(10 DOWNTO 0)
);
end data_shiftreg;

architecture behav of data_shiftreg is

signal shiftreg_pres,shiftreg_next : std_logic_vector(10 downto 0);

begin
  
data <= shiftreg_pres;

syn_data_shiftreg: process(clk)
begin
    
if (rising_edge(clk) and clk_enable = '1') then
    if rst = '1' then
      shiftreg_pres <= (others => '0');
    else
      shiftreg_pres <= shiftreg_next;
    end if;
end if;

end process syn_data_shiftreg; 

com_data_shiftreg : process(shiftreg_pres, bit_sample)
begin
  
  if (bit_sample = '1') then
    shiftreg_next <= shiftreg_pres(9 downto 0) & databit;
  else
    shiftreg_next <= shiftreg_pres;
  end if;

end process com_data_shiftreg;
 
end behav;






