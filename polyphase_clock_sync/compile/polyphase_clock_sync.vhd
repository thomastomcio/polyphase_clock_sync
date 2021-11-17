-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : polyphase_clock_sync
-- Author      : thomas
-- Company     : AGH
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\polyphase_clock_sync\compile\polyphase_clock_sync.vhd
-- Generated   : Sun Nov  7 16:57:55 2021
-- From        : c:/My_Designs/2_polyphase_clock_sync/polyphase_clock_sync/polyphase_clock_sync/src/polyphase_clock_sync.bde
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

library work;
use work.array_type_pkg.all;

-- Included from components --
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity polyphase_clock_sync is
  generic(
       CHANNELS :integer:=32;
       DATA_WIDTH:integer:=32;
       FACTOR_WIDTH:integer :=12;
       AXIS_IQ_TDATA_WIDTH:integer :=32
  );
  port(
       ARESTN : in STD_LOGIC;
       CLK : in STD_LOGIC;
       DIN : in STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
       BusOutput1 : out STD_LOGIC_VECTOR(CHANNELS-1 downto 0)
  );
end polyphase_clock_sync;

architecture polyphase_clock_sync of polyphase_clock_sync is

---- Component declarations -----

component dual_MUX
  generic(
       CHANNELS : INTEGER := 32;
       DATA_WIDTH : INTEGER := 32
  );
  port (
       arestn : in STD_LOGIC;
       clk : in STD_LOGIC;
       dfilter_din : in dout_array_t(CHANNELS-1 downto 0);
       f_index : in STD_LOGIC_VECTOR(integer(ceil(log2(real(CHANNELS))))-1 downto 0);
       filter_din : in dout_array_t(CHANNELS-1 downto 0);
       filter_dout : out STD_LOGIC_VECTOR(CHANNELS-1 downto 0);
       mult_out : out SIGNED(2*DATA_WIDTH-1 downto 0)
  );
end component;
component filter_bank
  generic(
       CHANNELS : INTEGER := 32;
       OVERSAMPLING_RATE : INTEGER := 1;
       AXIS_IQ_TDATA_WIDTH : INTEGER := 32
  );
  port (
       ARESTN : in STD_LOGIC;
       CLK : in STD_LOGIC;
       DIN : in STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0);
       DOUT : out dout_array_t(CHANNELS-1 downto 0)
  );
end component;
component index_selector
  generic(
       CHANNELS : INTEGER := 32;
       FACTOR_WIDTH : INTEGER := 12;
       DATA_WIDTH : INTEGER := 32
  );
  port (
       arestn : in STD_LOGIC;
       clk : in STD_LOGIC;
       data_in : in SIGNED(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0);
       overflow : in STD_LOGIC;
       underflow : in STD_LOGIC;
       f_index : out STD_LOGIC_VECTOR(integer(ceil(log2(real(CHANNELS))))-1 downto 0)
  );
end component;
component loop_filter
  generic(
       ALPHA : INTEGER := 0;
       BETA : INTEGER := 0;
       FACTOR_WIDTH : INTEGER := 12;
       DATA_WIDTH : INTEGER := 32
  );
  port (
       arestn : in STD_LOGIC;
       clk : in STD_LOGIC;
       error_in : in SIGNED(2*DATA_WIDTH-1 downto 0);
       data_out : out SIGNED(2*DATA_WIDTH+FACTOR_WIDTH+2-1 downto 0)
  );
end component;
component modulo_sps_counter
  generic(
       FACTOR_WIDTH : INTEGER := 12;
       DATA_WIDTH : INTEGER := 32
  );
  port (
       arestn : in STD_LOGIC;
       clk : in STD_LOGIC;
       data_in : in SIGNED(2*DATA_WIDTH+FACTOR_WIDTH+2-1 downto 0);
       data_out : out SIGNED(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0);
       overflow : out STD_LOGIC;
       underflow : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal NET1013 : STD_LOGIC;
signal NET1023 : STD_LOGIC;
signal ARAY160 : dout_array_t(CHANNELS-1 downto 0);
signal ARRAY452 : dout_array_t(CHANNELS-1 downto 0);
signal BUS5087721005 : SIGNED(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0);
signal BUS508772772 : SIGNED(2*DATA_WIDTH+FACTOR_WIDTH+2-1 downto 0);
signal error : SIGNED(2*DATA_WIDTH-1 downto 0);
signal f_index : STD_LOGIC_VECTOR(integer(ceil(log2(real(CHANNELS))))-1 downto 0);

begin

----  Component instantiations  ----

U4 : loop_filter
  port map(
       arestn => ARESTN,
       clk => CLK,
       data_out => BUS508772772(2*DATA_WIDTH+FACTOR_WIDTH+2-1 downto 0),
       error_in => error(2*DATA_WIDTH-1 downto 0)
  );

U5 : index_selector
  port map(
       arestn => ARESTN,
       clk => CLK,
       data_in => BUS5087721005(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0),
       f_index => f_index(integer(ceil(log2(real(CHANNELS))))-1 downto 0),
       overflow => NET1023,
       underflow => NET1013
  );

U6 : modulo_sps_counter
  port map(
       arestn => ARESTN,
       clk => CLK,
       data_in => BUS508772772(2*DATA_WIDTH+FACTOR_WIDTH+2-1 downto 0),
       data_out => BUS5087721005(2*DATA_WIDTH+FACTOR_WIDTH+3-1 downto 0),
       overflow => NET1023,
       underflow => NET1013
  );

dmatched_filter : filter_bank
  port map(
       ARESTN => ARESTN,
       CLK => CLK,
       DIN => DIN(AXIS_IQ_TDATA_WIDTH-1 downto 0),
       DOUT => ARRAY452
  );

matched_filter : filter_bank
  port map(
       ARESTN => ARESTN,
       CLK => CLK,
       DIN => DIN(AXIS_IQ_TDATA_WIDTH-1 downto 0),
       DOUT => ARAY160
  );

mux_and_mul : dual_MUX
  port map(
       arestn => ARESTN,
       clk => CLK,
       dfilter_din => ARRAY452,
       f_index => f_index(integer(ceil(log2(real(CHANNELS))))-1 downto 0),
       filter_din => ARAY160,
       filter_dout => BusOutput1(CHANNELS-1 downto 0),
       mult_out => error(2*DATA_WIDTH-1 downto 0)
  );


end polyphase_clock_sync;
