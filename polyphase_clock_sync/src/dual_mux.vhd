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

--library polyphase_clock_sync;
--use polyphase_clock_sync.array_type_pkg.all;

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
		
		filter_array_din : in signed(AXIS_DATA_WIDTH-1 downto 0);
		dfilter_array_din : in signed(AXIS_DATA_WIDTH-1 downto 0);												
		
		TED_valid	: out std_logic;
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

type state_type is (START, FIRST_SAMPLE, TRANSMIT_ZEROS, IDLE_1, SECOND_SAMPLE, IDLE_2, IGNORE);
signal state : state_type := START;
signal m_valid : std_logic := '0';
--signal f_prev_sample : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');
--signal df_prev_sample : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0'); 

begin												

process (arestn, clk)
begin		 
	if(arestn = '0') then	    
		state <= START;
					
	elsif (rising_edge(clk)) then 
		case state is
		      when START =>
		          if (s_axis_tvalid = '1') then
                    state <= IDLE_1;  
		          end if;
		          
		      when IDLE_1 =>
                    state <= FIRST_SAMPLE;
                    		          		          
		      when FIRST_SAMPLE =>
                    if(underflow = '1') then
                        state <= START;
                    else
                        state <= TRANSMIT_ZEROS;
                    end if;
                          
              when TRANSMIT_ZEROS =>
                    state <= IDLE_2;
                                  
              when IDLE_2 =>
                    state <= SECOND_SAMPLE;
                                                        
		      when SECOND_SAMPLE =>
		            if(underflow = '1') then
                        state <= IGNORE;
                    else
                        state <= START;
                    end if;
                    
		      when IGNORE =>
                if (s_axis_tvalid = '1') then
                    state <= START;  
		        end if;     
		end case;
	end if;
end process;


-- state machine for AXIS control
process(arestn, clk)
begin
	if(arestn = '0') then
        filter_dout <= (others => '0');	
        dfilter_dout <= (others => '0'); 
        m_valid <= '0';
        m_axis_tvalid <= '0';
        
	elsif(rising_edge(clk)) then 
	   case state is
		      when START =>
		          if (s_axis_tvalid = '1') then
                    filter_dout <= filter_array_din;	
                    dfilter_dout <= dfilter_array_din;
                    m_valid <= '1';
                    m_axis_tvalid <= '1';
                  else
                    filter_dout <= (others => '0');	
                    dfilter_dout <= (others => '0');
                    m_valid <= '0'; 
                    m_axis_tvalid <= '0';
		          end if;
		          
		      when IDLE_1 =>
                    filter_dout <= (others => '0');	
                    dfilter_dout <= (others => '0');
                    m_valid <= '0';
                    m_axis_tvalid <= '0';
                              		          
		      when FIRST_SAMPLE =>  
		            filter_dout <= (others => '0');	
                    dfilter_dout <= (others => '0');
                    m_valid <= '0';
                    m_axis_tvalid <= '0';
                    
              when TRANSMIT_ZEROS =>
                    filter_dout <= (others => '0');	
                    dfilter_dout <= (others => '0');
                    m_valid <= '1';
                    m_axis_tvalid <= '0';
                              
              when IDLE_2 =>
                    filter_dout <= (others => '0');	
                    dfilter_dout <= (others => '0');
                    m_valid <= '0';
                    m_axis_tvalid <= '0';
                                                  
		      when SECOND_SAMPLE =>
                    filter_dout <= (others => '0');	
                    dfilter_dout <= (others => '0');
                    m_valid <= '0';
                    m_axis_tvalid <= '0';
                    
		      when IGNORE =>
                    filter_dout <= (others => '0');	
                    dfilter_dout <= (others => '0');
                    m_valid <= '0';
                    m_axis_tvalid <= '0';  
                          
		end case;				
	end if;	
end process;

s_axis_tready <= '1';
TED_valid <= m_valid;
--m_axis_tvalid <= m_valid when state /= TRANSMIT_ZEROS else '0';

end dual_MUX;
	