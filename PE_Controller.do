#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\220model.v}
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\altera_mf.v}


vlog -work work Pointer.v
vlog -work work PE_Controller.v
vlog -work work PE_Controller_tb.v

vsim -t ps work.PE_Controller_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /PE_Controller_tb/clk
add wave -binary /PE_Controller_tb/aclr

add wave -binary /PE_Controller_tb/EN_W
add wave -binary /PE_Controller_tb/EN_I
add wave -binary /PE_Controller_tb/EN_O_In
add wave -binary /PE_Controller_tb/EN_O_Out

add wave -unsigned /PE_Controller_tb/W_PEAddr
add wave -unsigned /PE_Controller_tb/I_PEAddr
add wave -unsigned /PE_Controller_tb/O_In_PEAddr
add wave -unsigned /PE_Controller_tb/O_Out_PEAddr

add wave -unsigned /PE_Controller_tb/I_Block_Counter
add wave -unsigned /PE_Controller_tb/O_In_Block_Counter
add wave -unsigned /PE_Controller_tb/O_Out_Block_Counter

add wave -binary /PE_Controller_tb/I_BLOCK_EQUAL_TO_ZERO
add wave -binary /PE_Controller_tb/I_BLOCK_EQUAL_TO_BLOCK_COUNT
add wave -binary /PE_Controller_tb/O_IN_BLOCK_EQUAL_TO_ZERO
add wave -binary /PE_Controller_tb/O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT

add wave -binary /PE_Controller_tb/O_OUT_BLOCK_EQUAL_TO_ZERO
add wave -binary /PE_Controller_tb/O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT


run 40ps
wave zoomrange 0ps 65ps
