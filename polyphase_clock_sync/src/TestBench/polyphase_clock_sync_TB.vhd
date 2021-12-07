library polyphase_clock_sync;
use polyphase_clock_sync.array_type_pkg.all;
library ieee;
use ieee.MATH_REAL.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all; 
use std.textio.all;

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
		m_axis_tready : in STD_LOGIC;
		s_axis_tvalid : in STD_LOGIC;
		DIN : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
		m_axis_tvalid : out STD_LOGIC;
		s_axis_tready : out STD_LOGIC;
		DOUT : out SIGNED(AXIS_DATA_WIDTH-1 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal ARESTN : STD_LOGIC := '0';
	signal CLK : STD_LOGIC := '0';
	signal m_axis_tready : STD_LOGIC := '1';
	signal s_axis_tvalid : STD_LOGIC := '0';
	signal DIN : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal m_axis_tvalid : STD_LOGIC;
	signal s_axis_tready : STD_LOGIC;
	signal DOUT : SIGNED(AXIS_DATA_WIDTH-1 downto 0);

	-- Add your code here ...

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
			m_axis_tready => m_axis_tready,
			s_axis_tvalid => s_axis_tvalid,
			DIN => DIN,
			m_axis_tvalid => m_axis_tvalid,
			s_axis_tready => s_axis_tready,
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

--DATA: process begin
--	DIN <= (others=>'0'); wait for 8 ns; DIN <= x"00000001"; wait for 5ns; DIN <= (others=>'0');
--	wait;
--end process DATA;	 

READ_FILE : process(CLK)
file QPSK_data_file : text open read_mode is "./Testbench/QPSK_data.txt";
variable row : line;
variable data_read : integer;
begin
	if(falling_edge(CLK)) then
		if(not endfile(QPSK_data_file)) then
			readline(QPSK_data_file, row);
		end if;
		
		read(row, data_read);
		
		if(s_axis_tready = '1')	then
			DIN <= to_signed(data_read, DIN'length);
			s_axis_tvalid <= '1';
		else 
			s_axis_tvalid <= '0';
		end if;
	end if;
end process READ_FILE;


end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_polyphase_clock_sync of polyphase_clock_sync_tb is
	for TB_ARCHITECTURE
		for UUT : polyphase_clock_sync
			use entity work.polyphase_clock_sync(polyphase_clock_sync);
		end for;
	end for;
end TESTBENCH_FOR_polyphase_clock_sync;

