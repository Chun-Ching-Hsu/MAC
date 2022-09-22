#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\220model.v}
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\altera_mf.v}

vlog -work work Buffer.v
vlog -work work Pointer.v
vlog -work work Ready.v
vlog -work work Round.v
vlog -work work FIFO_Buffer_ACC.v
vlog -work work FIFO_Buffer_ACC_tb.v

vsim -t ps work.FIFO_Buffer_ACC_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /FIFO_Buffer_ACC_tb/clk
add wave -binary /FIFO_Buffer_ACC_tb/aclr
add wave -binary /FIFO_Buffer_ACC_tb/Pop
add wave -binary /FIFO_Buffer_ACC_tb/Push
add wave -unsigned /FIFO_Buffer_ACC_tb/DataIn

add wave -binary /FIFO_Buffer_ACC_tb/Empty
add wave -binary /FIFO_Buffer_ACC_tb/Full
add wave -unsigned /FIFO_Buffer_ACC_tb/DataOut

run 40ps
wave zoomrange 0ps 65ps
