%% Active-HDL Module Description File
function comp = fir_filter_4

comp.settings.language = 'VHDL';
comp.settings.lib = 'matched_filter';
comp.settings.entity = 'fir_filter_4';
comp.settings.arch = 'rtl';
comp.settings.ahdl_path = 'C:\Aldec\Active-HDL-10.5a\';
comp.settings.dsn_path = 'C:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\matched_filter';
comp.settings.dsn_file = 'matched_filter.adf';
comp.settings.wsp_path = 'C:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync';
comp.settings.wsp_file = 'polyphase_clock_sync.aws';


comp.port(1).type = 0;
comp.port(1).name = 'i_clk';
comp.port(1).size = 1;
comp.port(1).hdl = 'STD_LOGIC';
comp.port(2).type = 0;
comp.port(2).name = 'i_rstb';
comp.port(2).size = 1;
comp.port(2).hdl = 'STD_LOGIC';
comp.port(3).type = 0;
comp.port(3).name = 'i_coeff_0';
comp.port(3).size = 8;
comp.port(3).hdl = 'STD_LOGIC_VECTOR(7 downto 0)';
comp.port(4).type = 0;
comp.port(4).name = 'i_coeff_1';
comp.port(4).size = 8;
comp.port(4).hdl = 'STD_LOGIC_VECTOR(7 downto 0)';
comp.port(5).type = 0;
comp.port(5).name = 'i_coeff_2';
comp.port(5).size = 8;
comp.port(5).hdl = 'STD_LOGIC_VECTOR(7 downto 0)';
comp.port(6).type = 0;
comp.port(6).name = 'i_coeff_3';
comp.port(6).size = 8;
comp.port(6).hdl = 'STD_LOGIC_VECTOR(7 downto 0)';
comp.port(7).type = 0;
comp.port(7).name = 'i_data';
comp.port(7).size = 8;
comp.port(7).hdl = 'STD_LOGIC_VECTOR(7 downto 0)';
comp.port(8).type = 1;
comp.port(8).name = 'o_data';
comp.port(8).size = 10;
comp.port(8).hdl = 'STD_LOGIC_VECTOR(9 downto 0)';

comp.include(1).value = 'library ieee;';
comp.include(2).value = 'use ieee.NUMERIC_STD.all;';
comp.include(3).value = 'use ieee.std_logic_1164.all;';

comp.src(1).file = 'C:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\matched_filter\src\matched_filter.vhd';


