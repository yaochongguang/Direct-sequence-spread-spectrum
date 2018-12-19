-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY pn_generator IS
PORT
(
	clk        		: IN std_logic;
	clk_enable    : IN std_logic;
	rst        		: IN std_logic;
	seq_det    		: IN std_logic;
	chip_sample1	: IN std_logic;
	bit_sample  	: OUT std_logic;
	pn_ml1      	: OUT std_logic;
	pn_ml2       	: OUT std_logic;
	pn_gold      	: OUT std_logic
);
END;

ARCHITECTURE behav OF pn_generator IS

	SIGNAL pres1, pres2     : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');
	SIGNAL next1, next2     : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');
	CONSTANT preset1  	: std_logic_vector(4 DOWNTO 0) := "00010";
	CONSTANT preset2  	: std_logic_vector(4 DOWNTO 0) := "00111";
	SIGNAL pres_full_seq    : std_logic;
	SIGNAL next_full_seq    : std_logic := '0';

BEGIN

pn_ml1 <= pres1(0);
pn_ml2 <= pres2(0);
pn_gold <= pres1(0) XOR pres2(0);

bit_sample <= pres_full_seq;

syn_pn : PROCESS (clk)
BEGIN
	IF (rising_edge(clk) AND clk_enable = '1' AND chip_sample1 = '1') THEN
		IF (rst = '1') THEN
			pres1 <= preset1;
			pres2 <= preset2;
			pres_full_seq <= '0';
		ELSE
			pres_full_seq <= next_full_seq;
			pres1 <= next1;
			pres2 <= next2;
		END IF;
	END IF;
END PROCESS syn_pn;

com_pn : PROCESS (pres1, pres2, seq_det, pres_full_seq)
BEGIN
	IF (seq_det = '1') THEN
		next1 <= preset1;
		next2 <= preset2;
	ELSE
		next1 <= (pres1(0) XOR pres1(3)) & pres1(4 DOWNTO 1);
		next2 <= (((pres2(0) XOR pres2(1)) XOR pres2(3)) XOR pres2(4)) & pres2(4 DOWNTO 1);

		IF (pres1 = "00010") THEN
			next_full_seq <= '1';
		ELSE
			next_full_seq <= '0';
		END IF;
	END IF;
END PROCESS com_pn;
END behav;
