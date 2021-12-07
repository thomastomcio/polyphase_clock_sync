SetActiveLib -work
comp -include "$dsn\src\fir_filter.vhd" 
comp -include "$dsn\src\TestBench\fir_filter_TB.vhd" 
asim +access +r TESTBENCH_FOR_fir_filter 
wave 
wave -noreg aclk
wave -noreg aresetn
wave -noreg aclken
wave -noreg s_axis_data_tdata
wave -noreg s_axis_data_tvalid
wave -noreg m_axis_data_tdata
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fir_filter_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_fir_filter 
