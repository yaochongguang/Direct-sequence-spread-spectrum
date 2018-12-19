-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY application_top is
  PORT
  (
		clk     	 	     : IN std_logic;			                      -- globale klok
		clk_enable  	 	 : IN std_logic;			                      -- klok enable om frequentie te verlagen
		rst     	 	     : IN std_logic;			                      -- globale reset
		data_in         : IN std_logic_vector(10 downto 0);     -- data: binnenkomende data
		bit_sample      : IN std_logic;                         -- controle signaal: sample
		display         : OUT std_logic_vector(6 downto 0)      -- data: 7-segmenten-display
  );
END application_top;

ARCHITECTURE behav OF application_top IS

COMPONENT data_latch IS
	PORT (
	clk : in std_logic;
	rst : in std_logic;
	clk_enable : in std_logic;
	bit_sample : in std_logic;
	data_in : in std_logic_vector(10 downto 0);
	data_out : out std_logic_vector(3 downto 0)
  	 );
END COMPONENT;

COMPONENT seg_decoder IS
	PORT (
		data : in std_logic_vector(3 downto 0);  
    segment7 : out std_logic_vector(6 downto 0)
    	 );
END COMPONENT;

SIGNAL data_int: std_logic_vector(3 DOWNTO 0);

BEGIN

int_data_latch : data_latch
PORT MAP(
      clk => clk,
      rst => rst,
      clk_enable => clk_enable,
      bit_sample => bit_sample,
      data_in => data_in,
      data_out => data_int
);

int_seg_decoder : seg_decoder
PORT MAP(
 	    data => data_int,
      segment7 => display
);
END behav;