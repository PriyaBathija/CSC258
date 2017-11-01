vlib work
vlog -timescale 1ns/1ns poly_function.v
vsim fpga_top
log {/*}
add wave {/*}
force {KEY[1]} 1 0, 0 10 -repeat 20
force {KEY[0]} 0 0, 1 1
force {SW[7:0]} 00000000 0, 00000010 5, 00000011 25, 00000100 45, 00000101 65
force {CLOCK_50} 1 0, 0 1 -repeat 2
run 100ns