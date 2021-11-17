library filter_bank;
library ieee;

use filter_bank.array_type_pkg.all;
use ieee.std_logic_1164.all;

entity filter_bank_test is
end filter_bank_test;

architecture COSIMULATION of filter_bank_test is


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


for \filter_bank_test/HDL Black-Box\ : filter_bank use entity filter_bank.filter_bank(filter_bank_arch);

--Signals declaration for module filter_bank_test/HDL Black-Box(filter_bank_arch)
constant \filter_bank_test/HDL Black-Box/CHANNELS\ : INTEGER := 32;
constant \filter_bank_test/HDL Black-Box/OVERSAMPLING_RATE\ : INTEGER := 1;
constant \filter_bank_test/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\ : INTEGER := 32;
signal \filter_bank_test/HDL Black-Box/CLK\ : STD_LOGIC;
signal \filter_bank_test/HDL Black-Box/ARESTN\ : STD_LOGIC;
signal \filter_bank_test/HDL Black-Box/DIN\ : STD_LOGIC_VECTOR(\filter_bank_test/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\-1 downto 0);

begin

	\filter_bank_test/HDL Black-Box\ : filter_bank
	generic map (
	CHANNELS => \filter_bank_test/HDL Black-Box/CHANNELS\,
	OVERSAMPLING_RATE => \filter_bank_test/HDL Black-Box/OVERSAMPLING_RATE\,
	AXIS_IQ_TDATA_WIDTH => \filter_bank_test/HDL Black-Box/AXIS_IQ_TDATA_WIDTH\)
	port map(
	CLK => \filter_bank_test/HDL Black-Box/CLK\,
	ARESTN => \filter_bank_test/HDL Black-Box/ARESTN\,
	DIN => \filter_bank_test/HDL Black-Box/DIN\,
	DOUT => open);

end COSIMULATION;

