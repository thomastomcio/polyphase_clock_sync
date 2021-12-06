SetActiveLib -work
comp -include "$dsn\compile\polyphase_clock_sync_2.vhd" 
# uwaga, nalezy zaminiæ na 	"$dsn\compile\polyphase_clock_sync.vhd" 
comp -include "$dsn\src\TestBench\polyphase_clock_sync_TB.vhd" 
asim +access +r TESTBENCH_FOR_polyphase_clock_sync 
wave 
wave -noreg CLK
wave -noreg ARESTN
wave -noreg DIN
wave -noreg DOUT	
wave -noreg /polyphase_clock_sync_tb/UUT/MUX/f_index	  
run 300ns
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\polyphase_clock_sync_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_polyphase_clock_sync 
