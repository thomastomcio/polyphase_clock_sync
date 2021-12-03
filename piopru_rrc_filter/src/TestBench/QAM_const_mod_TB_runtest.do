setactivelib -work
#Compiling UUT module design files

comp -include "$dsn\src\TestBench\QAM_const_mod_TB.vhd"
asim +access +r Top

wave
wave -noreg output_real
wave -noreg output_imag
wave -noreg inp
wave -noreg clk
wave -noreg rst

run	  1 us

#End simulation macro
