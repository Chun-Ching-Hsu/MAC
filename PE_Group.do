#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\220model.v}
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\altera_mf.v}


vlog -work work FIFO_Buffer.v
vlog -work work FIFO_Buffer2.v
vlog -work work MAC_Pipeline.v
vlog -work work Pointer.v

vlog -work work FP_MUL.v
vlog -work work FP_ADD.v
vlog -work work NOPPipeline.v
vlog -work work OutputDataPipeline.v
vlog -work work Buffer.v
vlog -work work ValidPipeline.v

vlog -work work PE.v
vlog -work work PE_Controller.v
vlog -work work ACC.v
vlog -work work PE_Group.v
vlog -work work PE_Group_tb.v

vsim -t ps work.PE_Group_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /PE_Group_tb/clk
add wave -binary /PE_Group_tb/aclr

add wave -binary /PE_Group_tb/W_DataInValid
add wave -binary /PE_Group_tb/W_DataInRdy

add wave -binary /PE_Group_tb/I_DataInValid
add wave -binary /PE_Group_tb/I_DataInRdy

add wave -binary /PE_Group_tb/O_DataInValid
add wave -binary /PE_Group_tb/O_DataInRdy
add wave -binary /PE_Group_tb/O_DataOutValid
add wave -binary /PE_Group_tb/O_DataOutRdy

add wave -hexadecimal /PE_Group_tb/W_DataIn
add wave -hexadecimal /PE_Group_tb/I_DataIn
add wave -hexadecimal /PE_Group_tb/O_DataIn

add wave -hexadecimal /PE_Group_tb/O_DataOut

#test

add wave -hexadecimal /PE_Group_tb/Test_O_Data00
add wave -hexadecimal /PE_Group_tb/Test_O_Data01
add wave -hexadecimal /PE_Group_tb/Test_O_Data02
add wave -hexadecimal /PE_Group_tb/Test_O_Data03

add wave -unsigned /PE_Group_tb/Test_O_In_PEAddr
add wave -unsigned /PE_Group_tb/Test_O_Out_PEAddr
add wave -unsigned /PE_Group_tb/Test_I_PEAddr

add wave -binary /PE_Group_tb/Test_InValid00
add wave -binary /PE_Group_tb/Test_InValid01
add wave -binary /PE_Group_tb/Test_InValid02
add wave -binary /PE_Group_tb/Test_InValid03

add wave -binary /PE_Group_tb/Test_InValid10
add wave -binary /PE_Group_tb/Test_InValid11
add wave -binary /PE_Group_tb/Test_InValid12
add wave -binary /PE_Group_tb/Test_InValid13

add wave -binary /PE_Group_tb/Test_OutValid00
add wave -binary /PE_Group_tb/Test_OutValid01
add wave -binary /PE_Group_tb/Test_OutValid02
add wave -binary /PE_Group_tb/Test_OutValid03

add wave -binary /PE_Group_tb/Test_OutValid10
add wave -binary /PE_Group_tb/Test_OutValid11
add wave -binary /PE_Group_tb/Test_OutValid12
add wave -binary /PE_Group_tb/Test_OutValid13

add wave -hexadecimal /PE_Group_tb/Test_ACC_DataOut
add wave -binary /PE_Group_tb/Test_Accumulate
add wave -binary /PE_Group_tb/Acc

add wave -unsigned /PE_Group_tb/Test_O_In_Block_Counter
add wave -unsigned /PE_Group_tb/Test_I_Block_Counter

run 900ps
wave zoomrange 0ps 1000ps
