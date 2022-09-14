`timescale 1ps/1ps
module PE_Controller_tb
    #(	parameter W_PEGroupSize = 4,
        parameter O_PEGroupSize = 4,
        parameter I_PEGroupSize = W_PEGroupSize + O_PEGroupSize - 1,
        parameter W_PEAddrWidth = 2,
        parameter O_PEAddrWidth = 2,
        parameter I_PEAddrWidth = 3,
        parameter I_BlockCount = 4,
        parameter I_BlockCountWidth = 2)();

	reg clk, aclr, sclr;
	reg EN_W, EN_I, EN_O_In, EN_O_Out;
	wire [W_PEAddrWidth - 1 : 0] W_PEAddr;
	wire [I_PEAddrWidth - 1 : 0] I_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_In_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_Out_PEAddr;

    PE_Controller #(.W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), .I_PEGroupSize(I_PEGroupSize), 
    .W_PEAddrWidth(W_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth), 
    .I_BlockCount(I_BlockCount), .I_BlockCountWidth(I_BlockCountWidth))
    dut (.clk(clk), .aclr(aclr), .sclr(sclr), .EN_W(EN_W), .EN_I(EN_I), .EN_O_In(EN_O_In), .EN_O_Out(EN_O_Out),
		.W_PEAddr(W_PEAddr), .I_PEAddr(I_PEAddr), .O_In_PEAddr(O_In_PEAddr), .O_Out_PEAddr(O_Out_PEAddr));

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
        EN_O_Out = 0;
    end
    always #1 clk = ~clk;

endmodule
