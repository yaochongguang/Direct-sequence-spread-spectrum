LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY sequence IS
	PORT
	(
		clk      : IN std_logic;
		clk_enable : IN std_logic;
		rst      : IN std_logic;
		pn_start : IN std_logic;
		load       : OUT std_logic; 
		shift      : OUT std_logic
	);
END;

ARCHITECTURE behav OF sequence IS
	SIGNAL next_count : std_logic_vector(3 DOWNTO 0);
	SIGNAL present_count : std_logic_vector(3 DOWNTO 0);
	SIGNAL load_next : std_logic;
	SIGNAL shift_next : std_logic;
BEGIN
count_sync : PROCESS (clk)
BEGIN
	IF (rising_edge(clk) and clk_enable = '1') THEN
		IF (rst = '1') THEN  
			present_count <= "1010";		-- 10
			load <= '0';
      			shift <= '0';
		ELSE 
			present_count <= next_count;
			load <= load_next;
			shift <= shift_next;
		END IF;
	END IF;
END PROCESS count_sync;

count_comb : PROCESS (present_count, pn_start)
BEGIN
	IF present_count = "1010" and pn_start = '1' THEN 
		next_count <= "0000";
		load_next <= '1';
    		shift_next <= '0';
	ELSIF pn_start = '1' THEN 
		next_count <= present_count + 1;
		load_next <= '0';
    		shift_next <= '1';
	ELSE 
		load_next <= '0';
    		shift_next <= '0';
		next_count <= present_count; 
	END IF;
END PROCESS count_comb;
END behav;
