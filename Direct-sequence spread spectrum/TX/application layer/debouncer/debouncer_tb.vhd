library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity debouncer_tb is
end debouncer_tb;

architecture structural of debouncer_tb is 

-- Component Declaration
component debouncer
 port (
 clk : in std_logic;
 cha : in std_logic;
 rst : in std_logic;
 clk_enable : in std_logic;
 syncha : out std_logic
);
end component;

for uut : debouncer use entity work.debouncer(behave);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;


signal clk:  std_logic;
signal rst:  std_logic;
signal cha:  std_logic;
signal clk_enable : std_logic;
signal syncha: std_logic;

BEGIN

uut: debouncer PORT MAP(
      clk => clk,
      rst => rst,
      cha => cha,
      clk_enable => clk_enable,
      syncha => syncha);
      
clk_enable <= '1';

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
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin
      cha <= stimvect(0);
      rst <= stimvect(1);

       wait for period;
   end tbvector;
   BEGIN
        wait for delay;
        tbvector("10"); -- reset
        tbvector("11"); -- beide combininaties
        tbvector("00");
        wait for period*25;
        tbvector("01");
        wait for period*25;
        tbvector("00");
        wait for period*25;
        tbvector("01");
        wait for period*2;
        tbvector ("00");
        tbvector("01");
        wait for period*3;
        tbvector("00");
        tbvector("01");
        wait for period*10;
        tbvector("10");
        end_of_sim <= true;
        wait;
   END PROCESS;

  END;
