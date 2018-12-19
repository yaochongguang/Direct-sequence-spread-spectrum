library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity decoder_tb is
end decoder_tb;

architecture structural of decoder_tb is 

-- Component Declaration
component decoder
 port (
 data : in std_logic_vector(3 downto 0);  
 segment7 : out std_logic_vector(6 downto 0)
);
end component;

for uut : decoder use entity work.decoder(Behavioral);
 
constant period : time := 100 ns;
signal end_of_sim : boolean := false;

signal data:  std_logic_vector(3 downto 0);
signal segment7 : std_logic_vector(6 downto 0);


BEGIN

uut: decoder PORT MAP(
      data => data,
      segment7 => segment7
      );
	
tb : PROCESS
   BEGIN
        data <= "0000"; -- '0'
        wait for period;
        data <= "0001"; -- '1'
        wait for period;
        data <= "0010"; -- '2'
        wait for period;
        data <= "0011"; -- '3'
        wait for period;
        data <= "0100"; -- '4'
        wait for period;
        data <= "0101"; -- '5'
        wait for period;
        data <= "0110"; -- '6'
        wait for period;
        data <= "0111"; -- '7'
        wait for period;
        data <= "1000"; -- '8'
        wait for period;
        data <= "1001"; -- '9'
        wait for period;
        data <= "1010"; -- 'a'
        wait for period;
        data <= "1011"; -- 'b'
        wait for period;
        data <= "1100"; -- 'c'
        wait for period;
        data <= "1101"; -- 'd'
        wait for period;
        data <= "1110"; -- 'e'
        wait for period;
        data <= "1111"; -- 'f'
         
        end_of_sim <= true;
        wait;
   END PROCESS;

  END;


