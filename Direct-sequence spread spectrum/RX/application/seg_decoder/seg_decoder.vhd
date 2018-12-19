library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is
port (
      data : in std_logic_vector(3 downto 0);  
      segment7 : out std_logic_vector(6 downto 0)
    );
end decoder;

architecture Behavioral of decoder is

begin
process (data)
BEGIN
case  data is
when "0000"=> segment7 <="0000001";  -- '0'
when "0001"=> segment7 <="1001111";  -- '1'
when "0010"=> segment7 <="0010010";  -- '2'
when "0011"=> segment7 <="0000110";  -- '3'
when "0100"=> segment7 <="1001100";  -- '4'
when "0101"=> segment7 <="0100100";  -- '5'
when "0110"=> segment7 <="0100000";  -- '6'
when "0111"=> segment7 <="0001111";  -- '7'
when "1000"=> segment7 <="0000000";  -- '8'
when "1001"=> segment7 <="0000100";  -- '9'
when "1010"=> segment7 <="0000010";  -- 'a'
when "1011"=> segment7 <="1100000";  -- 'b'
when "1100"=> segment7 <="0110001";  -- 'c'
when "1101"=> segment7 <="1000010";  -- 'd'
when "1110"=> segment7 <="0110000";  -- 'e'
when "1111"=> segment7 <="0111000";  -- 'f'
when others=> segment7 <="1111111";  -- display nothing
end case;
end process;

end Behavioral;

