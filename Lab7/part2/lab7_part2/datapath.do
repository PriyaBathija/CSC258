 
vlib work
vlog -timescale 1ns/1ns part2.v
vsim datapath
log {/*}
add wave {/*}

force {clock} 0 0ns, 1 1ns -repeat 2ns
force {resetn} 1 0ns, 0 1ns, 1 2ns
force {color[2:0]} 111 0ns
force {x_pos[7:0]} 00000000 0ns
force {y_pos[6:0]} 0000000 0ns
force {ld_x} 0 0ns, 1 10ns, 0 20ns
force {ld_y} 0 0ns, 1 20ns, 0 30ns
force {control_dye} 0 0ns, 1 30ns
run 80ns
