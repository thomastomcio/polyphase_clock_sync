SetActiveLib -post-synthesis
comp -include "$dsn\synthesis\polyphase_clock_sync.vhd" 
comp -include "$dsn\src\TestBench\polyphase_clock_sync_TB_synth.vhd" 
asim +access +r TESTBENCH_FOR_polyphase_clock_sync 
wave 
wave -noreg ARESTN
wave -noreg CLK
wave -noreg m_axis_tready
wave -noreg s_axis_tvalid
wave -noreg DIN
wave -noreg m_axis_tvalid
wave -noreg s_axis_tready
wave -noreg DOUT
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\polyphase_clock_sync_TB_synth_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_polyphase_clock_sync 
