#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\220model.v}
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\altera_mf.v}

vlog -work work Round.v
vlog -work work Round_tb.v

vsim -t ps work.Round_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /Round_tb/clk
add wave -binary /Round_tb/aclr
add wave -binary /Round_tb/Push
add wave -binary /Round_tb/Pop
add wave -decimal /Round_tb/W_Addr
add wave -decimal /Round_tb/R_Addr

add wave -binary /Round_tb/Round

run 1000ns
wave zoomrange 0ns 1000ns
