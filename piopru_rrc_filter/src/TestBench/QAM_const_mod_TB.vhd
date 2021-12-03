-------------------------------------------------------------------------------
--
-- Title       : QM_testbench
-- Design      : piopru_rrc_filter
-- Author      : thomas
-- Company     : Aldec
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\polyphase_clock_sync\piopru_rrc_filter\src\QM_testbench.vhd
-- Generated   : Fri Oct 29 12:46:39 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;       


use work.QAM_const_mod;


entity Top is

	generic(

		AXIS_IQ_TDATA_WIDTH : integer := 32;--te? potem zeby przy tb nie zapomniec   
		num_of_coef : integer :=51;--51;--- number of coefficients
		coef_size : integer :=12--13--- number of coefficient bits     

	);
end Top;




architecture Top of Top is

	component fir
		generic(

			AXIS_IQ_TDATA_WIDTH : integer := 32;--te? potem zeby przy tb nie zapomniec   
			num_of_coef : integer :=51;--51;--- number of coefficients
			coef_size       : integer :=12--13--- number of coefficient bits     

		);

		port (   
			aclk      	: in std_logic;
			aresetn     : in std_logic; 
			aclken      : in std_logic; 
			-- Ports of Axi Slave Bus Interface s_axis   
			s_axis_data_tdata      	: in std_logic_vector(AXIS_IQ_TDATA_WIDTH -1 downto 0);
			s_axis_data_tready      	: out std_logic;
			s_axis_data_tvalid      	: in std_logic;

			-- Ports of Axi Master Bus Interface s_axis   
			m_axis_data_tdata      	: out std_logic_vector(AXIS_IQ_TDATA_WIDTH -1 downto 0);
			m_axis_data_tvalid      : out std_logic;
			m_axis_data_tready      : in std_logic
		);                 
	end component;

	component QAM_const_mod
		port(
			real_out : out std_logic_vector(31 downto 0);
			imag_out : out std_logic_vector(31 downto 0);
			inp : in std_logic_vector(3 downto 0);
			clk : in std_logic;
			rst : in std_logic
		);
	end component;

	---- Signal declarations used on the diagram ----
	constant PERIOD : time := 20 ns;
	
	signal clk : std_logic;
	signal rst : std_logic;
	signal clken : std_logic;

	signal bit_input : std_logic_vector(3 downto 0);
	signal input_real : std_logic_vector(31 downto 0);
	signal input_imag : std_logic_vector(31 downto 0);
	signal output_real : std_logic_vector(AXIS_IQ_TDATA_WIDTH -1 downto 0);
	signal output_imag : std_logic_vector(AXIS_IQ_TDATA_WIDTH -1 downto 0);

	signal s_axis_data_tdata  : std_logic_vector(AXIS_IQ_TDATA_WIDTH -1 downto 0);
	signal s_axis_data_tready : std_logic;
	signal s_axis_data_tvalid : std_logic;

	signal m_axis_data_tdata  : std_logic_vector(AXIS_IQ_TDATA_WIDTH -1 downto 0);
	signal m_axis_data_tvalid : std_logic;
	signal m_axis_data_tready : std_logic;

begin 
	---  Component instantiations  ----

	FIR_REAL: fir
		port map(
			aclk => clk,
			aresetn => rst,    
			aclken  =>   clken,

			s_axis_data_tdata =>  input_real,
			s_axis_data_tready  =>  s_axis_data_tready,
			s_axis_data_tvalid  =>   s_axis_data_tvalid, 

			m_axis_data_tdata  =>  output_real,
			m_axis_data_tvalid =>   m_axis_data_tvalid,
			m_axis_data_tready =>   m_axis_data_tready
		);


	FIR_IMAG: fir
		port map(
			aclk => clk,
			aresetn => rst,    
			aclken  =>   clken,

			s_axis_data_tdata => input_imag,
			s_axis_data_tready =>  s_axis_data_tready,
			s_axis_data_tvalid  =>   s_axis_data_tvalid, 

			m_axis_data_tdata => output_imag,
			m_axis_data_tvalid =>   m_axis_data_tvalid,
			m_axis_data_tready =>   m_axis_data_tready
		);


QAM_C_M: QAM_const_mod
		port map (
			real_out => input_real,
			imag_out => input_imag,
			inp => bit_input,
			clk => clk,
			rst => rst
		);


process	

begin

	clk <= '0'; 

	wait for PERIOD/2;

	clk <= '1'; 

	wait for PERIOD/2;

end process;



--Generating resets.

process

begin
	clken <= '1';
	s_axis_data_tdata  <= (others => '1');
	s_axis_data_tready <= '1';
	s_axis_data_tvalid <= '1';

	m_axis_data_tdata  <= (others => '1');
	m_axis_data_tvalid <= '1';
	m_axis_data_tready <= '1';

	

	rst <= '0';

	for rstTime in 0 to 3 loop

		wait until rising_edge(clk);

	end loop;

	rst <= '1';
	wait for 30 ns;
	rst <= '0';
	wait for 100 ns;
	rst <= '1';

	wait;

end process;

process
begin
	--bit_input <= "0000";
	wait for 100 ns;
	bit_input <= "0001";   
	wait for 1 us;
	bit_input <= "0010";
	
	wait for 2 us;
	bit_input <= "0100";
	
--	wait for 36 ns;
--	bit_input <= "0010";
--	wait for 36 ns;
--	bit_input <= "0110";
--	wait for 36 ns;
--	bit_input <= "1110";
--	wait for 36 ns;
--	bit_input <= "0000";
--	wait for 36 ns;
--	bit_input <= "1111";
--	wait for 80 ns;
--	bit_input <= "1000";
--	wait for 80 ns;
--	bit_input <= "1010"; 
--	
--		wait for 100 ns;
--	bit_input <= "0001";
--	wait for 36 ns;
--	bit_input <= "0010";
--	wait for 36 ns;
--	bit_input <= "0110";
--	wait for 36 ns;
--	bit_input <= "1110";
--	wait for 36 ns;
--	bit_input <= "0000";
--	wait for 36 ns;
--	bit_input <= "1111";
--	wait for 80 ns;
--	bit_input <= "1000";
--	wait for 80 ns;
--	bit_input <= "1010";
	
	wait;
end process;

end Top;











