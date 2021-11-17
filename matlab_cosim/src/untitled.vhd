library filter_bank;
library ieee;

use filter_bank.array_type_pkg.all;
use ieee.std_logic_1164.all;

entity untitled is
end untitled;

architecture COSIMULATION of untitled is


component filter_bank
	generic (
	CHANNELS : INTEGER := 2;
	OVERSAMPLING_RATE : INTEGER := 1;
	AXIS_IQ_TDATA_WIDTH : INTEGER := 32);
	port (
	CLK : in  STD_LOGIC;
	ARESTN : in  STD_LOGIC;
	DIN : in  STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
	DOUT : out dout_array_t(CHANNELS-1 downto 0));
end component;


for \untitled/HDL Black-Box\ : filter_bank use entity filter_bank.filter_bank(filter_bank_arch);

--Signals declaration for module untitled/HDL Black-Box(filter_bank_arch)
constant \untitled/HDL Black-Box/CHANNELS\ : INTEGER := 32;
constant \untitled/HDL Black-Box/OVERSAMPLING_RATE\ : INTEGER := 1;
constant \untitled/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\ : INTEGER := 32;
signal \untitled/HDL Black-Box/CLK\ : STD_LOGIC;
signal \untitled/HDL Black-Box/ARESTN\ : STD_LOGIC;
signal \untitled/HDL Black-Box/DIN\ : STD_LOGIC_VECTOR(\untitled/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\-1 downto 0);
signal \untitled/HDL Black-Box/DOUT\ : dout_array_t(\untitled/HDL Black-Box/CHANNELS\-1 downto 0);

begin

	\untitled/HDL Black-Box\ : filter_bank
	generic map (
	CHANNELS => \untitled/HDL Black-Box/CHANNELS\,
	OVERSAMPLING_RATE => \untitled/HDL Black-Box/OVERSAMPLING_RATE\,
	AXIS_IQ_TDATA_WIDTH => \untitled/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\)
	port map(
	CLK => \untitled/HDL Black-Box/CLK\,
	ARESTN => \untitled/HDL Black-Box/ARESTN\,
	DIN => \untitled/HDL Black-Box/DIN\,
	DOUT => \untitled/HDL Black-Box/DOUT\);

end COSIMULATION;

