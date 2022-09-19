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
		parameter I_BlockCount = 4,
		parameter I_BlockCountWidth = 2)();
    
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
	wire [DataWidth - 1: 0] Test_I_Data00, Test_I_Data10, Test_I_Data20, Test_I_Data30, Test_I_Data31, Test_I_Data32, Test_I_Data33;
	wire Test_W_InRdy0, Test_W_InRdy1, Test_W_InRdy2, Test_W_InRdy3;
	wire [I_PEAddrWidth - 1 : 0] Test_I_PEAddr;

    PE_Group #( .DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize),
                .W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), .I_PEGroupSize(I_PEGroupSize),
				.W_PEAddrWidth(W_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth),
				.I_BlockCount(I_BlockCount), .I_BlockCountWidth(I_BlockCountWidth))
    dut
	(   .clk(clk), .aclr(aclr),
		.W_DataInValid(W_DataInValid), .W_DataInRdy(W_DataInRdy), .W_DataIn(W_DataIn),
		.I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(I_DataIn),
		.O_DataInValid(O_DataInValid), .O_DataInRdy(O_DataInRdy), .O_DataIn(O_DataIn),
		.O_DataOutValid(O_DataOutValid), .O_DataOutRdy(O_DataOutRdy), .O_DataOut(O_DataOut),
		.Test_I_Data00(Test_I_Data00), .Test_I_Data10(Test_I_Data10), .Test_I_Data20(Test_I_Data20), 
		.Test_I_Data30(Test_I_Data30), .Test_I_Data31(Test_I_Data31), .Test_I_Data32(Test_I_Data32), .Test_I_Data33(Test_I_Data33),
		.Test_I_PEAddr(Test_I_PEAddr));

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

		W_DataInValid = 0;
		I_DataInValid = 1;
		O_DataInValid = 0;
		O_DataOutRdy = 0;
		W_DataIn = 32'h40a0_0000; //5
		//I_DataIn = 32'h41a0_0000; //20
		I_DataIn = 1;
		O_DataIn = 32'h42c8_0000; //100


    end

    always #1 clk = ~clk;

	always #1 I_DataIn = I_DataIn + 1;
		
	
endmodule
