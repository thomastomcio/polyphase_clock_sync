library fir_filter;
library ieee;

use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_SIGNED.all;

entity fir_filter_component_test is
end fir_filter_component_test;

architecture COSIMULATION of fir_filter_component_test is


component fir
	generic (
	AXIS_IQ_TDATA_WIDTH : INTEGER := 32;
	FILTER_INDEX : INTEGER := 0;
	OVERSAMPLING_RATE : INTEGER := 1;
	number_of_filters : INTEGER := 32;
	num_of_coef : INTEGER := 51;
	coef_size : INTEGER := 12);
	port (
	aclk : in  STD_LOGIC;
	aresetn : in  STD_LOGIC;
	aclken : in  STD_LOGIC;
	s_axis_data_tdata : in  STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
	s_axis_data_tready : out STD_LOGIC;
	s_axis_data_tvalid : in  STD_LOGIC;
	m_axis_data_tdata : out STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
	m_axis_data_tvalid : out STD_LOGIC;
	m_axis_data_tready : in  STD_LOGIC);
end component;


for \fir_filter_component_test/HDL Black-Box\ : fir use entity fir_filter.fir(fir_arch);

--Signals declaration for module fir_filter_component_test/HDL Black-Box(fir_arch)
constant \fir_filter_component_test/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\ : INTEGER := 32;
constant \fir_filter_component_test/HDL Black-Box/FILTER_INDEX\ : INTEGER := 0;
constant \fir_filter_component_test/HDL Black-Box/OVERSAMPLING_RATE\ : INTEGER := 1;
constant \fir_filter_component_test/HDL Black-Box/number_of_filters\ : INTEGER := 1;
constant \fir_filter_component_test/HDL Black-Box/num_of_coef\ : INTEGER := 51;
constant \fir_filter_component_test/HDL Black-Box/coef_size\ : INTEGER := 12;
signal \fir_filter_component_test/HDL Black-Box/aclk\ : STD_LOGIC;
signal \fir_filter_component_test/HDL Black-Box/aresetn\ : STD_LOGIC;
signal \fir_filter_component_test/HDL Black-Box/aclken\ : STD_LOGIC;
signal \fir_filter_component_test/HDL Black-Box/s_axis_data_tdata\ : STD_LOGIC_VECTOR(\fir_filter_component_test/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\-1 downto 0);
signal \fir_filter_component_test/HDL Black-Box/s_axis_data_tvalid\ : STD_LOGIC;
signal \fir_filter_component_test/HDL Black-Box/m_axis_data_tready\ : STD_LOGIC;
signal \fir_filter_component_test/HDL Black-Box/s_axis_data_tready\ : STD_LOGIC;
signal \fir_filter_component_test/HDL Black-Box/m_axis_data_tdata\ : STD_LOGIC_VECTOR(\fir_filter_component_test/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\-1 downto 0);
signal \fir_filter_component_test/HDL Black-Box/m_axis_data_tvalid\ : STD_LOGIC;

begin

	\fir_filter_component_test/HDL Black-Box\ : fir
	generic map (
	AXIS_IQ_TDATA_WIDTH => \fir_filter_component_test/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\,
	FILTER_INDEX => \fir_filter_component_test/HDL Black-Box/FILTER_INDEX\,
	OVERSAMPLING_RATE => \fir_filter_component_test/HDL Black-Box/OVERSAMPLING_RATE\,
	number_of_filters => \fir_filter_component_test/HDL Black-Box/number_of_filters\,
	num_of_coef => \fir_filter_component_test/HDL Black-Box/num_of_coef\,
	coef_size => \fir_filter_component_test/HDL Black-Box/coef_size\)
	port map(
	aclk => \fir_filter_component_test/HDL Black-Box/aclk\,
	aresetn => \fir_filter_component_test/HDL Black-Box/aresetn\,
	aclken => \fir_filter_component_test/HDL Black-Box/aclken\,
	s_axis_data_tdata => \fir_filter_component_test/HDL Black-Box/s_axis_data_tdata\,
	s_axis_data_tvalid => \fir_filter_component_test/HDL Black-Box/s_axis_data_tvalid\,
	m_axis_data_tready => \fir_filter_component_test/HDL Black-Box/m_axis_data_tready\,
	s_axis_data_tready => \fir_filter_component_test/HDL Black-Box/s_axis_data_tready\,
	m_axis_data_tdata => \fir_filter_component_test/HDL Black-Box/m_axis_data_tdata\,
	m_axis_data_tvalid => \fir_filter_component_test/HDL Black-Box/m_axis_data_tvalid\);

end COSIMULATION;

