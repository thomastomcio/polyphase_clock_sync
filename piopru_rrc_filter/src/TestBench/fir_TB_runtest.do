SetActiveLib -work
comp -include "$dsn\src\piopru_fir_filter.vhd" 
comp -include "$dsn\src\TestBench\fir_TB.vhd" 
asim +access +r TESTBENCH_FOR_fir 
wave 
wave -noreg aclk
wave -noreg aresetn
wave -noreg aclken
wave -noreg s_axis_data_tdata
wave -noreg s_axis_data_tready
wave -noreg s_axis_data_tvalid
wave -noreg m_axis_data_tdata
wave -noreg m_axis_data_tvalid
wave -noreg m_axis_data_tready
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fir_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_fir 
