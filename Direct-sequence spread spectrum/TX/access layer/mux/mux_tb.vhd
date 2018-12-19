library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mux_tb is
end mux_tb;

architecture mux of mux_tb is 

-- Component Declaration
component mux
port (
	select_data: in std_logic_vector(1 downto 0);
	xor_data: in std_logic;
	xor_pn_ml1: in std_logic;
	xor_pn_gold: in std_logic;
	xor_pn_ml2: in std_logic;
	sdo_spread: out std_logic
  );
end component;

for uut : mux use entity work.mux(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal data : std_logic_vector(3 downto 0);

signal sdo_spread: std_logic;
signal xor_pn_ml1: std_logic;
signal	xor_pn_ml2:  std_logic;
signal	xor_pn_gold: std_logic;
signal	xor_data: std_logic;
signal select_data: std_logic_vector (1 downto 0);

BEGIN

	uut: mux PORT MAP(
      sdo_spread => sdo_spread,
      xor_pn_ml1 => xor_pn_ml1,
      xor_pn_ml2 => xor_pn_ml2,
      xor_pn_gold => xor_pn_gold,
      xor_data => xor_data,
      select_data => select_data
      );
  
	
tb : PROCESS
   procedure tbvector(constant stimvect : in std_logic_vector(3 downto 0))is
     begin
      xor_data <= stimvect(3);
      xor_pn_ml1 <= stimvect(2);
      xor_pn_gold <= stimvect(1);
      xor_pn_ml2 <= stimvect(0);

       wait for period;
   end tbvector;
   BEGIN
      wait for period;
      
      select_data <= "00";
      data <= "0000";
      loop
      tbvector(data);
      data <= data + 1;
      exit when data = "1111";
      end loop;
      
      wait for period*10;
      
      select_data <= "01";
      data <= "0000";
      loop
      tbvector(data);
      data <= data + 1;
      exit when data = "1111";
      end loop;
      
      wait for period*10;
      
      select_data <= "10";
      data <= "0000";
      loop
      tbvector(data);
      data <= data + 1;
      exit when data = "1111";
      end loop;
      
      wait for period*10;
      
      select_data <= "11";
      data <= "0000";
      loop
      tbvector(data);
      data <= data + 1;
      exit when data = "1111";
      end loop;
            
      end_of_sim <= true;
      wait;
   END PROCESS;


  END;






