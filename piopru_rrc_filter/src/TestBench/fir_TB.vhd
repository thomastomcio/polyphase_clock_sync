library ieee;
use ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_SIGNED.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity fir_tb is
	-- Generic declarations of the tested unit
		generic(
		AXIS_IQ_TDATA_WIDTH : INTEGER := 32;
		num_of_coef : INTEGER := 544;
		coef_size : INTEGER := 12 );
end fir_tb;

architecture TB_ARCHITECTURE of fir_tb is
	-- Component declaration of the tested unit
	component fir
		generic(
		AXIS_IQ_TDATA_WIDTH : INTEGER := 32;
		num_of_coef : INTEGER := 544;
		coef_size : INTEGER := 12 );
	port(
		aclk : in STD_LOGIC;
		aresetn : in STD_LOGIC;
		aclken : in STD_LOGIC;
		s_axis_data_tdata : in STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
		s_axis_data_tready : out STD_LOGIC;
		s_axis_data_tvalid : in STD_LOGIC;
		m_axis_data_tdata : out STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
		m_axis_data_tvalid : out STD_LOGIC;
		m_axis_data_tready : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal aclk : STD_LOGIC := '0';
	signal aresetn : STD_LOGIC := '0';
	signal aclken : STD_LOGIC := '1';
	signal s_axis_data_tdata : STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
	signal s_axis_data_tvalid : STD_LOGIC;
	signal m_axis_data_tready : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal s_axis_data_tready : STD_LOGIC;
	signal m_axis_data_tdata : STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
	signal m_axis_data_tvalid : STD_LOGIC;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : fir
		generic map (
			AXIS_IQ_TDATA_WIDTH => AXIS_IQ_TDATA_WIDTH,
			num_of_coef => num_of_coef,
			coef_size => coef_size
		)

		port map (
			aclk => aclk,
			aresetn => aresetn,
			aclken => aclken,
			s_axis_data_tdata => s_axis_data_tdata,
			s_axis_data_tready => s_axis_data_tready,
			s_axis_data_tvalid => s_axis_data_tvalid,
			m_axis_data_tdata => m_axis_data_tdata,
			m_axis_data_tvalid => m_axis_data_tvalid,
			m_axis_data_tready => m_axis_data_tready
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

DATA: process begin
	s_axis_data_tdata <= (others=>'0');
	wait for 8 ns;
	s_axis_data_tdata <= x"00000001";
	wait for 5ns;
	s_axis_data_tdata <= (others=>'0');
	wait;
end process DATA;				  

s_axis_data_tvalid <= '1';

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_fir of fir_tb is
	for TB_ARCHITECTURE
		for UUT : fir
			use entity work.fir(fir_arch);
		end for;
	end for;
end TESTBENCH_FOR_fir;

