#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\220model.v}
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\altera_mf.v}

vlog -work work Buffer.v
vlog -work work Buffer_tb.v

vsim -t ps work.Buffer_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /Buffer_tb/clk
add wave -binary /Buffer_tb/aclr
add wave -binary /Buffer_tb/EN

add wave -unsigned /Buffer_tb/W_Addr
add wave -unsigned /Buffer_tb/R_Addr1
add wave -unsigned /Buffer_tb/R_Addr2

add wave -unsigned /Buffer_tb/DataIn

add wave -unsigned /Buffer_tb/DataOut1
add wave -unsigned /Buffer_tb/DataOut2


run 40ps
wave zoomrange 0ps 65ps
