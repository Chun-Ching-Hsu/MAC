`timescale 1ps/1ps
module PE_Group_tb
	#(	parameter DataWidth = 32,
		parameter BufferWidth = 2,
		parameter BufferSize = 4,
		parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = 7,
		parameter W_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter BlockCount = 4,
		parameter BlockCountWidth = 3)();
    
	reg clk, aclr;
	reg W_DataInValid;
	reg I_DataInValid;
	reg O_DataInValid, O_DataOutRdy;
	reg [DataWidth - 1 : 0] W_DataIn;
	reg [DataWidth - 1 : 0] O_DataIn;
	reg [DataWidth - 1 : 0] I_DataIn;
	
	wire [DataWidth - 1: 0] O_DataOut;
	wire W_DataInRdy;
	wire I_DataInRdy;
	wire O_DataInRdy, O_DataOutValid;

	//test
	wire [O_PEAddrWidth - 1 : 0] Test_O_In_PEAddr, Test_O_Out_PEAddr;
	wire [I_PEAddrWidth - 1 : 0] Test_I_PEAddr;
	wire [DataWidth - 1 : 0] Test_O_Data00, Test_O_Data01, Test_O_Data02, Test_O_Data03;
	wire [3:0] Test_InValid0, Test_InValid1;
	wire [3:0] Test_OutValid0, Test_OutValid1;
	wire [DataWidth - 1: 0] Test_ACC_DataOut;
	wire [3:0] Test_Accumulate;
	wire Test_O_BLOCK_MORE_THAN_BLOCK_COUNT;
	wire [BlockCountWidth - 1 : 0] Test_O_In_Block_Counter, Test_I_Block_Counter;
	wire Acc;
	wire [3 : 0] Test_NOP;
	wire [DataWidth - 1 : 0] TestA, TestB;
	wire [BlockCountWidth - 1 : 0] Test_ACC;

    PE_Group #( .DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize),
                .W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), .I_PEGroupSize(I_PEGroupSize),
				.W_PEAddrWidth(W_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth),
				.BlockCount(BlockCount), .BlockCountWidth(BlockCountWidth))
    dut
	(   .clk(clk), .aclr(aclr),
		.W_DataInValid(W_DataInValid), .W_DataInRdy(W_DataInRdy), .W_DataIn(W_DataIn),
		.I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(I_DataIn),
		.O_DataInValid(O_DataInValid), .O_DataInRdy(O_DataInRdy), .O_DataIn(O_DataIn),
		.O_DataOutValid(O_DataOutValid), .O_DataOutRdy(O_DataOutRdy), .O_DataOut(O_DataOut),
		.Test_O_Data00(Test_O_Data00), .Test_O_Data01(Test_O_Data01), .Test_O_Data02(Test_O_Data02), .Test_O_Data03(Test_O_Data03),
		.Test_O_In_PEAddr(Test_O_In_PEAddr), .Test_O_Out_PEAddr(Test_O_Out_PEAddr), .Test_I_PEAddr(Test_I_PEAddr),
		.Test_InValid0(Test_InValid0), .Test_InValid1(Test_InValid1),
		.Test_OutValid0(Test_OutValid0), .Test_OutValid1(Test_OutValid1),
		.Test_ACC_DataOut(Test_ACC_DataOut), .Test_Accumulate(Test_Accumulate), .Acc(Acc),
		.Test_O_In_Block_Counter(Test_O_In_Block_Counter), .Test_I_Block_Counter(Test_I_Block_Counter),
		.Test_NOP(Test_NOP), .TestA(TestA), .TestB(TestB), .Test_ACC(Test_ACC));

    initial begin
        clk = 1;
        aclr = 1;
		W_DataInValid = 0;
		I_DataInValid = 0;
		O_DataInValid = 0;
		O_DataOutRdy = 0;
		W_DataIn = 32'h40a0_0000;
		I_DataIn = 32'h0000_0000;
		O_DataIn = 32'h0000_0000;
        #1
        aclr = 0;

		W_DataInValid = 1;
		I_DataInValid = 1;
		O_DataInValid = 1;
		O_DataOutRdy = 1;
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h41a0_0000; //20
		O_DataIn = 32'h3f80_0000; //10
		/*
		#8
		W_DataInValid = 1;
		I_DataInValid = 1;
		O_DataInValid = 0;
		O_DataOutRdy = 1;
		
		#24		
		W_DataInValid = 0;

		#6
		I_DataInValid = 0;
		*/
    end

    always #1 clk = ~clk;
		
	
endmodule
