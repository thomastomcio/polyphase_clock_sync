library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	  
use ieee.math_real.all;
use std.textio.all;

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
		DOUT : out SIGNED(AXIS_DATA_WIDTH-1 downto 0);
		s_axis_tready : out STD_LOGIC;
		s_axis_tvalid : in STD_LOGIC;
		m_axis_tvalid : out STD_LOGIC;
		m_axis_tready : in STD_LOGIC; 
		
		f_index : in std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0);	  -- sprawdzi? czy nie da si? sam 'integer'
		underflow : in std_logic
		);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC := '0';
	signal ARESTN : STD_LOGIC := '0';
	signal DIN : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
	signal s_axis_tvalid : STD_LOGIC;
	signal m_axis_tready : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal DOUT :  SIGNED(AXIS_DATA_WIDTH-1 downto 0);
	signal s_axis_tready : STD_LOGIC;
	signal m_axis_tvalid : STD_LOGIC;	   
	
	signal f_index : std_logic_vector(integer(ceil(log2(real(CHANNELS))))-1 downto 0);	  -- sprawdzi? czy nie da si? sam 'integer'
	signal underflow : std_logic;

	-- Add your code here ...
	type impulse_t is array(2 downto 0) of signed(AXIS_DATA_WIDTH-1 downto 0);
	signal impulse : impulse_t := ((others=>'0'), x"00000001", (others=>'0'));
	signal counter : integer range 0 to 2 := 2;
	

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
			DOUT => DOUT,
			s_axis_tready => s_axis_tready,
			s_axis_tvalid => s_axis_tvalid,
			m_axis_tvalid => m_axis_tvalid,
			m_axis_tready => m_axis_tready,
			
			f_index => f_index,
			underflow => underflow
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

--DATA: process begin	
--	DIN<=(others=>'0');
--	s_axis_tvalid <= '0';  
--	wait until ARESTN = '1';
--	if(s_axis_tready = '1') then
--		s_axis_tvalid <= '1';
--		wait until CLK = '1';
--	end if;
--	DIN <= impulse(counter);
--	counter <= counter - 1;
--	wait until CLK = '0';
--	
--	s_axis_tvalid <= '0';  
--	if(s_axis_tready = '1') then
--		s_axis_tvalid <= '1';
--		wait until CLK = '1';
--	end if;
--	DIN <= impulse(counter);
--	counter <= counter - 1;
--	wait until CLK = '0';
--	
--	s_axis_tvalid <= '0';  
--	if(s_axis_tready = '1') then
--		s_axis_tvalid <= '1';
--		wait until CLK = '1';
--	end if;
--	DIN <= impulse(counter);
--	wait until CLK = '0';
--	
--	s_axis_tvalid <= '1';  
--	
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
		
		if(s_axis_tready = '1') then
			DIN <= to_signed(data_read, DIN'length);
			s_axis_tvalid <= '1';
		else
			s_axis_tvalid <= '0';
		end if;
	end if;
end process READ_FILE;

m_axis_tready <= '1';

--DATA: process(clk) begin
--	if (s_axis_tready = '1') then
--		DIN <= impulse(counter);
--		s_axis_tvalid <= '1';
--	end if;
--	
--	if(counter = 0) then
--		return;
--	else
--		counter <= counter - 1;
--	end if;
--end process DATA;		

--counter <= counter-1 when counter>0 and s_axis_tvalid = '1' else 0;
--DIN <= impulse(counter) when counter>0 and s_axis_tvalid = '1' else (others=>'0'); 
--s_axis_tvalid <= s_axis_tready; 	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_filters_bank of filters_bank_tb is
	for TB_ARCHITECTURE
		for UUT : filters_bank
			use entity work.filters_bank(filters_bank_arch);
		end for;
	end for;
end TESTBENCH_FOR_filters_bank;

