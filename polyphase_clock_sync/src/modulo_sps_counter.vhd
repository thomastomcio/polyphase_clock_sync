-------------------------------------------------------------------------------
--
-- Title       : loop_filter
-- Design      : polyphase_clock_sync
-- Author      : thomas
-- Company     : AGH
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\polyphase_clock_sync\src\loop_filter.vhd
-- Generated   : Sat Nov  6 17:31:18 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity modulo_sps_counter is
	generic(
		FACTOR_WIDTH : integer := 12; 
		DATA_WIDTH : integer := 32
		);
	port(
		clk : in std_logic;
		arestn : in std_logic;
		overflow : out std_logic;
		underflow : out std_logic;
		data_in : in signed(2*DATA_WIDTH+FACTOR_WIDTH+2-1 downto 0);
		data_out : out signed(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0)
		
		);
end modulo_sps_counter;

architecture modulo_sps_counter_arch of modulo_sps_counter is
	-- signals, components 
	signal s_data_out : signed(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0) := (others=>'0');
	signal s_tmp_data_out : signed(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0) := (others=>'0');
begin
	process(arestn, clk)
	begin
		if(arestn = '0') then	
			overflow <= '0';
			underflow <= '0';
			s_data_out <= (others => '0');
		elsif (rising_edge(clk)) then 	  
			s_tmp_data_out<= s_data_out;
			s_data_out <= s_data_out + data_in + data_out'length/4;
			if(s_tmp_data_out(2*DATA_WIDTH+FACTOR_WIDTH+3-1) xor
		end if;		
	end process;  
	data_out <= s_data_out;
	
end modulo_sps_counter_arch;
