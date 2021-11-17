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

library work;
use work.array_type_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dual_MUX is
	generic
		(
		CHANNELS : integer := 32;
		DATA_WIDTH : integer := 32
		);
	port(
		clk : in std_logic;
		arestn : in std_logic;
		f_index : in std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0);
		filter_din : in dout_array_t(CHANNELS-1 downto 0); -- TODO: zdefiniowaæ rozmiar danych w tablicy
		dfilter_din : in dout_array_t(CHANNELS-1 downto 0);												
		mult_out : out signed (2*DATA_WIDTH-1 downto 0);
		filter_dout : out std_logic_vector(CHANNELS-1 downto 0)
		);
end dual_MUX;

architecture dual_MUX of dual_MUX is
	-- signals, components
begin
	process(arestn, clk)
		begin
		if(arestn = '0') then	
			mult_out <= (others => '0');		
		elsif (rising_edge(clk)) then
			mult_out <= signed(filter_din(to_integer(unsigned(f_index)))) * signed(dfilter_din(to_integer(unsigned(f_index))));
		end if;		
	end process;
end dual_MUX;
