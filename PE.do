#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\220model.v}
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\altera_mf.v}


vlog -work work Buffer.v
vlog -work work Pointer.v
vlog -work work Round.v
vlog -work work Ready_16.v

vlog -work work FIFO_Buffer.v
vlog -work work FIFO_Buffer2.v
vlog -work work MAC_Pipeline.v

vlog -work work FP_MUL.v
vlog -work work FP_ADD.v
vlog -work work NOPPipeline.v
vlog -work work OutputDataPipeline.v

vlog -work work PE.v
vlog -work work PE_tb.v

vsim -t ps work.PE_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /PE_tb/clk
add wave -binary /PE_tb/aclr

add wave -binary /PE_tb/W_DataInValid
add wave -binary /PE_tb/W_DataInRdy
add wave -binary /PE_tb/W_DataOutValid
add wave -binary /PE_tb/W_DataOutRdy

add wave -binary /PE_tb/I_DataInValid
add wave -binary /PE_tb/I_DataInRdy
add wave -binary /PE_tb/I_DataOutValid
add wave -binary /PE_tb/I_DataOutRdy

add wave -binary /PE_tb/O_DataInValid
add wave -binary /PE_tb/O_DataInRdy
add wave -binary /PE_tb/O_DataOutValid
add wave -binary /PE_tb/O_DataOutRdy

add wave -hexadecimal /PE_tb/W_DataIn
add wave -hexadecimal /PE_tb/I_DataIn
add wave -hexadecimal /PE_tb/O_DataIn

add wave -hexadecimal /PE_tb/W_DataOut
add wave -hexadecimal /PE_tb/I_DataOut
add wave -hexadecimal /PE_tb/O_DataOut


run 100ps
wave zoomrange 0ps 150ps
