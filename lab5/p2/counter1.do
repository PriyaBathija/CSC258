vlib work
vlog -timescale 1ns/1ns counter.v
vsim ratecounter
log {/*}
add wave {/*}
force {inp1} 0
force {inp0} 1
force {reset_n} 1 0, 0 2,1 3
force {enable} 1
force {clock} 0 0, 1 1 -repeat 2
run 400ns