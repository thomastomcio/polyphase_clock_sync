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

entity index_selector is
	generic
		(
		CHANNELS : integer := 32;
		FACTOR_WIDTH : integer := 12;
		DATA_WIDTH : integer := 32
		);
	port(
		clk : in std_logic;
		arestn : in std_logic;
		overflow : in std_logic;
		underflow : in std_logic;
		data_in : in signed(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0);
		f_index : out std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0)
		);
end index_selector;

architecture index_selector_arch of index_selector is
-- signals, components 	
begin
	 	process(arestn, clk)
		begin
		if(arestn = '0') then	
			f_index <= (others => '0');		
		elsif (rising_edge(clk) and (underflow='1' or overflow='1')) then 
		   f_index <= std_logic_vector(to_unsigned(to_integer(data_in mod (CHANNELS+1)), f_index'length));
		end if;		
	end process;

end index_selector_arch;
