-------------------------------------------------------------------------------
--
-- Title       : dual_MUX
-- Design      : polyphase_clock_sync
-- Author      : thomas
-- Company     : AGH
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\polyphase_clock_sync\src\dual_mux.vhd
-- Generated   : Sat Nov  6 14:11:09 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library polyphase_clock_sync;
use polyphase_clock_sync.array_type_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dual_MUX is
	generic
		(
		CHANNELS : integer := 32;
		AXIS_DATA_WIDTH : integer := 32
		);
	port(
		clk : in std_logic; 
		arestn : in std_logic;
		
		f_index : in std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0);	 -- synthesizable
		underflow : in std_logic;
		
		filter_array_din : in dout_array_t(CHANNELS-1 downto 0); -- TODO: zdefiniowaæ rozmiar danych w tablicy
		dfilter_array_din : in dout_array_t(CHANNELS-1 downto 0);												
		
		--valid	: out std_logic;
		filter_dout : out signed(AXIS_DATA_WIDTH-1 downto 0);
		dfilter_dout : out signed(AXIS_DATA_WIDTH-1 downto 0);
		
	            -- Ports of Axi Slave Bus Interface s_axis   
        s_axis_tready      : out std_logic;
        s_axis_tvalid      : in std_logic;
        
        -- Ports of Axi Master Bus Interface s_axis   
        m_axis_tvalid      : out std_logic;
        m_axis_tready      : in std_logic
		
		
		);
end dual_MUX;

architecture dual_MUX of dual_MUX is 		 

type state_type is (IDLE, SECOND_SAMPLE, PREV_SAMPLE, NEXT_SAMPLE, SHIFT_IDLE);
signal state, prev_state : state_type;

--signal t_ready : std_logic := '0';
signal f_prev_sample : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');
signal df_prev_sample : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0'); 

begin												
	
-- state machine for AXIS control
process(arestn, clk)
begin
	if(arestn = '0') then
		s_axis_tready <= '0';
	elsif(rising_edge(clk)) then 
		if (m_axis_tready='1') then 
			case state is
				when IDLE =>
					s_axis_tready <= '1';
				when SECOND_SAMPLE =>
					s_axis_tready <= '0';
				when PREV_SAMPLE =>		 
					s_axis_tready <= '0';
				when NEXT_SAMPLE =>
					s_axis_tready <= '0';	
				when SHIFT_IDLE => 
					s_axis_tready <= '1';		
			end case;					
		else
			s_axis_tready <= '0';
		end if;
	end if;	
end process;

process (arestn, clk)
begin		 
	if(arestn = '0') then	    
		f_prev_sample <= (others => '0');	
		df_prev_sample <= (others => '0'); 
		m_axis_tvalid <= '0';
		state <= IDLE;
	elsif (rising_edge(clk)) then
		prev_state <= state; -- save previous state
		case state is
			when IDLE =>				
				if(prev_state = SECOND_SAMPLE)then 
					state <= NEXT_SAMPLE;
				else -- prev_state == NEXT_SAMPLE or others
					state <= SECOND_SAMPLE;
				end if;	
				filter_dout <= (others => '0');	
				dfilter_dout <= (others => '0'); 
				m_axis_tvalid <= '0';
				
			when SECOND_SAMPLE =>		
				if (s_axis_tvalid = '1') then
					if(underflow = '1') then
						filter_dout <= filter_array_din(to_integer(unsigned(f_index)));
						dfilter_dout <= dfilter_array_din(to_integer(unsigned(f_index)));
						m_axis_tvalid <= '1';
						state <= IDLE;	
					else
						filter_dout <= (others => '0');	
						dfilter_dout <= (others => '0'); 
						m_axis_tvalid <= '0';
						state <= SHIFT_IDLE;
					end if;	
				else						 
					filter_dout <= (others => '0');	
					dfilter_dout <= (others => '0'); 
					m_axis_tvalid <= '0';
					state <= IDLE;
				end if;
				
			when PREV_SAMPLE =>	
				if(s_axis_tvalid = '1') then		
					filter_dout <= f_prev_sample;
					dfilter_dout <= df_prev_sample;
					f_prev_sample <= filter_array_din(to_integer(unsigned(f_index)));
					df_prev_sample <= dfilter_array_din(to_integer(unsigned(f_index)));		
					m_axis_tvalid <= '1';
				else  
					filter_dout <= (others => '0');	
					dfilter_dout <= (others => '0'); 
				 	m_axis_tvalid <= '0';
				end if;
				state <= IDLE;
				
			when NEXT_SAMPLE => 	
				if(s_axis_tvalid = '1') then
					f_prev_sample <= filter_array_din(to_integer(unsigned(f_index)));
					df_prev_sample <= dfilter_array_din(to_integer(unsigned(f_index)));		
					if(underflow = '1') then 					
						filter_dout <= filter_array_din(to_integer(unsigned(f_index)));
						dfilter_dout <=	dfilter_array_din(to_integer(unsigned(f_index)));
						m_axis_tvalid <= '1';
						state <= SHIFT_IDLE; 
					else 					 
						filter_dout <= (others => '0');	
						dfilter_dout <= (others => '0'); 
						m_axis_tvalid <= '0';
						state <= IDLE;
					end if;		
				else
					filter_dout <= (others => '0');	
					dfilter_dout <= (others => '0'); 
					m_axis_tvalid <= '0';
					state <= IDLE;
				end if;

			when SHIFT_IDLE =>			 		
				if(prev_state = SECOND_SAMPLE)then 
					state <= PREV_SAMPLE;
				else -- prev_state == NEXT_SAMPLE or others
					state <= NEXT_SAMPLE;
				end if;
				filter_dout <= (others => '0');	
				dfilter_dout <= (others => '0'); 
				m_axis_tvalid <= '0';
				
		end case;	   
	end if;
end process;		  



--s_axis_tready <= t_ready;
--f_prev_sample <= filter_array_din(to_integer(unsigned(f_index))) when s_axis_tvalid = '1' and t_ready = '1';
--df_prev_sample <= dfilter_array_din(to_integer(unsigned(f_index))) when s_axis_tvalid = '1' and t_ready = '1';


end dual_MUX;


--signal filter_dout_sig : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');
--signal dfilter_dout_sig : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');	
--
--begin
--	filter_dout_sig <= filter_array_din(to_integer(unsigned(f_index))) when underflow='1' else filter_dout_sig;
--	dfilter_dout_sig <= dfilter_array_din(to_integer(unsigned(f_index))) when underflow='1' else dfilter_dout_sig;
--	
--	filter_dout	 <= filter_dout_sig when arestn='1' else (others => '0');
--	dfilter_dout <= dfilter_dout_sig when arestn='1' else (others => '0');
--end dual_MUX;


--begin
--process(arestn) -- clk
--		begin
--		if(arestn = '0') then	
--			filter_dout <= (others => '0');	
--			filter_dout	<= (others => '0');
--			dfilter_dout <= (others => '0');
--		else then	-- TODO: sprawdziæ czy nie jest potrzebny clk
--			if(underflow = '1') then
--				filter_dout_sig <= filter_array_din(to_integer(unsigned(f_index)));
--				dfilter_dout_sig <= dfilter_array_din(to_integer(unsigned(f_index)));
--			end if;				
--		end if;	
--end process;  	