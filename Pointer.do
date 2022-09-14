#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\220model.v}
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\altera_mf.v}

vlog -work work Pointer.v
vlog -work work Pointer_tb.v

vsim -t ps work.Pointer_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /Pointer_tb/clk
add wave -binary /Pointer_tb/aclr
add wave -binary /Pointer_tb/sclr
add wave -binary /Pointer_tb/EN

add wave -decimal /Pointer_tb/Pointer


run 40ps
wave zoomrange 0ps 65ps
