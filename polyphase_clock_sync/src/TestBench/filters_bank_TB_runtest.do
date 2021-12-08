SetActiveLib -work
comp -include "$dsn\src\filters_bank.vhd" 
comp -include "$dsn\src\TestBench\filters_bank_TB.vhd" 
asim +access +r TESTBENCH_FOR_filters_bank 
wave 
wave -noreg CLK
wave -noreg ARESTN
wave -noreg DIN
wave -noreg s_axis_tready
wave -noreg	s_axis_tvalid
wave -noreg	m_axis_tvalid
wave -noreg m_axis_tready
wave -noreg DOUT  
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\filters_bank_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_filters_bank 
