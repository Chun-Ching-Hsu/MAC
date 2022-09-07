#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\220model.v}
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\altera_mf.v}

vlog -work work FP_ADD.v
vlog -work work FP_ADD_tb.v

vsim -t ps work.FP_ADD_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /FP_ADD_tb/aclr
add wave -binary /FP_ADD_tb/clock
add wave -hexadecimal /FP_ADD_tb/dataa
add wave -hexadecimal /FP_ADD_tb/datab
add wave -hexadecimal /FP_ADD_tb/result

run 40ps
wave zoomrange 0ps 65ps
