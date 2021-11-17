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


entity loop_filter is
	generic(
		ALPHA : integer := 0;
		BETA : integer := 0;
		FACTOR_WIDTH :integer := 12;
		DATA_WIDTH : integer := 32
	);
	port(
	clk : in std_logic;
	arestn : in std_logic;
	error_in : in signed(2*DATA_WIDTH-1 downto 0);
	data_out : out signed(2*DATA_WIDTH+FACTOR_WIDTH+2-1 downto 0) -- dwa rownolegle mnozenia i dwa dodawania
	);
end loop_filter;

architecture loop_filter_arch of loop_filter is
-- signals, components 	
signal s_error_in : signed(error_in'range):= (others => '0');
signal s_delayed_data : signed (2*DATA_WIDTH+FACTOR_WIDTH+2-1 downto 0) := (others => '0');
begin
	 	process(arestn, clk)
		begin
		if(arestn = '0') then	
			data_out <= (others => '0');		
		elsif (rising_edge(clk)) then 
			s_error_in <= error_in;			
			data_out <= s_delayed_data + ALPHA*s_error_in;
			s_delayed_data <= s_delayed_data + BETA*s_error_in;
		end if;		
	end process;

end loop_filter_arch;
