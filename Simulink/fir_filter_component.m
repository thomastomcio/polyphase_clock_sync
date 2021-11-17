%% Active-HDL Module Description File
function comp = fir_filter_component

comp.settings.language = 'VHDL';
comp.settings.lib = 'fir_filter';
comp.settings.entity = 'fir';
comp.settings.arch = 'fir_arch';
comp.settings.ahdl_path = 'C:\Aldec\Active-HDL-10.5a\';
comp.settings.dsn_path = 'c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\fir_filter';
comp.settings.dsn_file = 'fir_filter.adf';
comp.settings.wsp_path = 'c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync';
comp.settings.wsp_file = 'polyphase_clock_sync.aws';

comp.param(1).name = 'AXIS_IQ_TDATA_WIDTH';
comp.param(1).type = 'INTEGER';
comp.param(1).value = '32';
comp.param(2).name = 'FILTER_INDEX';
comp.param(2).type = 'INTEGER';
comp.param(2).value = '0';
comp.param(3).name = 'OVERSAMPLING_RATE';
comp.param(3).type = 'INTEGER';
comp.param(3).value = '1';
comp.param(4).name = 'number_of_filters';
comp.param(4).type = 'INTEGER';
comp.param(4).value = '32';
comp.param(5).name = 'num_of_coef';
comp.param(5).type = 'INTEGER';
comp.param(5).value = '51';
comp.param(6).name = 'coef_size';
comp.param(6).type = 'INTEGER';
comp.param(6).value = '12';

comp.port(1).type = 0;
comp.port(1).name = 'aclk';
comp.port(1).size = 1;
comp.port(1).hdl = 'STD_LOGIC';
comp.port(2).type = 0;
comp.port(2).name = 'aresetn';
comp.port(2).size = 1;
comp.port(2).hdl = 'STD_LOGIC';
comp.port(3).type = 0;
comp.port(3).name = 'aclken';
comp.port(3).size = 1;
comp.port(3).hdl = 'STD_LOGIC';
comp.port(4).type = 0;
comp.port(4).name = 's_axis_data_tdata';
comp.port(4).size = -1;
comp.port(4).hdl = 'STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0)';
comp.port(5).type = 1;
comp.port(5).name = 's_axis_data_tready';
comp.port(5).size = 1;
comp.port(5).hdl = 'STD_LOGIC';
comp.port(6).type = 0;
comp.port(6).name = 's_axis_data_tvalid';
comp.port(6).size = 1;
comp.port(6).hdl = 'STD_LOGIC';
comp.port(7).type = 1;
comp.port(7).name = 'm_axis_data_tdata';
comp.port(7).size = -1;
comp.port(7).hdl = 'STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0)';
comp.port(8).type = 1;
comp.port(8).name = 'm_axis_data_tvalid';
comp.port(8).size = 1;
comp.port(8).hdl = 'STD_LOGIC';
comp.port(9).type = 0;
comp.port(9).name = 'm_axis_data_tready';
comp.port(9).size = 1;
comp.port(9).hdl = 'STD_LOGIC';

comp.include(1).value = 'library ieee;';
comp.include(2).value = 'use ieee.NUMERIC_STD.all;';
comp.include(3).value = 'use ieee.STD_LOGIC_SIGNED.all;';
comp.include(4).value = 'use ieee.std_logic_1164.all;';

comp.src(1).file = 'c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\fir_filter\src\fir_filter.vhd';


