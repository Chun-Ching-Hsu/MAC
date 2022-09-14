//used to controller edge dataflow
module PE_Controller
	#(	parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = W_PEGroupSize + O_PEGroupSize - 1,
		parameter W_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter I_BlockCount = 4,
		parameter I_BlockCountWidth = 2)
		(clk, aclr, sclr, EN_W, EN_I, EN_O_In, EN_O_Out,
		W_PEAddr, I_PEAddr, O_In_PEAddr, O_Out_PEAddr);

	input clk, aclr, sclr;
	input EN_W, EN_I, EN_O_In, EN_O_Out;
	output [W_PEAddrWidth - 1 : 0] W_PEAddr;
	output [I_PEAddrWidth - 1 : 0] I_PEAddr;
	output [O_PEAddrWidth - 1 : 0] O_In_PEAddr;
	output [O_PEAddrWidth - 1 : 0] O_Out_PEAddr;

	reg [I_BlockCountWidth - 1:0] I_Block_Counter;

	wire [I_PEAddrWidth - 1 : 0] I_PEAddr_Tmp;

  	Pointer #(.BufferWidth(W_PEAddrWidth)) WeightAddrUnit
	(.clk(clk), .aclr(aclr), .sclr(sclr || (EN_W && W_PEAddr == W_PEGroupSize - 1)), .EN(EN_W), .Pointer(W_PEAddr));

	Pointer #(.BufferWidth(I_PEAddrWidth)) InputAddrUnit
	(.clk(clk), .aclr(aclr), .sclr(sclr || (EN_I && I_PEAddr == I_PEGroupSize - 1)), .EN(EN_I), .Pointer(I_PEAddr_Tmp));

	Pointer #(.BufferWidth(O_PEAddrWidth)) OutputInAddrUnit
	(.clk(clk), .aclr(aclr), .sclr(sclr || (EN_O_In && O_In_PEAddr == O_PEGroupSize - 1)), .EN(EN_O_In), .Pointer(O_In_PEAddr));
	
	Pointer #(.BufferWidth(O_PEAddrWidth)) OutputOutAddrUnit
	(.clk(clk), .aclr(aclr), .sclr(sclr || (EN_O_Out && O_Out_PEAddr == O_PEGroupSize - 1)), .EN(EN_O_Out), .Pointer(O_Out_PEAddr));

	assign I_PEAddr = (I_Block_Counter == 0) ? I_PEAddr_Tmp : I_PEAddr_Tmp + (O_PEGroupSize - 1);

	always@(posedge clk, posedge aclr) begin
		if(aclr) begin
			I_Block_Counter = 0;
		end
		else if (sclr) begin
			I_Block_Counter <= 0;
		end
		else if (EN_I && I_PEAddr == I_PEGroupSize - 1) begin
			I_Block_Counter <= I_Block_Counter + 1;
		end
		else if (EN_I && I_PEAddr == I_PEGroupSize - 1 && I_Block_Counter == I_BlockCount) begin
			I_Block_Counter <= 0;
		end
		else begin
			I_Block_Counter <= I_Block_Counter;
		end
		
	end
	
endmodule
