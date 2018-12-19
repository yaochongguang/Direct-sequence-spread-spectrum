-- Author Felix Lerner
-- Description: Debouncer met 4-bit register.
library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
 port (
 clk : in std_logic;
 cha : in std_logic;
 rst : in std_logic;
 clk_enable : in std_logic;
 syncha : out std_logic
);
end debouncer;

architecture behave of debouncer is
 signal shift : std_logic;
 signal pres_shift, next_shift : std_logic_vector(3 DOWNTO 0);
begin 
  
  shift <= cha xor pres_shift(0); -- xor poort van data en cha geeft aan of je moet shiften of loaden (= not(shift)).
  syncha <= pres_shift(0);        -- het gedebounced signaal is de laatste bit van het shiftregister (=data).
  
  syn_debouncer: process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' and clk_enable = '1' then
        pres_shift <= (others => '0');  -- als rst actief hoog, load schuifregister met "0000".
      else pres_shift <= next_shift;    -- als rst niet actief is moet de huidige toestand ..
      end if;                           -- .. gelijk worden aan de volgende toestand.
    end if;
  end process syn_debouncer;
  
  com_debouncer: process(shift,pres_shift)
  begin
    if shift = '1' then
      next_shift <= cha & pres_shift(3 DOWNTO 1); -- volgende toestand schuifregister moet met 1 bit naar rechts verschoven worden..
    else next_shift <= (others => pres_shift(0)); -- ..en de meest linkse bit moet gelijk zijn aan het ingangsignaal.
    end if;
  end process com_debouncer;
end behave;
  
        
        
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
