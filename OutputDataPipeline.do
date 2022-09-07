#set AlteraLib {c:/altera/81/modelsim_ae/altera/verilog/220model}
#set AlteraLib1 {c:/altera/81/modelsim_ae/altera/verilog/altera_mf}
vlib work
vmap work work

#compilation for library file required by ecc_decoder and true_dp_ram
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\220model.v}
vlog -work work {E:\intelFPGA_lite\18.1\quartus\eda\sim_lib\altera_mf.v}

vlog -work work OutputDataPipeline.v
vlog -work work OutputDataPipeline_tb.v

vsim -t ps work.OutputDataPipeline_tb
#vsim -L $AlteraLib -L $AlteraLib1 -t ps work.top_dpram_vlg_vec_tst

view wave

add wave -binary /OutputDataPipeline_tb/clk
add wave -binary /OutputDataPipeline_tb/aclr

add wave -hexadecimal /OutputDataPipeline_tb/DataIn
add wave -hexadecimal /OutputDataPipeline_tb/DataOut

run 40ps
wave zoomrange 0ps 65ps
