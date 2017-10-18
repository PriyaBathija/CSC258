vlib work
vlog -timescale 1ns/1ns counter.v
vsim ratecounter
log {/*}
add wave {/*}
force {SW[1]} 0
force {SW[0]} 0
force {SW[2]} 1 0, 0 2, 1 3
force {SW[3]} 1
force {CLOCK_50} 0 0, 1 1 -repeat 2
run 400ns