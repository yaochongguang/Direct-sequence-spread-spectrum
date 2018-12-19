-- Author: Felix Lerner

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity DPLL is
port(
	clk : in std_logic;
	rst : in std_logic;
	sdi_spread : in std_logic;
	clk_enable : in std_logic;
	chip_sample : out std_logic;
	chip_sample1 : out std_logic;
	chip_sample2 : out std_logic;
	extb_out  : out std_logic
);
end DPLL;

architecture behav of DPLL is
type stateMoore_type is (zero, pos_edge, one, neg_edge);
signal stateMoore_reg, stateMoore_next : stateMoore_type;

signal pres_count : std_logic_vector(3 DOWNTO 0);
signal next_count : std_logic_vector(3 DOWNTO 0);

signal seg : std_logic_vector(4 downto 0);

signal pres_count_nco : std_logic_vector(3 downto 0);
signal next_count_nco : std_logic_vector(3 downto 0);

signal extb : std_logic;

signal sema : std_logic_vector(4 downto 0);

type stateMealy_type_sema is (wf_extb, wf_chip_sample);
signal stateMealy_sema_cur, stateMealy_sema_next : stateMealy_type_sema;

signal p_count, n_count,preload : std_logic_vector(4 downto 0);
signal cs_shift_reg_p,cs_shift_reg_n : std_logic_vector (2 downto 0);


begin

chip_sample <= cs_shift_reg_p(0);
chip_sample1 <= cs_shift_reg_p(1);
chip_sample2 <= cs_shift_reg_p(2);
extb_out <= extb;


------------------------------------------------------------------------------------------------------------------------
--						transition detector						      --
------------------------------------------------------------------------------------------------------------------------

process(clk)
begin
  if (rising_edge(clk) and clk_enable = '1') then
    if rst = '1' then 
      stateMoore_reg <= zero;                         -- resets current state 
    else stateMoore_reg <= stateMoore_next;           -- store current state as next
   end if;
  end if;
end process;

process(stateMoore_reg,sdi_spread)
begin 
        extb <= '0';                                   -- set tick to zero (so that 'tick = 1' is available for 1 cycle only)
        case stateMoore_reg is 
            when zero =>                               -- if state is zero, 
                if sdi_spread = '1' then                    -- and level is 1
                    stateMoore_next <= pos_edge;
                else stateMoore_next <= stateMoore_reg;       -- then go to state pos_edge.
                end if; 
            when pos_edge => 
                extb <= '1';                           -- set the extb to 1.
                if sdi_spread = '1' then                    -- if level is 1, 
                    stateMoore_next <= one;            -- go to state one,
                else stateMoore_next <= neg_edge;      -- else go to state zero.
                end if;
            when neg_edge => 
                extb <= '1';
                if sdi_spread = '1' then
                  stateMoore_next <= pos_edge;
                else stateMoore_next <= zero;
                end if;
            when one =>
                if sdi_spread = '0' then                         -- if level is 0, 
                    stateMoore_next <= neg_edge;
                  else
                  stateMoore_next <= one;                        -- then go to state zero.
                end if;
            when others => stateMoore_next <= stateMoore_reg;    -- required: when no case statement is satisfied
        end case; 
end process;

------------------------------------------------------------------------------------------------------------------------
--						write segment							      --
------------------------------------------------------------------------------------------------------------------------

process(clk)                                                  -- 4-bit counter
  begin
    if (rising_edge(clk) and clk_enable = '1') then 
      if rst = '1' then pres_count <= "0000";                 -- reset
      else
        if extb = '1' then pres_count <= "0000";              -- initialisatie wanneer extb actief wordt
        else  pres_count <= next_count;                  
        end if;
      end if;
    end if;
end process;

process(pres_count)
  begin 
     next_count <= pres_count + "0001";
end process;

process(pres_count)                                         -- decoder trans. seg.
  begin
    case pres_count is
    when "0000" => seg <= "10000";                                 
    when "0001" => seg <= "10000";
    when "0010" => seg <= "10000";
    when "0011" => seg <= "10000";
    when "0100" => seg <= "10000";    
    when "0101" => seg <= "01000";
    when "0110" => seg <= "01000";
    when "0111" => seg <= "00100";
    when "1000" => seg <= "00100";
    when "1001" => seg <= "00010";
    when "1010" => seg <= "00010";
    when "1011" => seg <= "00001";
    when "1100" => seg <= "00001";
    when "1101" => seg <= "00001";
    when "1110" => seg <= "00001";
    when "1111" => seg <= "00001";
    when others => seg <= "00100";
    end case;
end process;                                               

------------------------------------------------------------------------------------------------------------------------
--						SEMAPHORE							      --
------------------------------------------------------------------------------------------------------------------------

sema_syn: process(clk)                                                    
  begin
    if (rising_edge(clk) and clk_enable = '1') then
      if (rst = '1') then
        stateMealy_sema_cur <= wf_extb;
      else stateMealy_sema_cur <= stateMealy_sema_next;
      end if;
    end if;
end process;
        
sema_comb: process(extb,cs_shift_reg_p,stateMealy_sema_cur)
  begin
    case stateMealy_sema_cur is
    when wf_extb => sema <= "00100";
		    if (extb = '1') then 
                      stateMealy_sema_next <= wf_chip_sample;
                    else stateMealy_sema_next <= wf_extb;
                    end if;
    when wf_chip_sample => sema <= seg;
			   if (cs_shift_reg_p(0) = '1') then
                              stateMealy_sema_next <= wf_extb;
                           else stateMealy_sema_next <= wf_chip_sample;
			   end if;
    when others => sema <= "00100";
    end case;	
end process;

------------------------------------------------------------------------------------------------------------------------
--						NCO								      --
------------------------------------------------------------------------------------------------------------------------

nco_count_sync: process(clk)							-- downcounter
begin
	if (rising_edge(clk) and clk_enable = '1') then
		if (rst = '1') then
			p_count <= "01111";
			cs_shift_reg_p <= "000";
		else  
			p_count <= n_count;
			cs_shift_reg_p <= cs_shift_reg_n;
		end if;
	end if;
end process;

nco_count_comb: process(p_count, cs_shift_reg_p, preload)			-- downcounter
begin
	if (p_count = "00000") then 
		cs_shift_reg_n <= cs_shift_reg_p(1 DOWNTO 0) & '1';		-- chip_sample actief hoog
		n_count <= preload;
	else 								
		cs_shift_reg_n <= cs_shift_reg_p(1 DOWNTO 0) & '0';		-- om clk delays te krijgen op chip_sample
		n_count <= p_count - 1;
	end if;
end process;

nco_decoder: process(seg)							-- decoder
begin
	case seg is
	when "10000" => preload <= "10010";	-- 15 +3
	when "01000" => preload <= "10000";	-- 15 +1
	when "00100" => preload <= "01111";	-- 15
	when "00010" => preload <= "01110";	-- 15 -1
	when "00001" => preload <= "01100";	-- 15 -3
	when others  => preload <= "01111";	
	end case;
end process;
end behav;