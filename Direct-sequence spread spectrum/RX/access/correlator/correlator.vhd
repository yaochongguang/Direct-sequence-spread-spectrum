-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY correlator IS
	PORT (
		clk          	: IN  std_logic;
		clk_enable   	: IN  std_logic;
		rst          	: IN  std_logic;
		sdi_despread 	: IN  std_logic;
		bit_sample   	: IN  std_logic;
		chip_sample2 	: IN  std_logic;
		data_out		  : OUT std_logic
  	 );
END correlator;

ARCHITECTURE behav OF correlator IS
	SIGNAL next_count : std_logic_vector(5 DOWNTO 0) := "100000";
	SIGNAL pres_count : std_logic_vector(5 DOWNTO 0) := "100000";
	SIGNAL next_shiftreg   : std_logic := '0';
	SIGNAL pres_shiftreg   : std_logic := '0';
BEGIN

data_out <= pres_shiftreg;

syn_correlator : PROCESS (clk)
BEGIN
	IF (rising_edge(clk) AND clk_enable = '1') THEN
		IF (rst = '1') THEN
			pres_count <= "100000";
			pres_shiftreg <= '0';
		ELSE
			pres_count <= next_count;
			pres_shiftreg <= next_shiftreg;
		END IF;
	END IF;
END PROCESS syn_correlator;

com_correlator : PROCESS(bit_sample, chip_sample2, sdi_despread, pres_count, pres_shiftreg)
BEGIN
	IF ((bit_sample = '1') AND (pres_count(5) = '1')) THEN -- >32
		next_count <= "100000";
		next_shiftreg <= '1';

	ELSIF ((bit_sample = '1') AND (pres_count(5) = '0')) THEN -- <32
		next_count <= "100000";
		next_shiftreg <= '0';

	ELSIF (chip_sample2 = '1' AND sdi_despread = '1') THEN
		next_count <= pres_count + 1;
	ELSIF (chip_sample2 = '1' AND sdi_despread = '0') THEN
		next_count <= pres_count - 1;
	ELSE
		next_count <= pres_count;
		next_shiftreg <= pres_shiftreg;
	END IF;

END PROCESS com_correlator;
END behav;
