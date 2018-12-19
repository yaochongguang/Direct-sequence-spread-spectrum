-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mux_tb IS
END mux_tb;

ARCHITECTURE structural OF mux_tb IS

COMPONENT mux_tb
	PORT
	(
		input_0, input_1, input_2, input_3  	: IN std_logic;
		select_1	             	: IN std_logic_vector(1 DOWNTO 0);
		sdo_spread           	: OUT std_logic
	);
END COMPONENT;

FOR uut : mux_tb USE ENTITY work.mux(behav);

 	SIGNAL end_of_sim 				: BOOLEAN := false;
 	CONSTANT period   				: TIME := 100 ns;

	SIGNAL input_0, input_1, input_2, input_3     	: std_logic;
	SIGNAL select_1     					: std_logic_vector(1 DOWNTO 0);
	SIGNAL sdo_spread	 			: std_logic;

BEGIN

uut: mux_tb PORT MAP
    (
      	input_0   		=> input_0,
      	input_1 		=> input_1,
      	input_2   		=> input_2,
      	input_3 		=> input_3,
      	select_1 		=> select_1,
				sdo_spread	=> sdo_spread
    );

tb : PROCESS

	PROCEDURE tbvector (CONSTANT stimvect : IN std_logic_vector(5 DOWNTO 0)) IS
		BEGIN
			input_0 <= stimvect(0);
			input_1 <= stimvect(1);
			input_2 <= stimvect(2);
			input_3 <= stimvect(3);
			select_1(0) <= stimvect(4);
			select_1(1) <= stimvect(5);

	END tbvector;
	BEGIN

		tbvector("000101");
		WAIT FOR period;
		tbvector("010101");
		WAIT FOR period;
		tbvector("100101");
		WAIT FOR period;
		tbvector("110101");
		WAIT FOR period;

		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;
