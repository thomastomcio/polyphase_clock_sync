-------------------------------------------------------------------------------
--
-- Title       : filter_bank
-- Design      : filter_bank
-- Author      : thomas
-- Company     : Aldec
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\polyphase_clock_sync\filter_bank\src\filter_bank.vhd
-- Generated   : Wed Oct 27 15:42:48 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
																			   	 
library work;
use work.array_type_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_bank is	
	generic
	(
		CHANNELS : integer := 32; 
		OVERSAMPLING_RATE : integer := 1;
		AXIS_DATA_WIDTH : integer := 32
	);
	port(
		CLK : in std_logic;
		ARESTN : in std_logic;
		DIN : in std_logic_vector(AXIS_DATA_WIDTH-1 downto 0);
		DOUT : out 	dout_array_t(CHANNELS-1 downto 0)
	);
	
end filter_bank;

architecture filter_bank_arch of filter_bank is

--	component LUT -- przechowuje wsp. odpowiedzi impulsowej filtra
--	port(
--	-- TODO	
--	);
--	end component LUT;

	component fir_filter  
		  generic(
		  	AXIS_DATA_WIDTH : integer;
			FILTER_INDEX : integer;
			OVERSAMPLING_RATE : integer;
			number_of_filters : integer;
            num_of_coef : integer;
            coef_size : integer
		  );
	      port (   
            aclk      : in std_logic;
            aresetn      : in std_logic; 
            aclken      : in std_logic; 
            -- Ports of Axi Slave Bus Interface s_axis   
            s_axis_data_tdata      : in std_logic_vector(AXIS_DATA_WIDTH -1 downto 0);
            s_axis_data_tready      : out std_logic;
            s_axis_data_tvalid      : in std_logic;
            
            -- Ports of Axi Master Bus Interface s_axis   
            m_axis_data_tdata      : out std_logic_vector(AXIS_DATA_WIDTH -1 downto 0);
            m_axis_data_tvalid      : out std_logic;
            m_axis_data_tready      : in std_logic
            );
	end component fir_filter;				   
	
	-- sygnaly i typy , inne komponenty	   
signal ACKLEN : std_logic := '1';
signal S_AXIS_TVALID : std_logic := '1';
signal S_AXIS_TREADY : std_logic := '1'; 
--signal M_AXIS_TVALID : std_logic;
signal M_AXIS_TREADY : std_logic := '1';

  
begin
   GEN_FILTER_BANK: for I in 0 to CHANNELS-1 generate
      FIR : fir_filter
	  generic map
	  (	
		AXIS_DATA_WIDTH => 32,
		FILTER_INDEX => I,
		OVERSAMPLING_RATE => OVERSAMPLING_RATE,
		number_of_filters => CHANNELS,
		num_of_coef => 51,
		coef_size => 12
		)
	  port map
	  ( 
		aclk => CLK, 
		aresetn => ARESTN,
		aclken => ACKLEN,
		s_axis_data_tvalid => S_AXIS_TVALID,
		s_axis_data_tready => S_AXIS_TREADY,
		s_axis_data_tdata => DIN,
		m_axis_data_tready => M_AXIS_TREADY,
		m_axis_data_tdata => DOUT(I)
	   );
   end generate GEN_FILTER_BANK;  

--CTRL : process (ARESTN, CLK)
--begin
--	if (ARESTN = '0') then
--		DOUT <= (others => (others=>'0'));		
--	elsif (rising_edge(CLK)) then
--		-- dzialaj na narastajace zbocze zegarowe	
--	end if;
--end process CTRL;
--	
   
end filter_bank_arch;
