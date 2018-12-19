-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY edge_detector IS
	PORT
	(
		clk     : IN std_logic;
		clk_enable  : IN std_logic;
		rst     : IN std_logic;
		input  : IN std_logic;
		output : OUT std_logic
	);
END edge_detector;

ARCHITECTURE behav OF edge_detector IS
	TYPE state IS (s0, s1, s2);
	SIGNAL pres_state, next_state : state;
BEGIN

syn_edge_detector : PROCESS(clk)
BEGIN
	IF (rising_edge(clk) AND clk_enable = '1') THEN
		IF rst = '1' THEN
			pres_state <= s0;
		ELSE
			pres_state <= next_state;
		END IF;
	END IF;
END PROCESS syn_edge_detector;

com_edge_detector : PROCESS(pres_state, input)
BEGIN
	CASE pres_state IS
		WHEN s0 => output <= '0';
			IF (input = '1') THEN
				next_state <= s1;
			ELSE
				next_state <= s0;
			END IF;
		WHEN s1 => output <= '1';
			next_state <= s2;
		WHEN s2 => output <= '0';
			IF (input = '0') THEN
				next_state <= s0;
			ELSE
				next_state <= s2;
			END IF;
	END CASE;
END PROCESS com_edge_detector;
END behav;
