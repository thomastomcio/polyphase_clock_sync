library ieee;
library polyphase_clock_sync;

use ieee.MATH_REAL.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use polyphase_clock_sync.array_type_pkg.all;

entity polyphase_clock_sync_HDL_2019 is
end polyphase_clock_sync_HDL_2019;

architecture COSIMULATION of polyphase_clock_sync_HDL_2019 is


component polyphase_clock_sync
	generic (
	CHANNELS : INTEGER := 32;
	DATA_WIDTH : INTEGER := 32;
	FACTOR_WIDTH : INTEGER := 12;
	AXIS_DATA_WIDTH : INTEGER := 32;
	SAMPLES_PER_SYMBOL : INTEGER := 2;
	OVERSAMPLING_RATE : INTEGER := 32);
	port (
	ARESTN : in  STD_LOGIC;
	CLK : in  STD_LOGIC;
	DIN : in  SIGNED(AXIS_DATA_WIDTH-1 downto 0);
	DOUT : out SIGNED(AXIS_DATA_WIDTH-1 downto 0));
end component;


for \polyphase_clock_sync_HDL_2019/HDL Black-Box\ : polyphase_clock_sync use entity polyphase_clock_sync.polyphase_clock_sync(polyphase_clock_sync);

--Signals declaration for module polyphase_clock_sync_HDL_2019/HDL Black-Box(polyphase_clock_sync)
constant \polyphase_clock_sync_HDL_2019/HDL Black-Box/CHANNELS\ : INTEGER := 32;
constant \polyphase_clock_sync_HDL_2019/HDL Black-Box/DATA_WIDTH\ : INTEGER := 32;
constant \polyphase_clock_sync_HDL_2019/HDL Black-Box/FACTOR_WIDTH\ : INTEGER := 12;
constant \polyphase_clock_sync_HDL_2019/HDL Black-Box/AXIS_DATA_WIDTH\ : INTEGER := 32;
constant \polyphase_clock_sync_HDL_2019/HDL Black-Box/SAMPLES_PER_SYMBOL\ : INTEGER := 2;
constant \polyphase_clock_sync_HDL_2019/HDL Black-Box/OVERSAMPLING_RATE\ : INTEGER := 32;
signal \polyphase_clock_sync_HDL_2019/HDL Black-Box/CLK\ : STD_LOGIC;
signal \polyphase_clock_sync_HDL_2019/HDL Black-Box/ARESTN\ : STD_LOGIC;
signal \polyphase_clock_sync_HDL_2019/HDL Black-Box/DIN\ : SIGNED(\polyphase_clock_sync_HDL_2019/HDL Black-Box/AXIS_DATA_WIDTH\-1 downto 0);
signal \polyphase_clock_sync_HDL_2019/HDL Black-Box/DOUT\ : SIGNED(\polyphase_clock_sync_HDL_2019/HDL Black-Box/AXIS_DATA_WIDTH\-1 downto 0);

begin

	\polyphase_clock_sync_HDL_2019/HDL Black-Box\ : polyphase_clock_sync
	generic map (
	CHANNELS => \polyphase_clock_sync_HDL_2019/HDL Black-Box/CHANNELS\,
	DATA_WIDTH => \polyphase_clock_sync_HDL_2019/HDL Black-Box/DATA_WIDTH\,
	FACTOR_WIDTH => \polyphase_clock_sync_HDL_2019/HDL Black-Box/FACTOR_WIDTH\,
	AXIS_DATA_WIDTH => \polyphase_clock_sync_HDL_2019/HDL Black-Box/AXIS_DATA_WIDTH\,
	SAMPLES_PER_SYMBOL => \polyphase_clock_sync_HDL_2019/HDL Black-Box/SAMPLES_PER_SYMBOL\,
	OVERSAMPLING_RATE => \polyphase_clock_sync_HDL_2019/HDL Black-Box/OVERSAMPLING_RATE\)
	port map(
	CLK => \polyphase_clock_sync_HDL_2019/HDL Black-Box/CLK\,
	ARESTN => \polyphase_clock_sync_HDL_2019/HDL Black-Box/ARESTN\,
	DIN => \polyphase_clock_sync_HDL_2019/HDL Black-Box/DIN\,
	DOUT => \polyphase_clock_sync_HDL_2019/HDL Black-Box/DOUT\);

end COSIMULATION;

