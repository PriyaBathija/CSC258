vlib work
vlog -timescale 1ns/1ns sequence_detector.v
vsim sequence_detector
log {/*}
add wave {/*}
force {KEY[0]} 1 0, 0 1, 1 10, 0 20, 1 30, 0 40, 1 50, 0 60, 1 70, 0 80, 1 90, 0 100, 1 110, 0 120, 1 130, 0 140, 1 150 -repeat 160ns
force {SW[0]} 0 0, 1 5
force {SW[1]} 1 0
run 160ns