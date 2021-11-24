%% Active-HDL Module Description File
function comp = polyphase_clock_sync

comp.settings.language = 'VHDL';
comp.settings.lib = 'polyphase_clock_sync';
comp.settings.entity = 'polyphase_clock_sync';
comp.settings.arch = 'polyphase_clock_sync';
comp.settings.ahdl_path = 'C:\Aldec\Active-HDL-12-x64\';
comp.settings.dsn_path = 'C:\Users\student_1\Desktop\Soko這wski_praca_dyplomowa\My_design\polyphase_clock_sync';
comp.settings.dsn_file = 'polyphase_clock_sync.adf';
comp.settings.wsp_path = 'C:\Users\student_1\Desktop\Soko這wski_praca_dyplomowa\My_design';
comp.settings.wsp_file = 'polyphase_clock_sync.aws';

comp.param(1).name = 'CHANNELS';
comp.param(1).type = 'INTEGER';
comp.param(1).value = '32';
comp.param(2).name = 'DATA_WIDTH';
comp.param(2).type = 'INTEGER';
comp.param(2).value = '32';
comp.param(3).name = 'FACTOR_WIDTH';
comp.param(3).type = 'INTEGER';
comp.param(3).value = '12';
comp.param(4).name = 'AXIS_DATA_WIDTH';
comp.param(4).type = 'INTEGER';
comp.param(4).value = '32';
comp.param(5).name = 'SAMPLES_PER_SYMBOL';
comp.param(5).type = 'INTEGER';
comp.param(5).value = '2';
comp.param(6).name = 'OVERSAMPLING_RATE';
comp.param(6).type = 'INTEGER';
comp.param(6).value = '32';

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
comp.port(3).hdl = 'SIGNED(AXIS_DATA_WIDTH-1 downto 0)';
comp.port(4).type = 1;
comp.port(4).name = 'DOUT';
comp.port(4).size = -1;
comp.port(4).hdl = 'SIGNED(AXIS_DATA_WIDTH-1 downto 0)';

comp.include(1).value = 'library polyphase_clock_sync;';
comp.include(2).value = 'use polyphase_clock_sync.array_type_pkg.all;';
comp.include(3).value = 'library ieee;';
comp.include(4).value = 'use ieee.MATH_REAL.all;';
comp.include(5).value = 'use ieee.NUMERIC_STD.all;';
comp.include(6).value = 'use ieee.std_logic_1164.all;';

comp.src(1).file = 'C:\Users\student_1\Desktop\Soko這wski_praca_dyplomowa\My_design\polyphase_clock_sync\src\filters_bank.vhd';
comp.src(2).file = 'C:\Users\student_1\Desktop\Soko這wski_praca_dyplomowa\My_design\polyphase_clock_sync\src\d_filters_bank.vhd';
comp.src(3).file = 'C:\Users\student_1\Desktop\Soko這wski_praca_dyplomowa\My_design\polyphase_clock_sync\src\TED.vhd';
comp.src(4).file = 'C:\Users\student_1\Desktop\Soko這wski_praca_dyplomowa\My_design\polyphase_clock_sync\src\dual_mux.vhd';
comp.src(5).file = 'C:\Users\student_1\Desktop\Soko這wski_praca_dyplomowa\My_design\polyphase_clock_sync\compile\polyphase_clock_sync.vhd';


