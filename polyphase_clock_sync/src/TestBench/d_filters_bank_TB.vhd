library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use std.textio.all;

library polyphase_clock_sync;
use polyphase_clock_sync.array_type_pkg.all;

	-- Add your library and packages declaration here ...

entity d_filters_bank_tb is
	-- Generic declarations of the tested unit
		generic(
		CHANNELS : INTEGER := 32;
		OVERSAMPLING_RATE : INTEGER := 1;
		AXIS_DATA_WIDTH : INTEGER := 32 );
end d_filters_bank_tb;

architecture TB_ARCHITECTURE of d_filters_bank_tb is
	-- Component declaration of the tested unit
	component d_filters_bank
		generic(
		CHANNELS : INTEGER := 32;
		OVERSAMPLING_RATE : INTEGER := 1;
		AXIS_DATA_WIDTH : INTEGER := 32 );
	port(
		CLK : in STD_LOGIC;
		ARESTN : in STD_LOGIC;
		DIN : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
		DOUT : out dout_array_t(CHANNELS-1 downto 0);
		s_axis_tready : out STD_LOGIC;
		s_axis_tvalid : in STD_LOGIC;
		m_axis_tvalid : out STD_LOGIC;
		m_axis_tready : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC := '0';
	signal ARESTN : STD_LOGIC := '0';
	signal DIN : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
	signal s_axis_tvalid : STD_LOGIC;
	signal m_axis_tready : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal DOUT : dout_array_t(CHANNELS-1 downto 0);
	signal s_axis_tready : STD_LOGIC;
	signal m_axis_tvalid : STD_LOGIC;

	-- Add your code here ...
	type impulse_t is array(2 downto 0) of signed(AXIS_DATA_WIDTH-1 downto 0);
	signal impulse : impulse_t := ((others=>'0'), x"00000001", (others=>'0'));
	signal counter : integer range 0 to 2 := 2;

begin

	-- Unit Under Test port map
	UUT : d_filters_bank
		generic map (
			CHANNELS => CHANNELS,
			OVERSAMPLING_RATE => OVERSAMPLING_RATE,
			AXIS_DATA_WIDTH => AXIS_DATA_WIDTH
		)

		port map (
			CLK => CLK,
			ARESTN => ARESTN,
			DIN => DIN,
			DOUT => DOUT,
			s_axis_tready => s_axis_tready,
			s_axis_tvalid => s_axis_tvalid,
			m_axis_tvalid => m_axis_tvalid,
			m_axis_tready => m_axis_tready
		);

	-- Add your stimulus here ...
	
CLOCK: process begin
	CLK <= not CLK;
	wait for 5ns;
end process CLOCK;

RESET : process begin
	ARESTN <= '0'; wait for 10ns; ARESTN <= '1'; 
	wait;
end process RESET;	

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
		
		if(s_axis_tready = '1') then
			DIN <= to_signed(data_read, DIN'length);
			s_axis_tvalid <= '1';
		else
			s_axis_tvalid <= '0';
		end if;
	end if;
end process READ_FILE;

m_axis_tready <= '1';

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_d_filters_bank of d_filters_bank_tb is
	for TB_ARCHITECTURE
		for UUT : d_filters_bank
			use entity work.d_filters_bank(d_filters_bank_arch);
		end for;
	end for;
end TESTBENCH_FOR_d_filters_bank;

