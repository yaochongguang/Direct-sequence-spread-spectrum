library IEEE;
use IEEE.std_logic_1164.all;

entity application_tx is
  port(
    clk:  in std_logic;
    clk_enable: in std_logic;
    global_input_up: in std_logic;
    global_input_down: in std_logic;
    global_rst: in std_logic;
    global_output:  out std_logic_vector (3 downto 0);
    global_display: out std_logic_vector(6 downto 0)
    );
end application_tx;

architecture behav of application_tx is

component debouncer
  port(
    clk : in std_logic;
    cha : in std_logic;
    rst : in std_logic;
    clk_enable : in std_logic;
    syncha : out std_logic
    );
end component;

component edge_detector is
port(
	clk : in std_logic;
	rst : in std_logic;
	input : in std_logic;
	clk_enable : in std_logic;
	output : out std_logic
  );
end component;

component up_down_counter is
   port (
	clk: in std_logic;
	up: in std_logic;
	down: in std_logic;
	rst: in std_logic;
	clk_enable: in std_logic;
	count_out: out std_logic_vector(3 downto 0)
	);
end component;

component seg_decoder is
    port (
      data : in std_logic_vector(3 downto 0);  
      segment7 : out std_logic_vector(6 downto 0)
    );
end component;

signal up_debouncer_edge_detector: std_logic;
signal down_debouncer_edge_detector: std_logic;
signal up_edge_detector_counter: std_logic;
signal down_edge_detector_counter: std_logic;
signal up_down_counter_7seg_decoder: std_logic_vector(3 downto 0);

begin
  
debouncer_up:  debouncer
  port map(
    cha => global_input_up,
    clk_enable => clk_enable,
    rst => global_rst,
    syncha => up_debouncer_edge_detector,
    clk => clk
    );
    
debouncer_down:  debouncer
  port map(
    cha => global_input_down,
    clk_enable => clk_enable,
    rst => global_rst,
    syncha => down_debouncer_edge_detector,
    clk => clk
    );

edge_detector_up: edge_detector
  port map(
    clk => clk,
    clk_enable => clk_enable,
    rst => global_rst,
    input => up_debouncer_edge_detector,
    output => up_edge_detector_counter
    );
    
edge_detector_down: edge_detector
  port map(
    clk => clk,
    clk_enable => clk_enable,
    rst => global_rst,
    input => down_debouncer_edge_detector,
    output => down_edge_detector_counter
    );

up_down_counter_int: up_down_counter
  port map(
    clk => clk,
    clk_enable => clk_enable,
    rst => global_rst,
    up => up_edge_detector_counter,
    down => down_edge_detector_counter,
    count_out => up_down_counter_7seg_decoder
    );

seg_decoder_int : seg_decoder
  port map(
    data => up_down_counter_7seg_decoder,
    segment7 => global_display
    );
end behav;


