LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY receiver IS
	PORT
	(
		clk		: IN std_logic;
		clk_enable	: IN std_logic;
		rst		: IN std_logic;
		rx		: IN std_logic;
		pn_select	: IN std_logic_vector(1 DOWNTO 0);
		display		: OUT std_logic_vector(6 DOWNTO 0)
	);
END receiver ;
ARCHITECTURE behav OF receiver IS
	SIGNAL bit_sample	: std_logic;
	SIGNAL databit		: std_logic;
	SIGNAL data		: std_logic_vector(10 DOWNTO 0);

component application_rx is
  PORT
  (
		clk     	 	     : IN std_logic;			                      -- globale klok
		clk_enable  	 	 : IN std_logic;			                      -- klok enable om frequentie te verlagen
		rst     	 	     : IN std_logic;			                      -- globale reset
		data_in         : IN std_logic_vector(10 downto 0);     -- data: binnenkomende data
		bit_sample      : IN std_logic;                         -- controle signaal: sample
		display         : OUT std_logic_vector(6 downto 0)      -- data: 7-segmenten-display
  );
end component;

component data_shiftreg is
port(
	clk : in std_logic;
	clk_enable : in std_logic;
	rst : in std_logic;
	bit_sample : in std_logic;
	databit : in std_logic;
	data : out std_logic_vector(10 DOWNTO 0)
);
end component;

component access_top is
  PORT
  (
		clk     	 	     : IN std_logic;			                      -- globale klok
		clk_enable  	 	 : IN std_logic;			                      -- klok enable om frequentie te verlagen
		rst     	 	     : IN std_logic;			                      -- globale reset
		sdi_spread		    : IN std_logic;			                      -- data: sdi_spread signaal
		pn_sel			       : IN std_logic_vector(1 DOWNTO 0);      -- controle: select PN code
		bit_sample		    : OUT std_logic;		                      -- controle: sample
		databit			      : OUT std_logic			                      -- data: 
  );
end component;

BEGIN

application_rx_int : application_rx
PORT MAP
(
	clk       => clk,
	clk_enable    => clk_enable,
	rst       => rst,
	bit_sample => bit_sample,
	data_in   => data,
	display => display
);

datalink_rx_int : data_shiftreg
PORT MAP
(
	clk        => clk,
	clk_enable     => clk_enable,
	rst        => rst,
	bit_sample  => bit_sample,
	databit    => databit,
	data       => data 
);

access_rx_int : access_top
PORT MAP
(
	clk		=> clk,
	clk_enable	=> clk_enable,
	rst		=> rst,
	sdi_spread	=> rx,
	pn_sel		=> pn_select,
	bit_sample	=> bit_sample,
	databit		=> databit
);
END behav;
