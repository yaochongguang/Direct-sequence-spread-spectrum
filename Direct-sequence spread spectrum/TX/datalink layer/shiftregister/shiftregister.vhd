LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY shiftregister IS
	PORT (
		shift  : IN  std_logic; 
		load   : IN  std_logic;
		clk    : IN  std_logic;
		clk_enable : IN  std_logic;
		rst    : IN  std_logic;
		data   : IN  std_logic_vector(3 DOWNTO 0);
		output : OUT std_logic
    	 );
END shiftregister;


ARCHITECTURE behav OF shiftregister IS
	SIGNAL shiftreg: std_logic_vector(10 DOWNTO 0);
	SIGNAL shiftreg_next: std_logic_vector(10 DOWNTO 0);
	CONSTANT preamble: std_logic_vector(6 DOWNTO 0) := "0111110";
BEGIN
output <= shiftreg(0);
shiftreg_sync : PROCESS (clk)
BEGIN
	IF (rising_edge(clk) and clk_enable = '1') THEN
		IF (rst = '1') THEN 
			shiftreg <= (OTHERS => '0');
		ELSE 
			shiftreg <= shiftreg_next;
		END IF;
	END IF;
END PROCESS shiftreg_sync;

shiftreg_comb : PROCESS(shiftreg, load, shift, data)
BEGIN
	IF load = '1' and shift = '0' THEN 
		shiftreg_next <= data(0) & data(1) & data(2) & data(3) & preamble;	 -- data moet gespiegeld worden zodat de receiver de data juist kan lezen
	ELSIF load = '0' and shift = '1' THEN -- shift data, first preamble to reg(0) then the number of the counter
		shiftreg_next <= '0' & shiftreg(10 DOWNTO 1); 
	ELSE 
		shiftreg_next <= shiftreg;
	END IF;
END PROCESS shiftreg_comb;
END behav;
