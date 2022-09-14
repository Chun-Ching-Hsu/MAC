#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\220model.v}
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\altera_mf.v}

vlog -work work MAC_Pipeline.v
vlog -work work MAC_Pipeline_tb.v

vsim -t ps work.MAC_Pipeline_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /MAC_Pipeline_tb/clk
add wave -binary /MAC_Pipeline_tb/aclr
add wave -binary /MAC_Pipeline_tb/NOPIn

add wave -hexadecimal /MAC_Pipeline_tb/W_Data
add wave -hexadecimal /MAC_Pipeline_tb/I_Data
add wave -hexadecimal /MAC_Pipeline_tb/O_Data

add wave -binary /MAC_Pipeline_tb/NOPOut
add wave -hexadecimal /MAC_Pipeline_tb/DataOut

run 40ps
wave zoomrange 0ps 65ps
