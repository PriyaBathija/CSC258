vlib work
vlog -timescale 1ns/1ns ram32x4.v
vsim -L altera_mf_ver ram32x4
log {/*}
add wave {/*}


force {address[4:0]} 00000 0ns, 00001 10ns, 00010 20ns, 00011 30ns -repeat 40ns
force {clock} 0 0ns, 1 5ns, 0 10ns, 1 15ns, 0 20ns, 1 25ns, 0 30ns, 1 35ns -repeat 40ns
force {data[3:0]} 0000 0ns, 0001 10ns, 0010 20ns, 0011 30ns -repeat 40ns
force {wren} 1 0ns -repeat 40ns
run 40ns
