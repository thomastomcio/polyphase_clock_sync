library polyphase_clock_sync;
use polyphase_clock_sync.array_type_pkg.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

	-- Add your library and packages declaration here ...

entity polyphase_clock_sync_tb is
	-- Generic declarations of the tested unit
		generic(
		CHANNELS : INTEGER := 32;
		DATA_WIDTH : INTEGER := 32;
		FACTOR_WIDTH : INTEGER := 12;
		AXIS_DATA_WIDTH : INTEGER := 32;
		SAMPLES_PER_SYMBOL : INTEGER := 2;
		OVERSAMPLING_RATE : INTEGER := 32 );
end polyphase_clock_sync_tb;

architecture TB_ARCHITECTURE of polyphase_clock_sync_tb is
	-- Component declaration of the tested unit
	component polyphase_clock_sync
		generic(
		CHANNELS : INTEGER := 32;
		DATA_WIDTH : INTEGER := 32;
		FACTOR_WIDTH : INTEGER := 12;
		AXIS_DATA_WIDTH : INTEGER := 32;
		SAMPLES_PER_SYMBOL : INTEGER := 2;
		OVERSAMPLING_RATE : INTEGER := 32 );
	port(
		ARESTN : in STD_LOGIC;
		CLK : in STD_LOGIC;
		DIN : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
		DOUT : out SIGNED(AXIS_DATA_WIDTH-1 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal ARESTN : STD_LOGIC := '0';
	signal CLK : STD_LOGIC := '0';
	signal DIN : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal DOUT : SIGNED(AXIS_DATA_WIDTH-1 downto 0);

	-- Add your code here ...
	constant T_reset : time := 20 ns;
	
begin

	-- Unit Under Test port map
	UUT : polyphase_clock_sync
		generic map (
			CHANNELS => CHANNELS,
			DATA_WIDTH => DATA_WIDTH,
			FACTOR_WIDTH => FACTOR_WIDTH,
			AXIS_DATA_WIDTH => AXIS_DATA_WIDTH,
			SAMPLES_PER_SYMBOL => SAMPLES_PER_SYMBOL,
			OVERSAMPLING_RATE => OVERSAMPLING_RATE
		)

		port map (
			ARESTN => ARESTN,
			CLK => CLK,
			DIN => DIN,
			DOUT => DOUT
		);

-- CLK
clock : process
begin
	CLK <=  not CLK; 
	wait for 2.5ns; 
end process clock;	

-- AREATN
ARESTN <= '0', '1' after T_reset;

-- DATA, read from file
data: process
DIN <= 


end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_polyphase_clock_sync of polyphase_clock_sync_tb is
	for TB_ARCHITECTURE
		for UUT : polyphase_clock_sync
			use entity work.polyphase_clock_sync(polyphase_clock_sync);
		end for;
	end for;
end TESTBENCH_FOR_polyphase_clock_sync;

