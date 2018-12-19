-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mux IS
	PORT
	(
		input_0, input_1, input_2, input_3  	: IN std_logic;
		select_1		        										           : IN std_logic_vector(1 DOWNTO 0);
		sdo_spread          								 	       : OUT std_logic
	);
END mux;

ARCHITECTURE behav OF mux IS
BEGIN
mux : PROCESS (input_0, input_1, input_2, input_3, select_1)
BEGIN
	CASE select_1 IS
		WHEN "00" => sdo_spread  <= input_0;
		WHEN "01" => sdo_spread  <= input_1;
		WHEN "10" => sdo_spread  <= input_2;
		WHEN "11" => sdo_spread  <= input_3;
		WHEN OTHERS => sdo_spread <= input_0;
	END CASE;
END PROCESS mux;
END behav;
