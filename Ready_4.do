#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\220model.v}
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\altera_mf.v}

vlog -work work Ready_4.v
vlog -work work Ready_4_tb.v

vsim -t ps work.Ready_4_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -unsigned /Ready_4_tb/W_Addr
add wave -unsigned /Ready_4_tb/R_Addr

add wave -binary /Ready_4_tb/Round

add wave -binary /Ready_4_tb/Ready

run 65ps
wave zoomrange 0ps 100ps
