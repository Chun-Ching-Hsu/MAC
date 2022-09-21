`timescale 1ps/1ps
module PE_Controller_tb
    #(	parameter W_PEGroupSize = 4,
        parameter O_PEGroupSize = 4,
        parameter I_PEGroupSize = W_PEGroupSize + O_PEGroupSize - 1,
        parameter W_PEAddrWidth = 2,
        parameter O_PEAddrWidth = 2,
        parameter I_PEAddrWidth = 3,
        parameter BlockCount = 4,
        parameter BlockCountWidth = 2)();

	reg clk, aclr, sclr;
	reg EN_W, EN_I, EN_O_In, EN_O_Out;
	wire [W_PEAddrWidth - 1 : 0] W_PEAddr;
	wire [I_PEAddrWidth - 1 : 0] I_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_In_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_Out_PEAddr;
    
    wire I_BLOCK_EQUAL_TO_ZERO, I_BLOCK_EQUAL_TO_BLOCK_COUNT;
    wire O_IN_BLOCK_EQUAL_TO_ZERO, O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT;
    wire O_OUT_BLOCK_EQUAL_TO_ZERO, O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT;
    wire [BlockCountWidth - 1 : 0] I_Block_Counter, O_In_Block_Counter, O_Out_Block_Counter;

    PE_Controller #(.W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), .I_PEGroupSize(I_PEGroupSize), 
    .W_PEAddrWidth(W_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth), 
    .BlockCount(BlockCount), .BlockCountWidth(BlockCountWidth))
    dut (.clk(clk), .aclr(aclr), .sclr(sclr), .EN_W(EN_W), .EN_I(EN_I), .EN_O_In(EN_O_In), .EN_O_Out(EN_O_Out),
		.W_PEAddr(W_PEAddr), .I_PEAddr(I_PEAddr), .O_In_PEAddr(O_In_PEAddr), .O_Out_PEAddr(O_Out_PEAddr),
        .I_BLOCK_EQUAL_TO_ZERO(I_BLOCK_EQUAL_TO_ZERO), .I_BLOCK_EQUAL_TO_BLOCK_COUNT(I_BLOCK_EQUAL_TO_BLOCK_COUNT),
		.O_IN_BLOCK_EQUAL_TO_ZERO(O_IN_BLOCK_EQUAL_TO_ZERO), .O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT(O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT),
		.O_Out_BLOCK_EQUAL_TO_ZERO(O_Out_BLOCK_EQUAL_TO_ZERO), .O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT(O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT),
		.I_Block_Counter(I_Block_Counter), .O_In_Block_Counter(O_In_Block_Counter), .O_Out_Block_Counter(O_Out_Block_Counter));

    initial begin
        clk = 1;
        aclr = 1;
        EN_W = 0;
        EN_I = 0;
        EN_O_In = 0;
        EN_O_Out = 0;
        #1
        aclr = 0;
        EN_W = 1;
        EN_I = 1;
        EN_O_In = 1;
        EN_O_Out = 1;
    end
    always #1 clk = ~clk;

endmodule
