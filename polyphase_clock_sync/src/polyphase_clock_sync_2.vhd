-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : polyphase_clock_sync
-- Author      : thomas
-- Company     : AGH
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\2_polyphase_clock_sync\temp_polyphase_clock_sync\polyphase_clock_sync\polyphase_clock_sync\compile\polyphase_clock_sync.vhd
-- Generated   : Tue Dec  7 21:54:25 2021
-- From        : c:/My_Designs/2_polyphase_clock_sync/temp_polyphase_clock_sync/polyphase_clock_sync/polyphase_clock_sync/src/polyphase_clock_sync.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library polyphase_clock_sync;
use polyphase_clock_sync.array_type_pkg.all;

---- Included from components --
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_signed.all;

entity polyphase_clock_sync is
  generic(
       CHANNELS :integer:=32;
       DATA_WIDTH:integer:=32;
       FACTOR_WIDTH:integer :=12;
       AXIS_DATA_WIDTH:integer :=32;
       SAMPLES_PER_SYMBOL : integer := 2;
       OVERSAMPLING_RATE : integer := 32
  );
  port(
       ARESTN : in STD_LOGIC;
       CLK : in STD_LOGIC;
       m_axis_tready : in STD_LOGIC;
       s_axis_tvalid : in STD_LOGIC;
       DIN : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
       m_axis_tvalid : out STD_LOGIC;
       s_axis_tready : out STD_LOGIC;
       DOUT : out SIGNED(AXIS_DATA_WIDTH-1 downto 0)
  );
end polyphase_clock_sync;

architecture polyphase_clock_sync of polyphase_clock_sync is

---- Component declarations -----

component dual_MUX
  generic(
       CHANNELS : INTEGER := 32;
       AXIS_DATA_WIDTH : INTEGER := 32
  );
  port (
       arestn : in STD_LOGIC;
       clk : in STD_LOGIC;
       dfilter_array_din : in dout_array_t(CHANNELS-1 downto 0);
       f_index : in STD_LOGIC_VECTOR(integer(ceil(log2(real(CHANNELS))))-1 downto 0);
       filter_array_din : in dout_array_t(CHANNELS-1 downto 0);
       m_axis_tready : in STD_LOGIC;
       s_axis_tvalid : in STD_LOGIC;
       underflow : in STD_LOGIC;
       dfilter_dout : out SIGNED(AXIS_DATA_WIDTH-1 downto 0);
       filter_dout : out SIGNED(AXIS_DATA_WIDTH-1 downto 0);
       m_axis_tvalid : out STD_LOGIC;
       s_axis_tready : out STD_LOGIC
  );
end component;
component filters_bank
  generic(
       CHANNELS : INTEGER := 32;
       OVERSAMPLING_RATE : INTEGER := 1;
       AXIS_DATA_WIDTH : INTEGER := 32
  );
  port (
       ARESTN : in STD_LOGIC;
       CLK : in STD_LOGIC;
       DIN : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
       m_axis_tready : in STD_LOGIC;
       s_axis_tvalid : in STD_LOGIC;
       DOUT : out dout_array_t(CHANNELS-1 downto 0);
       m_axis_tvalid : out STD_LOGIC;
       s_axis_tready : out STD_LOGIC
  );
end component;
component TED
  generic(
       CHANNELS : INTEGER := 32;
       AXIS_DATA_WIDTH : INTEGER := 32;
       SAMPLES_PER_SYMBOL : INTEGER := 2;
       OVERSAMPLING_RATE : INTEGER := 32
  );
  port (
       arestn : in STD_LOGIC;
       clk : in STD_LOGIC;
       dfilter_din : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
       filter_din : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
       in_valid : in STD_LOGIC;
       f_index : out STD_LOGIC_VECTOR(integer(ceil(log2(real(CHANNELS))))-1 downto 0);
       underflow : out STD_LOGIC
  );
end component;
component d_filters_bank
  generic(
       CHANNELS : INTEGER := 32;
       OVERSAMPLING_RATE : INTEGER := 1;
       AXIS_DATA_WIDTH : INTEGER := 32
  );
  port (
       ARESTN : in STD_LOGIC;
       CLK : in STD_LOGIC;
       DIN : in SIGNED(AXIS_DATA_WIDTH-1 downto 0);
       m_axis_tready : in STD_LOGIC;
       s_axis_tvalid : in STD_LOGIC;
       DOUT : out dout_array_t(CHANNELS-1 downto 0);
       m_axis_tvalid : out STD_LOGIC;
       s_axis_tready : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal dfilters_m_valid : STD_LOGIC;
signal dfilters_s_tready : STD_LOGIC;
signal dual_MUX_s_axis_tvalid : STD_LOGIC;
signal dual_MUX_s_tready : STD_LOGIC;
signal filters_m_valid : STD_LOGIC;
signal filters_s_tready : STD_LOGIC;
signal underflow : STD_LOGIC;
signal dfilters_array : dout_array_t(CHANNELS-1 downto 0);
signal DIN_net : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
signal d_filter_net : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
signal filter_array : dout_array_t(CHANNELS-1 downto 0);
signal filter_net : SIGNED(AXIS_DATA_WIDTH-1 downto 0);
signal f_index : STD_LOGIC_VECTOR(integer(ceil(log2(real(CHANNELS))))-1 downto 0);
signal m_axis_tvalid_net : STD_LOGIC;

begin

----  Component instantiations  ----

MUX : dual_MUX
  port map(
       arestn => ARESTN,
       clk => CLK,
       dfilter_array_din => dfilters_array,
       dfilter_dout => d_filter_net(AXIS_DATA_WIDTH-1 downto 0),
       f_index => f_index(integer(ceil(log2(real(CHANNELS))))-1 downto 0),
       filter_array_din => filter_array,
       filter_dout => filter_net(AXIS_DATA_WIDTH-1 downto 0),
       m_axis_tready => m_axis_tready,
       m_axis_tvalid => m_axis_tvalid_net,
       s_axis_tready => dual_MUX_s_tready,
       s_axis_tvalid => dual_MUX_s_axis_tvalid,
       underflow => underflow
  );

U1 : TED
  port map(
       arestn => ARESTN,
       clk => CLK,
       dfilter_din => d_filter_net(AXIS_DATA_WIDTH-1 downto 0),
       f_index => f_index(integer(ceil(log2(real(CHANNELS))))-1 downto 0),
       filter_din => filter_net(AXIS_DATA_WIDTH-1 downto 0),
       in_valid => m_axis_tvalid_net,
       underflow => underflow
  );

s_axis_tready <= filters_s_tready and dfilters_s_tready;

U3 : filters_bank
  port map(
       ARESTN => ARESTN,
       CLK => CLK,
       DIN => DIN_net(AXIS_DATA_WIDTH-1 downto 0),
       DOUT => filter_array,
       m_axis_tready => dual_MUX_s_tready,
       m_axis_tvalid => filters_m_valid,
       s_axis_tready => filters_s_tready,
       s_axis_tvalid => s_axis_tvalid
  );

U4 : d_filters_bank
  port map(
       ARESTN => ARESTN,
       CLK => CLK,
       DIN => DIN_net(AXIS_DATA_WIDTH-1 downto 0),
       DOUT => dfilters_array,
       m_axis_tready => dual_MUX_s_tready,
       m_axis_tvalid => dfilters_m_valid,
       s_axis_tready => dfilters_s_tready,
       s_axis_tvalid => s_axis_tvalid
  );

dual_MUX_s_axis_tvalid <= dfilters_m_valid and filters_m_valid;
m_axis_tvalid <= m_axis_tvalid_net;

---- Terminal assignment ----

    -- Inputs terminals
	DIN_net( AXIS_DATA_WIDTH-1 downto 0 ) <= DIN;

    -- Output\buffer terminals
	DOUT <= filter_net( AXIS_DATA_WIDTH-1 downto 0 );


end polyphase_clock_sync;
