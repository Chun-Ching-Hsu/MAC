#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\220model.v}
#vlog -work work {C:\intelFPGA_lite\18.0\quartus\eda\sim_lib\altera_mf.v}

vlog -work work Buffer.v
vlog -work work Pointer.v
vlog -work work Ready_16.v
vlog -work work Round.v
vlog -work work FIFO_Buffer.v
vlog -work work FIFO_Buffer_tb.v

vsim -t ps work.FIFO_Buffer_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /FIFO_Buffer_tb/clk
add wave -binary /FIFO_Buffer_tb/aclr
add wave -binary /FIFO_Buffer_tb/Pop1
add wave -binary /FIFO_Buffer_tb/Pop2
add wave -binary /FIFO_Buffer_tb/Push
add wave -unsigned /FIFO_Buffer_tb/DataIn

add wave -binary /FIFO_Buffer_tb/Empty
add wave -binary /FIFO_Buffer_tb/Full
add wave -binary /FIFO_Buffer_tb/ReadyM
add wave -unsigned /FIFO_Buffer_tb/DataOut1
add wave -unsigned /FIFO_Buffer_tb/DataOut2

run 60ps
wave zoomrange 0ps 65ps
