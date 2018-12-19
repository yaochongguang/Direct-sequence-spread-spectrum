library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity up_down_counter is
   port (
	clk: in std_logic;
	up: in std_logic;
	down: in std_logic;
	rst: in std_logic;
	clk_enable: in std_logic;
	count_out: out std_logic_vector(3 downto 0)
	);
end up_down_counter;

architecture behav of up_down_counter is
    
signal pres_count, next_count: std_logic_vector(3 downto 0);
signal count_enable: std_logic;

begin
    
count_out <= pres_count;
count_enable <= up xor down;

syn_count: process(clk)
begin
  if (rising_edge(clk) and clk_enable = '1') then
    if rst = '1' then
          pres_count <= (others => '0');
    else
          pres_count <= next_count;
    end if;
end if;
end process syn_count;

com_count: process(pres_count,count_enable)
begin
if(count_enable = '0') then
   next_count <= pres_count;
else
   if (down = '1') then next_count <= pres_count - "0001";
   else next_count <= pres_count + "0001";
  end if;
end if;
end process com_count; 
    
end behav;
    
