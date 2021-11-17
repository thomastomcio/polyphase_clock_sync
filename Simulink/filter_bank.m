%% Active-HDL Module Description File
function comp = filter_bank

comp.settings.language = 'VHDL';
comp.settings.lib = 'filter_bank';
comp.settings.entity = 'filter_bank';
comp.settings.arch = 'filter_bank_arch';
comp.settings.ahdl_path = 'C:\Aldec\Active-HDL-10.5a\';
comp.settings.dsn_path = 'c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\filter_bank';
comp.settings.dsn_file = 'filter_bank.adf';
comp.settings.wsp_path = 'c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync';
comp.settings.wsp_file = 'polyphase_clock_sync.aws';

comp.param(1).name = 'CHANNELS';
comp.param(1).type = 'INTEGER';
comp.param(1).value = '2';
comp.param(2).name = 'OVERSAMPLING_RATE';
comp.param(2).type = 'INTEGER';
comp.param(2).value = '1';
comp.param(3).name = 'AXIS_IQ_TDATA_WIDTH';
comp.param(3).type = 'INTEGER';
comp.param(3).value = '32';

comp.port(1).type = 0;
comp.port(1).name = 'CLK';
comp.port(1).size = 1;
comp.port(1).hdl = 'STD_LOGIC';
comp.port(2).type = 0;
comp.port(2).name = 'ARESTN';
comp.port(2).size = 1;
comp.port(2).hdl = 'STD_LOGIC';
comp.port(3).type = 0;
comp.port(3).name = 'DIN';
comp.port(3).size = -1;
comp.port(3).hdl = 'STD_LOGIC_VECTOR(AXIS_IQ_TDATA_WIDTH-1 downto 0)';
comp.port(4).type = 1;
comp.port(4).name = 'DOUT';
comp.port(4).size = -1;
comp.port(4).hdl = 'dout_array_t(CHANNELS-1 downto 0)';

comp.include(1).value = 'library filter_bank;';
comp.include(2).value = 'use filter_bank.array_type_pkg.all;';

comp.src(1).file = 'c:\My_Designs\2_polyphase_clock_sync\polyphase_clock_sync\filter_bank\src\filter_bank.vhd';


