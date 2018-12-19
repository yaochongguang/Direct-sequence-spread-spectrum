-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY despreader IS
	PORT (
		clk          	: IN  std_logic;
		clk_enable   	: IN  std_logic;
		rst          	: IN  std_logic;
		sdi_spread   	: IN  std_logic;
		pn_seq      	: IN  std_logic;
		chip_sample2 	: IN  std_logic;
		sdi_despread 	: OUT std_logic
    	 );
END despreader;

ARCHITECTURE behav OF despreader IS
	SIGNAL pres_signal		: std_logic := '0';
	SIGNAL next_signal		: std_logic;
BEGIN

sdi_despread <= pres_signal;

syn_despreader : PROCESS (clk)
BEGIN
	IF (rising_edge(clk) AND clk_enable = '1' AND chip_sample2 = '1') THEN
		IF (rst = '1') THEN
			pres_signal <= '0';
		ELSE
			pres_signal <= next_signal;
		END IF;
	END IF;
END PROCESS syn_despreader;

com_despreader : PROCESS(pres_signal, sdi_spread, pn_seq)
BEGIN
    next_signal <= sdi_spread XOR pn_seq;
END PROCESS com_despreader;
END behav;
