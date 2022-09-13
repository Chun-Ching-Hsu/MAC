//used to controller edge dataflow
module PE_Controller
	#(	parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = W_PEGroupSize + O_PEGroupSize - 1,
		parameter W_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3)
		(clk, rst, EN_W, EN_I, EN_O_In, EN_O_Out,
		W_PEAddr, I_PEAddr, O_In_PEAddr, O_Out_PEAddr);

	input clk, rst;
	input EN_W, EN_I, EN_O_In, EN_O_Out;
	output [W_PEAddrWidth - 1 : 0] W_PEAddr;
	output [I_PEAddrWidth - 1 : 0] I_PEAddr;
	output [O_PEAddrWidth - 1 : 0] O_In_PEAddr;
	output [O_PEAddrWidth - 1 : 0] O_Out_PEAddr;

  	Pointer #(.BufferWidth(W_PEAddrWidth)) WeightAddrUnit
	  (.clk(clk), .rst(rst || (EN_W && W_PEAddr == W_PEGroupSize - 1)), .EN(EN_W), .Pointer(W_PEAddr));

	Pointer #(.BufferWidth(I_PEAddrWidth)) InputAddrUnit
	(.clk(clk), .rst(rst || EN_I && I_PEAddr == I_PEGroupSize - 1), .EN(EN_I), .Pointer(I_PEAddr));

	Pointer #(.BufferWidth(O_PEAddrWidth)) OutputInAddrUnit
	(.clk(clk), .rst(rst || (EN_O_In && O_In_PEAddr == O_PEGroupSize - 1)), .EN(EN_O_In), .Pointer(O_In_PEAddr));
	
	Pointer #(.BufferWidth(O_PEAddrWidth)) OutputOutAddrUnit
	(.clk(clk), .rst(rst || (EN_O_Out && O_Out_PEAddr == O_PEGroupSize - 1)), .EN(EN_O_Out), .Pointer(O_Out_PEAddr));
	
endmodule
