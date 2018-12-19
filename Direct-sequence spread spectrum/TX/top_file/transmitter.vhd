LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY transmitter IS
	PORT
	(
		clk		: IN std_logic;
		clk_enable	: IN std_logic;
		rst		: IN std_logic;
		up		: IN std_logic;
		down		: IN std_logic;
		pn_select	: IN std_logic_vector(1 DOWNTO 0);
		display		: OUT std_logic_vector(6 DOWNTO 0);
		tx		: OUT std_logic
	);
END transmitter ;

ARCHITECTURE behav OF transmitter IS
	SIGNAL pn_start	: std_logic;
	SIGNAL data	: std_logic;
	SIGNAL counter	: std_logic_vector(3 DOWNTO 0);

component application_tx is
  port(
    clk:  in std_logic;
    clk_enable: in std_logic;
    global_input_up: in std_logic;
    global_input_down: in std_logic;
    global_rst: in std_logic;
    global_output:  out std_logic_vector (3 downto 0);
    global_display: out std_logic_vector(6 downto 0)
    );
end component;

component datalink_tx IS
	PORT
	(
		clk       : IN std_logic;
		clk_enable: IN std_logic;
		rst       : IN std_logic;
		data      : IN std_logic_vector(3 DOWNTO 0);
		pn_start  : IN std_logic;
		output	  : OUT std_logic
	);
end component;

component top_file is
  port(
    clk:  in std_logic;
    clk_enable: in std_logic;
    global_dip: in std_logic_vector(1 downto 0);
    global_rst: in std_logic;
    data: in std_logic;
    pn_start: out std_logic;
    global_sdo_spread: out std_logic
    );
end component;

BEGIN

application_tx_int : application_tx
PORT MAP
(
	clk        => clk,
	clk_enable => clk_enable,
	global_rst        => rst,
	global_input_up 	   => up,
	global_input_down       => down,
	global_display  => display,
	global_output     => counter
);
datalink_tx_int : datalink_tx
PORT MAP
(
	clk      => clk,
	clk_enable  => clk_enable,
	rst      => rst,
	pn_start => pn_start,
	output   => data,
	data     => counter         
);
access_tx_int : top_file
PORT MAP
(
	clk       => clk,
	clk_enable    => clk_enable,
	global_rst       => rst,
	global_dip => pn_select,
	pn_start  => pn_start,
	global_sdo_spread  => tx,
	data      => data         
);
END behav;
