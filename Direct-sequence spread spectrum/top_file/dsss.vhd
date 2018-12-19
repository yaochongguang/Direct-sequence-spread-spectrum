LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY dsss IS
	PORT
	(
		clk		: IN std_logic;
		clk_enable 	: IN std_logic;
		rst		: IN std_logic;
		up		: IN std_logic;
		down		: IN std_logic;
		pn_select	: IN std_logic_vector(1 DOWNTO 0);
		display		: OUT std_logic_vector(6 DOWNTO 0)
	);
END dsss ;

ARCHITECTURE behav OF dsss IS

	SIGNAL output_transmitter	: std_logic;
	SIGNAL display_rx		: std_logic_vector(6 DOWNTO 0);

component transmitter is
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
end component;

component receiver is
	PORT
	(
		clk		: IN std_logic;
		clk_enable	: IN std_logic;
		rst		: IN std_logic;
		rx		: IN std_logic;
		pn_select	: IN std_logic_vector(1 DOWNTO 0);
		display		: OUT std_logic_vector(6 DOWNTO 0)
	);
end component;

BEGIN

transmitter_int : transmitter
PORT MAP
(
	clk		=> clk,
	clk_enable	=> clk_enable,
	rst		=> rst,
	up		=> up,
	down		=> down,
	pn_select	=> pn_select,
	display		=> display_rx,
	tx		=> output_transmitter
);
receiver_int : receiver
PORT MAP
(
	clk		=> clk,
	clk_enable 	=> clk_enable,
	rst		=> rst,
	rx		=> output_transmitter,
	pn_select	=> pn_select,
	display		=> display 
);
END behav;
