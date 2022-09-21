//used to controller edge dataflow
module PE_Controller
	#(	parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = W_PEGroupSize + O_PEGroupSize - 1,
		parameter W_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter BlockCount = 4,
		parameter BlockCountWidth = 3)
		(clk, aclr, sclr, EN_W, EN_I, EN_O_In, EN_O_Out,
		W_PEAddr, I_PEAddr, O_In_PEAddr, O_Out_PEAddr,
		I_BLOCK_EQUAL_TO_ZERO, I_BLOCK_EQUAL_TO_BLOCK_COUNT,
		O_IN_BLOCK_EQUAL_TO_ZERO, O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT, O_IN_BLOCK_MORE_THAN_BLOCK_COUNT,
		O_OUT_BLOCK_EQUAL_TO_ZERO, O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT,
		I_Block_Counter, O_In_Block_Counter, O_Out_Block_Counter);

	input clk, aclr, sclr;
	input EN_W, EN_I, EN_O_In, EN_O_Out;
	output [W_PEAddrWidth - 1 : 0] W_PEAddr;
	output [I_PEAddrWidth - 1 : 0] I_PEAddr;
	output [O_PEAddrWidth - 1 : 0] O_In_PEAddr;
	output [O_PEAddrWidth - 1 : 0] O_Out_PEAddr;

	output reg [BlockCountWidth - 1: 0] I_Block_Counter;
	output reg [BlockCountWidth - 1: 0] O_In_Block_Counter;
	output reg [BlockCountWidth - 1: 0] O_Out_Block_Counter;

	wire [I_PEAddrWidth - 1 : 0] I_PEAddr_Tmp;

  	Pointer #(.BufferWidth(W_PEAddrWidth)) WeightAddrUnit
	(.clk(clk), .aclr(aclr), .sclr(sclr || (EN_W && W_PEAddr == W_PEGroupSize - 1)), .EN(EN_W), .Pointer(W_PEAddr));

	Pointer #(.BufferWidth(I_PEAddrWidth)) InputAddrUnit
	(.clk(clk), .aclr(aclr), .sclr(sclr || (EN_I && I_PEAddr == I_PEGroupSize - 1)), .EN(EN_I), .Pointer(I_PEAddr_Tmp));

	Pointer #(.BufferWidth(O_PEAddrWidth)) OutputInAddrUnit
	(.clk(clk), .aclr(aclr), .sclr(sclr || (EN_O_In && O_In_PEAddr == O_PEGroupSize - 1)), .EN(EN_O_In), .Pointer(O_In_PEAddr));
	
	Pointer #(.BufferWidth(O_PEAddrWidth)) OutputOutAddrUnit
	(.clk(clk), .aclr(aclr), .sclr(sclr || (EN_O_Out && O_Out_PEAddr == O_PEGroupSize - 1)), .EN(EN_O_Out), .Pointer(O_Out_PEAddr));


	//status signals
	output I_BLOCK_EQUAL_TO_ZERO, I_BLOCK_EQUAL_TO_BLOCK_COUNT;
	assign I_BLOCK_EQUAL_TO_ZERO = (I_Block_Counter == 0);
	assign I_BLOCK_EQUAL_TO_BLOCK_COUNT = (I_Block_Counter == BlockCount - 1);
	wire I_PEADDR_EQUAL_TO_I_GROUP_SIZE = (I_PEAddr == I_PEGroupSize - 1);

	output O_IN_BLOCK_EQUAL_TO_ZERO, O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT, O_IN_BLOCK_MORE_THAN_BLOCK_COUNT;
	assign O_IN_BLOCK_EQUAL_TO_ZERO = (O_In_Block_Counter == 0);
	assign O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT = (O_In_Block_Counter == BlockCount - 1);
	assign O_IN_BLOCK_MORE_THAN_BLOCK_COUNT = (O_In_Block_Counter == BlockCount);
	wire O_IN_PEADDR_EQUAL_TO_O_GROUP_SIZE = (O_In_PEAddr == O_PEGroupSize - 1);

	output O_OUT_BLOCK_EQUAL_TO_ZERO, O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT;
	assign O_OUT_BLOCK_EQUAL_TO_ZERO = (O_Out_Block_Counter == 0);
	assign O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT = (O_Out_Block_Counter == BlockCount - 1);
	wire O_OUT_PEADDR_EQUAL_TO_O_GROUP_SIZE = (O_Out_PEAddr == O_PEGroupSize - 1);
	//end of status signals

	assign I_PEAddr = I_BLOCK_EQUAL_TO_ZERO ? I_PEAddr_Tmp : I_PEAddr_Tmp + (O_PEGroupSize - 1);
	
	always@(posedge clk, posedge aclr) begin
		if(aclr) begin
			I_Block_Counter = 0;
		end
		else if (sclr) begin
			I_Block_Counter <= 0;
		end
		else if (EN_I && I_PEADDR_EQUAL_TO_I_GROUP_SIZE && I_BLOCK_EQUAL_TO_BLOCK_COUNT) begin
			I_Block_Counter <= 0;
		end
		else if (EN_I && I_PEADDR_EQUAL_TO_I_GROUP_SIZE) begin
			I_Block_Counter <= I_Block_Counter + 1;
		end
		else begin
			I_Block_Counter <= I_Block_Counter;
		end
	end

	always@(posedge clk, posedge aclr) begin
		if(aclr) begin
			O_In_Block_Counter = 0;
		end
		else if (sclr) begin
			O_In_Block_Counter <= 0;
		end
		else if (EN_I && O_IN_PEADDR_EQUAL_TO_O_GROUP_SIZE && O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT) begin
			O_In_Block_Counter <= 0;
		end
		else if (EN_I && O_IN_PEADDR_EQUAL_TO_O_GROUP_SIZE) begin
			O_In_Block_Counter <= O_In_Block_Counter + 1;
		end
		else begin
			O_In_Block_Counter <= O_In_Block_Counter;
		end
	end

	always@(posedge clk, posedge aclr) begin
		if(aclr) begin
			O_Out_Block_Counter = 0;
		end
		else if (sclr) begin
			O_Out_Block_Counter <= 0;
		end
		else if (EN_I && O_OUT_PEADDR_EQUAL_TO_O_GROUP_SIZE && O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT) begin
			O_Out_Block_Counter <= 0;
		end
		else if (EN_I && O_OUT_PEADDR_EQUAL_TO_O_GROUP_SIZE) begin
			O_Out_Block_Counter <= O_Out_Block_Counter + 1;
		end
		else begin
			O_Out_Block_Counter <= O_Out_Block_Counter;
		end
	end
	
endmodule
