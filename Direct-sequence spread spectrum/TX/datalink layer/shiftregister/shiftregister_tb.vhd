library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.ALL;

entity shiftregister_tb is
end shiftregister_tb;

architecture shiftregister of shiftregister_tb is 

-- Component Declaration
component shiftregister
port (
	shift     : IN  std_logic; 
	load     : IN  std_logic;
	clk    : IN  std_logic;
	clk_enable : IN  std_logic;
	rst    : IN  std_logic;
	data   : IN  std_logic_vector(3 DOWNTO 0);
	output : OUT std_logic
  );
end component;

for uut : shiftregister use entity work.shiftregister(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal rst:  std_logic;
signal clk_enable: std_logic;
signal data: std_logic_vector(3 downto 0);
signal	output:  std_logic;
signal	shift: std_logic;
signal	load: std_logic;

BEGIN

uut: shiftregister PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      data => data,
      output => output,
      shift => shift,
      load => load
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
	PROCEDURE tbvector (CONSTANT testvector : IN std_logic_vector(5 DOWNTO 0)) IS
	BEGIN
		data <= testvector(5 DOWNTO 2);
		load <= testvector(0);
		shift <= testvector(1);
		WAIT FOR period * 1;
		load <= '0';
		shift <= '0';
		WAIT FOR period * 5; 
	END tbvector;


   BEGIN
        clk_enable <= '1';
        wait for period*1.2;
        rst <= '1';			-- reset
        wait for period;
        rst <='0';
        wait for period*1;

	FOR k IN 0 TO 3 LOOP 			-- data
		FOR i IN 0 TO 10 LOOP 
			IF(i = 0) THEN 
				tbvector(CONV_STD_LOGIC_VECTOR(k, 4) & "01");		-- load
			ELSE 
				tbvector(CONV_STD_LOGIC_VECTOR(k, 4) & "10");		-- shift
			END IF;
		END LOOP;
	END LOOP;
	
	
                        
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;






