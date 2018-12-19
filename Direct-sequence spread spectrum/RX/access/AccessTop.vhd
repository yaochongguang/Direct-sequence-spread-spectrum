-- Felix Lerner

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY access_top is
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
END access_top;

ARCHITECTURE behav OF access_top IS

COMPONENT correlator IS
	PORT (
		clk          	: IN  std_logic;		
		clk_enable   	: IN  std_logic;		
		rst          	: IN  std_logic;
		sdi_despread 	: IN  std_logic;
		bit_sample   	: IN  std_logic;
		chip_sample2 	: IN  std_logic;
		data_out	: OUT std_logic
  	 );
END COMPONENT;

COMPONENT despreader IS
	PORT (
		clk          	: IN  std_logic;
		clk_enable   	: IN  std_logic;
		rst          	: IN  std_logic;
		sdi_spread   	: IN  std_logic;
		pn_seq      	: IN  std_logic;
		chip_sample2 	: IN  std_logic;
		sdi_despread 	: OUT std_logic
    	 );
END COMPONENT;

COMPONENT DPLL IS
  PORT (
	 clk : in std_logic;
	 rst : in std_logic;
	 sdi_spread : in std_logic;
	 clk_enable : in std_logic;
	 chip_sample : out std_logic;
	 chip_sample1 : out std_logic;
	 chip_sample2 : out std_logic;
	 extb_out  : out std_logic
  	 );
END COMPONENT;

COMPONENT matched_filter IS
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
END COMPONENT;

COMPONENT pn_generator IS
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
END COMPONENT;

COMPONENT mux IS
	PORT
	(
		input_0, input_1, input_2, input_3  	: IN std_logic;
		select_1		        										           : IN std_logic_vector(1 DOWNTO 0);
		sdo_spread          								 	       : OUT std_logic
	);
END COMPONENT;

COMPONENT edge_detector IS
	PORT
	(
		clk     : IN std_logic;
		clk_enable  : IN std_logic;
		rst     : IN std_logic;
		input  : IN std_logic;
		output : OUT std_logic
	);
END COMPONENT;

SIGNAL b_s, b_s_edge : std_logic := '0';
SIGNAL chip_sample, chip_sample1, chip_sample2	: std_logic := '1';
SIGNAL pn_ml1, pn_ml2, pn_gold, pn_seq : std_logic;
SIGNAL match_out, desp_out : std_logic;
SIGNAL seq_det : std_logic := '0';
SIGNAL sdi_despread: std_logic;
SIGNAL extb : std_logic;


BEGIN

bit_sample <= b_s_edge;

int_dpll : dpll
PORT MAP(
  clk 		=> clk,
	clk_enable 		=> clk_enable,
	rst 		=> rst,
	sdi_spread  	=> sdi_spread,
	chip_sample  	=> chip_sample,
	chip_sample1 	=> chip_sample1,
	chip_sample2 	=> chip_sample2,
	extb_out  	=> extb
);

int_matched_filter : matched_filter
PORT MAP(
 	clk   		=> clk,
	clk_enable 		=> clk_enable,
	rst  		=> rst,
	sdi_spread  	=> sdi_spread,
	chip_sample  	=> chip_sample,
	sel_pn  	=> pn_sel,
	seq_det  	=> match_out
);

int_mux_1 : mux
PORT MAP(
	input_0      	=> extb,
	input_1      	=> match_out,
	input_2      	=> match_out,
	input_3      	=> match_out,
	select_1 	=> pn_sel,
	sdo_spread 	=> seq_det
);

int_pn_generator : pn_generator
PORT MAP(
	clk      	=> clk,
	clk_enable  	=> clk_enable,
	rst  		=> rst,
	seq_det  	=> seq_det,
	chip_sample1	=> chip_sample1,
	bit_sample  	=> b_s,
	pn_ml1    	=> pn_ml1,
	pn_ml2   	=> pn_ml2,
	pn_gold  	=> pn_gold
);

int_edge_detector : edge_detector
PORT MAP(
	clk   		=> clk,
	clk_enable  	=> clk_enable,
	rst   		=> rst,
	input 		=> b_s,
	output		=> b_s_edge

);

int_mux_2 : mux
PORT MAP(
	input_0      	=> '0',    -- niet nodig
	input_1      	=> pn_ml1,
	input_2      	=> pn_ml2,
	input_3      	=> pn_gold,
	select_1 		=> pn_sel,
	sdo_spread    	=> pn_seq
);

int_despreader : despreader
PORT MAP(
	clk 		=> clk,
	clk_enable  	=> clk_enable,
	rst  		=> rst,
	sdi_spread 	=> sdi_spread,
	pn_seq 		=> pn_seq,
	chip_sample2 	=> chip_sample2,
	sdi_despread 	=> desp_out
);

int_mux_3 : mux
PORT MAP(
	input_0      	=> sdi_spread,
	input_1      	=> desp_out,
	input_2      	=> desp_out,
	input_3      	=> desp_out,
	select_1    		=> pn_sel,
	sdo_spread    => sdi_despread
);

int_correlator : correlator
PORT MAP(
	clk          	=> clk,
	clk_enable    => clk_enable,
	rst          	=> rst,
	sdi_despread 	=> sdi_despread,
	bit_sample   	=> b_s_edge,
	chip_sample2 	=> chip_sample2,
	data_out     	=> databit
);
END behav;
