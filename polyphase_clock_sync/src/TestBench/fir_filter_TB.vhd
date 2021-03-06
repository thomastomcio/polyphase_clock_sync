library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all; 
use std.textio.all;

	-- Add your library and packages declaration here ...

entity fir_filter_tb is
	-- Generic declarations of the tested unit
		generic(
		AXIS_DATA_WIDTH : INTEGER := 32;
		FILTER_INDEX : INTEGER := 0;
		OVERSAMPLING_RATE : INTEGER := 1;
		number_of_filters : INTEGER := 32;
		num_of_coef : INTEGER := 544;
		coef_size : INTEGER := 12 );
end fir_filter_tb;

architecture TB_ARCHITECTURE of fir_filter_tb is
	-- Component declaration of the tested unit
	component fir_filter
		generic(
		AXIS_DATA_WIDTH : INTEGER := 32;
		FILTER_INDEX : INTEGER := 0;
		OVERSAMPLING_RATE : INTEGER := 1;
		number_of_filters : INTEGER := 32;
		num_of_coef : INTEGER := 544;
		coef_size : INTEGER := 12 );
	port(
		aclk : in STD_LOGIC;
		aresetn : in STD_LOGIC;
		aclken : in STD_LOGIC;
		s_axis_data_tdata : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
		s_axis_data_tvalid : in STD_LOGIC;
		m_axis_data_tdata : out SIGNED(AXIS_DATA_WIDTH-1 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal aclk : STD_LOGIC := '0';
	signal aresetn : STD_LOGIC := '0';
	signal aclken : STD_LOGIC := '1';
	signal s_axis_data_tdata : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
	signal s_axis_data_tvalid : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal m_axis_data_tdata : SIGNED(AXIS_DATA_WIDTH-1 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : fir_filter
		generic map (
			AXIS_DATA_WIDTH => AXIS_DATA_WIDTH,
			FILTER_INDEX => FILTER_INDEX,
			OVERSAMPLING_RATE => OVERSAMPLING_RATE,
			number_of_filters => number_of_filters,
			num_of_coef => num_of_coef,
			coef_size => coef_size
		)

		port map (
			aclk => aclk,
			aresetn => aresetn,
			aclken => aclken,
			s_axis_data_tdata => s_axis_data_tdata,
			s_axis_data_tvalid => s_axis_data_tvalid,
			m_axis_data_tdata => m_axis_data_tdata
		);

	-- Add your stimulus here ...
CLOCK: process begin
	aclk <= not aclk;
	wait for 5ns;
end process CLOCK;

RESET : process begin
	aresetn <= '0'; wait for 10ns; aresetn <= '1'; 
	wait;
end process RESET;

--DATA: process begin
--	s_axis_data_tdata <= (others=>'0');
--	wait for 8 ns;
--	s_axis_data_tdata <= x"00000001";
--	wait for 5ns;
--	s_axis_data_tdata <= (others=>'0');
--	wait;
--end process DATA;				  
--
--s_axis_data_tvalid <= '1';
--

READ_FILE : process(aclk)

file QPSK_data_file : text open read_mode is "./Testbench/QPSK_data.txt";
variable row : line;
variable data_read : integer;

begin
	if(falling_edge(aclk)) then
		if(not endfile(QPSK_data_file)) then
			readline(QPSK_data_file, row);
		end if;
		
		read(row, data_read);
		
		s_axis_data_tdata <= to_signed(data_read, s_axis_data_tdata'length);
	end if;
end process READ_FILE;


CONTROL: process begin	
	s_axis_data_tvalid <= '1';
	wait for 30 ns;	  
	s_axis_data_tvalid <= '0';
end process CONTROL;


end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_fir_filter of fir_filter_tb is
	for TB_ARCHITECTURE
		for UUT : fir_filter
			use entity work.fir_filter(fir_arch);
		end for;
	end for;
end TESTBENCH_FOR_fir_filter;

