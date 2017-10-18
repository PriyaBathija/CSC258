vlib work
vlog -timescale 1ns/1ns counter.v
vsim main
log {/*}
add wave {/*}
force {KEY[0]} 0 0, 1 5, 0 10, 1 15, 0 20, 1 25, 0 30, 1 35, 0 40, 1 45, 0 50, 1 55, 0 60, 1 65, 0 70, 1 75, 0 80, 1 85, 0 90, 1 95, 0 100 -r 100
force {SW[0]} 1 0, 0 5, 1 10
force {SW[1]} 1
run 100ns