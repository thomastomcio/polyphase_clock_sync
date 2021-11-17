library ieee;
library matched_filter;

use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

entity fir_filter_test_proj is
end fir_filter_test_proj;

architecture COSIMULATION of fir_filter_test_proj is


component fir_filter_4
	port (
	i_clk : in  STD_LOGIC;
	i_rstb : in  STD_LOGIC;
	i_coeff_0 : in  STD_LOGIC_VECTOR(7 downto 0);
	i_coeff_1 : in  STD_LOGIC_VECTOR(7 downto 0);
	i_coeff_2 : in  STD_LOGIC_VECTOR(7 downto 0);
	i_coeff_3 : in  STD_LOGIC_VECTOR(7 downto 0);
	i_data : in  STD_LOGIC_VECTOR(7 downto 0);
	o_data : out STD_LOGIC_VECTOR(9 downto 0));
end component;


for \fir_filter_test_proj/HDL Black-Box\ : fir_filter_4 use entity matched_filter.fir_filter_4(rtl);

--Signals declaration for module fir_filter_test_proj/HDL Black-Box(rtl)
signal \fir_filter_test_proj/HDL Black-Box/i_clk\ : STD_LOGIC;
signal \fir_filter_test_proj/HDL Black-Box/i_rstb\ : STD_LOGIC;
signal \fir_filter_test_proj/HDL Black-Box/i_coeff_0\ : STD_LOGIC_VECTOR(7 downto 0);
signal \fir_filter_test_proj/HDL Black-Box/i_coeff_1\ : STD_LOGIC_VECTOR(7 downto 0);
signal \fir_filter_test_proj/HDL Black-Box/i_coeff_2\ : STD_LOGIC_VECTOR(7 downto 0);
signal \fir_filter_test_proj/HDL Black-Box/i_coeff_3\ : STD_LOGIC_VECTOR(7 downto 0);
signal \fir_filter_test_proj/HDL Black-Box/i_data\ : STD_LOGIC_VECTOR(7 downto 0);
signal \fir_filter_test_proj/HDL Black-Box/o_data\ : STD_LOGIC_VECTOR(9 downto 0);

begin

	\fir_filter_test_proj/HDL Black-Box\ : fir_filter_4
	port map(
	i_clk => \fir_filter_test_proj/HDL Black-Box/i_clk\,
	i_rstb => \fir_filter_test_proj/HDL Black-Box/i_rstb\,
	i_coeff_0 => \fir_filter_test_proj/HDL Black-Box/i_coeff_0\,
	i_coeff_1 => \fir_filter_test_proj/HDL Black-Box/i_coeff_1\,
	i_coeff_2 => \fir_filter_test_proj/HDL Black-Box/i_coeff_2\,
	i_coeff_3 => \fir_filter_test_proj/HDL Black-Box/i_coeff_3\,
	i_data => \fir_filter_test_proj/HDL Black-Box/i_data\,
	o_data => \fir_filter_test_proj/HDL Black-Box/o_data\);

end COSIMULATION;

