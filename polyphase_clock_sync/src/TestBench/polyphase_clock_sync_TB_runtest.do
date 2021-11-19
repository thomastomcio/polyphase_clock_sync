SetActiveLib -work
comp -include "$dsn\src\polyphase_clock_sync_2.vhd" 
comp -include "$dsn\src\TestBench\polyphase_clock_sync_TB.vhd" 
asim +access +r TESTBENCH_FOR_polyphase_clock_sync 
wave 
wave -noreg ARESTN
wave -noreg CLK
wave -noreg DIN
wave -noreg DOUT				 
wave -noreg /polyphase_clock_sync_tb/UUT/U1

run 10 us
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\polyphase_clock_sync_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_polyphase_clock_sync 
