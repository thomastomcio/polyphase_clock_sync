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
		AXIS_DATA_WIDTH : integer := 32
		);
	port(
		--clk : in std_logic;
		arestn : in std_logic;
		
		f_index : in std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0);
		underflow : in std_logic;
		
		filter_array_din : in dout_array_t(CHANNELS-1 downto 0); -- TODO: zdefiniowaæ rozmiar danych w tablicy
		dfilter_array_din : in dout_array_t(CHANNELS-1 downto 0);												
		
		filter_dout : out signed(AXIS_DATA_WIDTH-1 downto 0);
		dfilter_dout : out signed(AXIS_DATA_WIDTH-1 downto 0) 
		);
end dual_MUX;

architecture dual_MUX of dual_MUX is 

signal filter_dout_sig : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');
signal dfilter_dout_sig : signed(AXIS_DATA_WIDTH-1 downto 0) := (others => '0');	

begin
	filter_dout_sig <= filter_array_din(to_integer(unsigned(f_index))) when underflow='1' else filter_dout_sig;
	dfilter_dout_sig <= dfilter_array_din(to_integer(unsigned(f_index))) when underflow='1' else dfilter_dout_sig;
	
	filter_dout	 <= filter_dout_sig when arestn='1' else (others => '0');
	dfilter_dout <= dfilter_dout_sig when arestn='1' else (others => '0');
end dual_MUX;


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