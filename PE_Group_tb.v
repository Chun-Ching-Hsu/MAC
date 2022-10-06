`timescale 1ps/1ps
module PE_Group_tb
	#(	parameter DataWidth = 32,
		parameter BufferWidth = 4,
		parameter BufferSize = 16,
		parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = 7,
		parameter W_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter BlockCount = 4,
		parameter BlockCountWidth = 2)();
    
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
	wire [BlockCountWidth - 1 : 0] Test_O_In_Block_Counter, Test_I_Block_Counter;
	wire [DataWidth - 1 : 0] Out0, Out1, Out2, Out3;
	wire [DataWidth - 1 : 0] W0, W1, W2, W3;
	wire [DataWidth - 1 : 0] I0, I1, I2, I3, I4, I5, I6;
	wire [3 : 0] Test_O_OutValid, Test_O_InValid, Test_W_InValid, Test_I_InValid, Test_O_InRdy, Test_W_InRdy, Test_I_InRdy;
	wire [DataWidth - 1 : 0] Test_O_DataIn00, Test_O_DataIn01, Test_O_DataIn02, Test_O_DataIn03;
	wire [DataWidth - 1 : 0] Test_W_DataIn00, Test_W_DataIn01, Test_W_DataIn02, Test_W_DataIn03;
	wire [DataWidth - 1 : 0] Test_I_DataIn00, Test_I_DataIn01, Test_I_DataIn02, Test_I_DataIn03;

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
		.Test_O_OutValid(Test_O_OutValid),
		.Test_O_DataIn00(Test_O_DataIn00), .Test_O_DataIn01(Test_O_DataIn01), .Test_O_DataIn02(Test_O_DataIn02), .Test_O_DataIn03(Test_O_DataIn03),
		.Test_W_DataIn00(Test_W_DataIn00), .Test_W_DataIn01(Test_W_DataIn01), .Test_W_DataIn02(Test_W_DataIn02), .Test_W_DataIn03(Test_W_DataIn03),
		.Test_I_DataIn00(Test_I_DataIn00), .Test_I_DataIn01(Test_I_DataIn01), .Test_I_DataIn02(Test_I_DataIn02), .Test_I_DataIn03(Test_I_DataIn03),
		.Test_O_InValid(Test_O_InValid), .Test_W_InValid(Test_W_InValid), .Test_I_InValid(Test_I_InValid),
		.Test_O_InRdy(Test_O_InRdy), .Test_W_InRdy(Test_W_InRdy), .Test_I_InRdy(Test_I_InRdy),
		.Test_O_In_PEAddr(Test_O_In_PEAddr), .Test_O_Out_PEAddr(Test_O_Out_PEAddr), .Test_I_PEAddr(Test_I_PEAddr),
		.Test_O_In_Block_Counter(Test_O_In_Block_Counter), .Test_I_Block_Counter(Test_I_Block_Counter),
		.Out0(Out0), .Out1(Out1), .Out2(Out2), .Out3(Out3),
		.W0(W0), .W1(W1), .W2(W2), .W3(W3),
		.I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6));

    initial begin
        clk = 1;
        aclr = 1;
		W_DataInValid = 0;
		I_DataInValid = 0;
		O_DataInValid = 0;
		O_DataOutRdy = 0;
		W_DataIn = 32'h0000_0000;
		I_DataIn = 32'h0000_0000;
		O_DataIn = 32'h0000_0000;
        #1
        aclr = 0;
		O_DataOutRdy = 1;
/*
		//Block 0
		W_DataInValid = 1;
		I_DataInValid = 1;
		O_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h3f80_0000; //1
		O_DataIn = 32'h4120_0000; //10
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4000_0000; //2
		O_DataIn = 32'h41a0_0000; //20

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4040_0000; //3
		O_DataIn = 32'h41f0_0000; //30

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4080_0000; //4
		O_DataIn = 32'h4220_0000; //40

		#2
		W_DataInValid = 0;
		O_DataInValid = 0;
		I_DataIn = 32'h40a0_0000; //5

		#2
		I_DataIn = 32'h40c0_0000;//6

		#2
		I_DataIn = 32'h40e0_0000;//7
		
		#2
		I_DataInValid = 0;

		//End of Block 0

		//Block 1
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4100_0000; //8
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4110_0000; //9

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4120_0000; //10

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4130_0000; //11

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 1	
*/
		
		//Tile0
		
		//Block 0
		W_DataInValid = 1;
		I_DataInValid = 1;
		O_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h3f80_0000; //1
		O_DataIn = 32'h4120_0000; //10
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4000_0000; //2
		O_DataIn = 32'h41a0_0000; //20

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4040_0000; //3
		O_DataIn = 32'h41f0_0000; //30

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4080_0000; //4
		O_DataIn = 32'h4220_0000; //40

		#2
		W_DataInValid = 0;
		O_DataInValid = 0;
		I_DataIn = 32'h40a0_0000; //5

		#2
		I_DataIn = 32'h40c0_0000;//6

		#2
		I_DataIn = 32'h40e0_0000;//7
		
		#2
		I_DataInValid = 0;

		//End of Block 0
		
		//Block 1
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4100_0000; //8
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4110_0000; //9

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4120_0000; //10

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4130_0000; //11

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 1	
		
		//Block 2
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4140_0000; //12
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4150_0000; //13

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4160_0000; //14

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4170_0000; //15

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 2

		//Block 3
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4180_0000; //16
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4188_0000; //17

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4190_0000; //18

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4198_0000; //19

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 3

		//End of Tile0

		#50

		//Tile1
		
		//Block 0
		W_DataInValid = 1;
		I_DataInValid = 1;
		O_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h3f80_0000; //1
		O_DataIn = 32'h4120_0000; //10
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4000_0000; //2
		O_DataIn = 32'h41a0_0000; //20

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4040_0000; //3
		O_DataIn = 32'h41f0_0000; //30

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4080_0000; //4
		O_DataIn = 32'h4220_0000; //40

		#2
		W_DataInValid = 0;
		O_DataInValid = 0;
		I_DataIn = 32'h40a0_0000; //5

		#2
		I_DataIn = 32'h40c0_0000;//6

		#2
		I_DataIn = 32'h40e0_0000;//7
		
		#2
		I_DataInValid = 0;

		//End of Block 0

		//Block 1
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4100_0000; //8
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4110_0000; //9

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4120_0000; //10

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4130_0000; //11

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 1	
		
		//Block 2
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4140_0000; //12
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4150_0000; //13

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4160_0000; //14

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4170_0000; //15

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 2

		//Block 3
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4180_0000; //16
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4188_0000; //17

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4190_0000; //18

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4198_0000; //19

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 3

		//End of Tile1

		#50

		//Tile2
		
		//Block 0
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		O_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h3f80_0000; //1
		O_DataIn = 32'h4120_0000; //10
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4000_0000; //2
		O_DataIn = 32'h41a0_0000; //20

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4040_0000; //3
		O_DataIn = 32'h41f0_0000; //30

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4080_0000; //4
		O_DataIn = 32'h4220_0000; //40

		#2
		W_DataInValid = 0;
		O_DataInValid = 0;
		I_DataIn = 32'h40a0_0000; //5

		#2
		I_DataIn = 32'h40c0_0000;//6

		#2
		I_DataIn = 32'h40e0_0000;//7
		
		#2
		I_DataInValid = 0;

		//End of Block 0

		//Block 1
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4100_0000; //8
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4110_0000; //9

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4120_0000; //10

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4130_0000; //11

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 1	
		
		//Block 2
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4140_0000; //12
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4150_0000; //13

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4160_0000; //14

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4170_0000; //15

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 2

		//Block 3
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4180_0000; //16
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4188_0000; //17

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4190_0000; //18

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4198_0000; //19

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 3

		//End of Tile2

		#2

		//Tile3
		
		//Block 0
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		O_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h3f80_0000; //1
		O_DataIn = 32'h4120_0000; //10
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4000_0000; //2
		O_DataIn = 32'h41a0_0000; //20

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4040_0000; //3
		O_DataIn = 32'h41f0_0000; //30

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4080_0000; //4
		O_DataIn = 32'h4220_0000; //40

		#2
		W_DataInValid = 0;
		O_DataInValid = 0;
		I_DataIn = 32'h40a0_0000; //5

		#2
		I_DataIn = 32'h40c0_0000;//6

		#2
		I_DataIn = 32'h40e0_0000;//7
		
		#2
		I_DataInValid = 0;

		//End of Block 0

		//Block 1
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4100_0000; //8
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4110_0000; //9

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4120_0000; //10

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4130_0000; //11

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 1	
		
		//Block 2
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4140_0000; //12
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4150_0000; //13

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4160_0000; //14

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4170_0000; //15

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 2

		//Block 3
		#2
		W_DataInValid = 1;
		I_DataInValid = 1;
		
		W_DataIn = 32'h40a0_0000; //5
		I_DataIn = 32'h4180_0000; //16
		
		#2
		W_DataIn = 32'h4120_0000; //10
		I_DataIn = 32'h4188_0000; //17

		#2
		W_DataIn = 32'h4170_0000; //15
		I_DataIn = 32'h4190_0000; //18

		#2
		W_DataIn = 32'h41a0_0000; //20 
		I_DataIn = 32'h4198_0000; //19

		#2
		W_DataInValid = 0;
		I_DataInValid = 0;

		//End of Block 3

		//End of Tile3
		

    end

    always #1 clk = ~clk;
		
	
endmodule
