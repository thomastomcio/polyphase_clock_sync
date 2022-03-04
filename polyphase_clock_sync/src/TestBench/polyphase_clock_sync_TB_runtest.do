close -all -wave 
SetActiveLib polyphase_clock_sync

# uwaga, nalezy zaminiæ na 	"$dsn\compile\polyphase_clock_sync.vhd" 
comp -include "$dsn\compile\polyphase_clock_sync.vhd" 
comp -include "$dsn\src\TestBench\polyphase_clock_sync_TB.vhd" 

asim +access +r TESTBENCH_FOR_polyphase_clock_sync 

wave 
wave -noreg ARESTN
wave -noreg CLK
wave -noreg m_axis_tready
wave -noreg -notation 2complement -decimal -analog -height 100  DIN
wave -noreg s_axis_tvalid
wave -noreg -notation 2complement -decimal -analog -height 100  DOUT
wave -noreg m_axis_tvalid
wave -noreg s_axis_tready								
wave -noreg /polyphase_clock_sync_tb/UUT/MUX/m_axis_tvalid
wave -noreg -notation unsigned -analog -decimal -height 100 /polyphase_clock_sync_tb/UUT/MUX/f_index	  


wave -noreg /polyphase_clock_sync_tb/UUT/MUX/state
wave -noreg /polyphase_clock_sync_tb/UUT/underflow
wave -noreg /polyphase_clock_sync_tb/UUT/MUX/filter_array_din	 
wave -noreg /polyphase_clock_sync_tb/UUT/MUX/s_axis_tvalid
wave -noreg	/polyphase_clock_sync_tb/UUT/MUX/filter_dout 
wave -noreg /polyphase_clock_sync_tb/UUT/MUX/m_axis_tvalid
wave -noreg CLK
run 300ns	  											 

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\polyphase_clock_sync_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_polyphase_clock_sync 
