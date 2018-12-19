library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity mux is
   port (
	select_data: in std_logic_vector(1 downto 0);
	xor_data: in std_logic;
	xor_pn_ml1: in std_logic;
	xor_pn_gold: in std_logic;
	xor_pn_ml2: in std_logic;
	sdo_spread: out std_logic
	);
end mux;
architecture behav of mux is
begin
com: process(select_data,xor_data,xor_pn_ml1,xor_pn_gold,xor_pn_ml2)
begin
  case select_data is
   when "00" => sdo_spread <= xor_data;
   when "01" => sdo_spread <= xor_pn_ml1;
   when "10" => sdo_spread <= xor_pn_gold;
   when "11" => sdo_spread <= xor_pn_ml2;
   when others => sdo_spread <= '0';
  end case;
end process com; 
end behav;
    
