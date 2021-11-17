library ieee;
library piopru_rrc_filter;

use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_SIGNED.all;

entity piopru_fir_test is
end piopru_fir_test;

architecture COSIMULATION of piopru_fir_test is


component fir
	generic (
	AXIS_IQ_TDATA_WIDTH : INTEGER := 32;
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


for \piopru_fir_test/HDL Black-Box1\ : fir use entity piopru_rrc_filter.fir(fir_arch);

--Signals declaration for module piopru_fir_test/HDL Black-Box1(fir_arch)
constant \piopru_fir_test/HDL Black-Box1/AXIS_IQ_TDATA_WIDTH\ : INTEGER := 32;
constant \piopru_fir_test/HDL Black-Box1/num_of_coef\ : INTEGER := 51;
constant \piopru_fir_test/HDL Black-Box1/coef_size\ : INTEGER := 12;
signal \piopru_fir_test/HDL Black-Box1/aclk\ : STD_LOGIC;
signal \piopru_fir_test/HDL Black-Box1/aresetn\ : STD_LOGIC;
signal \piopru_fir_test/HDL Black-Box1/aclken\ : STD_LOGIC;
signal \piopru_fir_test/HDL Black-Box1/s_axis_data_tdata\ : STD_LOGIC_VECTOR(\piopru_fir_test/HDL Black-Box1/AXIS_IQ_TDATA_WIDTH\-1 downto 0);
signal \piopru_fir_test/HDL Black-Box1/s_axis_data_tvalid\ : STD_LOGIC;
signal \piopru_fir_test/HDL Black-Box1/m_axis_data_tready\ : STD_LOGIC;
signal \piopru_fir_test/HDL Black-Box1/s_axis_data_tready\ : STD_LOGIC;
signal \piopru_fir_test/HDL Black-Box1/m_axis_data_tdata\ : STD_LOGIC_VECTOR(\piopru_fir_test/HDL Black-Box1/AXIS_IQ_TDATA_WIDTH\-1 downto 0);
signal \piopru_fir_test/HDL Black-Box1/m_axis_data_tvalid\ : STD_LOGIC;

begin

	\piopru_fir_test/HDL Black-Box1\ : fir
	generic map (
	AXIS_IQ_TDATA_WIDTH => \piopru_fir_test/HDL Black-Box1/AXIS_IQ_TDATA_WIDTH\,
	num_of_coef => \piopru_fir_test/HDL Black-Box1/num_of_coef\,
	coef_size => \piopru_fir_test/HDL Black-Box1/coef_size\)
	port map(
	aclk => \piopru_fir_test/HDL Black-Box1/aclk\,
	aresetn => \piopru_fir_test/HDL Black-Box1/aresetn\,
	aclken => \piopru_fir_test/HDL Black-Box1/aclken\,
	s_axis_data_tdata => \piopru_fir_test/HDL Black-Box1/s_axis_data_tdata\,
	s_axis_data_tvalid => \piopru_fir_test/HDL Black-Box1/s_axis_data_tvalid\,
	m_axis_data_tready => \piopru_fir_test/HDL Black-Box1/m_axis_data_tready\,
	s_axis_data_tready => \piopru_fir_test/HDL Black-Box1/s_axis_data_tready\,
	m_axis_data_tdata => \piopru_fir_test/HDL Black-Box1/m_axis_data_tdata\,
	m_axis_data_tvalid => \piopru_fir_test/HDL Black-Box1/m_axis_data_tvalid\);

end COSIMULATION;

