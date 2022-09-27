#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\220model.v}
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\altera_mf.v}

vlog -work work FP_ADD.v
vlog -work work ValidPipeline.v
vlog -work work NOPPipeline.v
vlog -work work Pointer.v
vlog -work work FIFO_Buffer_ACC.v

vlog -work work ACC.v
vlog -work work ACC_tb.v

vsim -t ps work.ACC_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /ACC_tb/clk
add wave -binary /ACC_tb/aclr

add wave -binary /ACC_tb/DataOutRdy
add wave -binary /ACC_tb/DataInValid
add wave -binary /ACC_tb/DataInRdy

add wave -binary /ACC_tb/DataOutValid

add wave -binary /ACC_tb/Test_NOP
add wave -binary /ACC_tb/Test_Accumulate

add wave -hexadecimal /ACC_tb/DataIn

add wave -hexadecimal /ACC_tb/DataOut
add wave -hexadecimal /ACC_tb/Test_ReadyDataFromBuffer
add wave -hexadecimal /ACC_tb/Test_ReadyDataFromAccumulatedData
add wave -binary /ACC_tb/Test_Ready_Empty
add wave -binary /ACC_tb/Test_Add_Busy
add wave -binary /ACC_tb/Test_Rec_Handshaking

run 200ps
wave zoomrange 0ps 250ps
