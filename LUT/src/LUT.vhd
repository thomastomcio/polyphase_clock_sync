-- LUT memory for FIR polyphase filters coefficients
-- TODO:
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

use ieee.math_real.all;
--use IEEE.math_real."log2";  
--use IEEE.math_real."floor";

entity LUT is
	generic
		(
		COEFF_COUNT : integer := 51;
		COEFF_DATA_SIZE : integer := 32;
		--CHANNELS : integer := 2	
		);
	port(
		clk : in std_logic;
		arestn : in std_logic;
		--	filter_index : in std_logic_vector(integer(floor(log2(real(CHANNELS)))) downto 0);	
		coeff_index : in std_logic_vector(integer(floor(log2(real(COEFF_COUNT)))) downto 0);
		coeff_out : out std_logic_vector(integer(floor(log2(real(COEFF_DATA_SIZE)))) downto 0)
		);	
end	LUT;

architecture LUT_arch of LUT is
	--signal coeff_index = 	  
	--type LUT_row is array(0 to COEFF_COUNT-1) of std_logic_vector(COEFF_DATA_SIZE-1 downto 0);
	type LUT_memory is array(0 to COEFF_COUNT-1) of std_logic_vector(COEFF_DATA_SIZE-1 downto 0);			
	signal LUT_coeff : LUT_memory := ("", ""); 
begin
	coeff_out <= LUT_coeff(conv_integer(coeff_index);
	--	process(filter_index)
	--	begin
	--	end process;
end architecture;

