library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity pn_generator is
   port (
	clk: in std_logic;
	clk_enable: in std_logic;
	rst: in std_logic;
	pn_ml1: out std_logic;
	pn_ml2: out std_logic;
	pn_gold: out std_logic;
	pn_start: out std_logic  -- nog verder aan werken!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	);
end pn_generator;

architecture behav of pn_generator is

signal shiftreg1_pres: std_logic_vector(4 downto 0);
signal shiftreg1_next: std_logic_vector(4 downto 0);
signal shiftreg2_pres: std_logic_vector(4 downto 0);
signal shiftreg2_next: std_logic_vector(4 downto 0);
signal pn_ml1_internal: std_logic;
signal pn_ml2_internal: std_logic;
begin
  
pn_ml1 <= shiftreg1_pres(0);
pn_ml2 <= shiftreg2_pres(0);

pn_ml1_internal <= shiftreg1_pres(0);
pn_ml2_internal <= shiftreg2_pres(0);

pn_gold <= pn_ml1_internal xor pn_ml2_internal;

shiftreg1_next <= (shiftreg1_pres(3) xor shiftreg1_pres(0)) & shiftreg1_pres(4 downto 1);
shiftreg2_next <= (((shiftreg2_pres(0) xor shiftreg2_pres(1)) xor shiftreg2_pres(3)) xor shiftreg2_pres(4)) & shiftreg2_pres(4 downto 1);
  
syn_pn: process(clk)
begin
    
if rising_edge(clk) then
    if rst = '1' then
      shiftreg1_pres <= "00010";
      shiftreg2_pres <= "00111";
    else
      shiftreg1_pres <= shiftreg1_next;
      shiftreg2_pres <= shiftreg2_next;
    end if;
end if;

end process syn_pn; 

com_pn: process(shiftreg1_pres)
begin
 if (shiftreg1_pres = "00010") then
   pn_start <= '1';
 else pn_start <= '0';
 end if;
end process com_pn; 
end behav;
    