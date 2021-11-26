library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library polyphase_clock_sync;
use polyphase_clock_sync.array_type_pkg.all;

	-- Add your library and packages declaration here ...

entity filters_bank_tb is
	-- Generic declarations of the tested unit
		generic(
		CHANNELS : INTEGER := 32;
		OVERSAMPLING_RATE : INTEGER := 1;
		AXIS_DATA_WIDTH : INTEGER := 32 );
end filters_bank_tb;

architecture TB_ARCHITECTURE of filters_bank_tb is
	-- Component declaration of the tested unit
	component filters_bank
		generic(
		CHANNELS : INTEGER := 32;
		OVERSAMPLING_RATE : INTEGER := 1;
		AXIS_DATA_WIDTH : INTEGER := 32 );
	port(
		CLK : in STD_LOGIC;
		ARESTN : in STD_LOGIC;
		DIN : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
		DOUT : out dout_array_t(CHANNELS-1 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC := '0';
	signal ARESTN : STD_LOGIC;
	signal DIN : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal DOUT : dout_array_t(CHANNELS-1 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : filters_bank
		generic map (
			CHANNELS => CHANNELS,
			OVERSAMPLING_RATE => OVERSAMPLING_RATE,
			AXIS_DATA_WIDTH => AXIS_DATA_WIDTH
		)

		port map (
			CLK => CLK,
			ARESTN => ARESTN,
			DIN => DIN,
			DOUT => DOUT
		);

	-- Add your stimulus here ...
CLOCK: process begin
	clk <= not clk;
	wait for 5ns;
end process CLOCK;

RESET : process begin
	ARESTN <= '0'; wait for 10ns; ARESTN <= '1'; 
	wait;
end process RESET;

DATA: process begin
	DIN <= (others=>'0'); wait for 8 ns; DIN <= x"00000001"; wait for 5ns; DIN <= (others=>'0');
	wait;
end process DATA;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_filters_bank of filters_bank_tb is
	for TB_ARCHITECTURE
		for UUT : filters_bank
			use entity work.filters_bank(filters_bank_arch);
		end for;
	end for;
end TESTBENCH_FOR_filters_bank;

