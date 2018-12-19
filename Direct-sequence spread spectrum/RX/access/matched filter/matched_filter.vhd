-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY matched_filter IS
	PORT
	(
		clk         : IN std_logic;
		clk_enable      : IN std_logic;
		rst         : IN std_logic;
		sdi_spread  : IN std_logic;
		chip_sample : IN std_logic;
		sel_pn    	: IN std_logic_vector(1 DOWNTO 0);
		seq_det     : OUT std_logic
	);
END matched_filter;

ARCHITECTURE behav OF matched_filter IS
	SIGNAL pres_seq		: std_logic;
	SIGNAL next_seq		: std_logic;
	SIGNAL pres_reg		: std_logic_vector(30 DOWNTO 0);
	SIGNAL next_reg		: std_logic_vector(30 DOWNTO 0);
	SIGNAL pn					: std_logic_vector(30 DOWNTO 0);
	CONSTANT no_ptrn	: std_logic_vector(30 DOWNTO 0) := (OTHERS => '0');
	CONSTANT ml1_ptrn 	: std_logic_vector(30 DOWNTO 0) := "0100001010111011000111110011010";
	CONSTANT ml2_ptrn 	: std_logic_vector(30 DOWNTO 0) := "1110000110101001000101111101100";
	CONSTANT gold_ptrn 	: std_logic_vector(30 DOWNTO 0) := "1010001100010010000010001110110";
BEGIN

seq_det <= pres_seq;

syn_matched_filter : PROCESS (clk)
BEGIN
	IF (rising_edge(clk) AND clk_enable = '1') THEN
		IF (rst = '1') THEN
			pres_seq <= '0';
			pres_reg <= (OTHERS => '0');
		ELSE
		  	pres_reg <= next_reg;
			pres_seq <= next_seq;
		END IF;
	END IF;
END PROCESS syn_matched_filter;

com_matched_filter : PROCESS(sdi_spread, chip_sample, pres_reg, pn)
BEGIN

	IF((pn = pres_reg) OR (NOT(pn) = pres_reg)) THEN
		next_seq <= '1';
	ELSE
		next_seq <= '0';
	END IF;

	IF(chip_sample = '1') THEN
		next_reg <= pres_reg(29 DOWNTO 0) & sdi_spread;
	ELSE
		next_reg <= pres_reg;
	END IF;
END PROCESS com_matched_filter;

mux : PROCESS(sel_pn) 				-- kiest juiste pn patroon
BEGIN
	CASE sel_pn IS
		WHEN "00"   => pn <= no_ptrn;
		WHEN "01"   => pn <= ml1_ptrn;
		WHEN "10"   => pn <= ml2_ptrn;
		WHEN "11"   => pn <= gold_ptrn;
		WHEN OTHERS => pn <= no_ptrn;
	END CASE;
END PROCESS mux;
END behav;
