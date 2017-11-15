vlib work
vlog -timescale 1ns/1ns part2.v
vsim control
log {/*}
add wave {/*}

force {clock} 0 0ns, 1 1ns -repeat 2ns
force {resetn} 1 0ns, 0 1ns, 1 2ns
force {load} 0 0ns, 1 10ns, 0 20ns
force {start} 0 0ns, 1 30ns
run 80ns
