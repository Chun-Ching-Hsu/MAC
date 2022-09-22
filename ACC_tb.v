`timescale 1ps/1ps
module ACC_tb
	#(	parameter DataWidth = 32,
		parameter Pipeline_Stages = 7,
		parameter AccumulateCount = 4,
		parameter AccumulateCountWidth = 2)();

	reg clk, aclr;
	reg DataInValid;
    reg DataOutRdy;
    reg [DataWidth - 1 : 0] DataIn;

	wire DataOutValid;
	wire DataInRdy;
    wire [DataWidth - 1 : 0] DataOut;

    //test
    wire Test_NOP;
    wire Test_Accumulate;

	wire [DataWidth - 1 : 0] Test_ReadyDataFromBuffer;
	wire [DataWidth - 1 : 0] Test_ReadyDataFromAccumulatedData;

    ACC #(  .DataWidth(DataWidth), .Pipeline_Stages(Pipeline_Stages),
            .AccumulateCount(AccumulateCount), .AccumulateCountWidth(AccumulateCountWidth)) 
	dut (   .clk(clk), .aclr(aclr), .DataInValid(DataInValid), .DataInRdy(DataInRdy), .DataOutRdy(DataOutRdy),
            .DataIn(DataIn), .DataOutValid(DataOutValid), .DataOut(DataOut),
            .Test_NOP(Test_NOP), .Test_Accumulate(Test_Accumulate),
            .Test_ReadyDataFromBuffer(Test_ReadyDataFromBuffer), .Test_ReadyDataFromAccumulatedData(Test_ReadyDataFromAccumulatedData));
    
    initial begin
        clk = 1;
        aclr = 1;
        DataOutRdy = 0;
        DataInValid = 0;
        DataIn = 32'h0000_0000;
        #1
        aclr = 0;
        DataOutRdy = 0;
        DataInValid = 1;
        DataIn = 32'h43c8_8000; //401
        #2
        DataInValid = 0;
        DataIn = 32'h0000_0000;
        #2
        DataInValid = 1;
        DataIn = 32'h43c8_0000; //400
        #2
        DataInValid = 0;
        DataIn = 32'h0000_0000;
        #2 
        DataInValid = 1;
        DataIn = 32'h43c8_0000; //400
        #4
        DataInValid = 1;
        DataIn = 32'h43c8_8000; //400
        #2
        DataInValid = 1;
        DataIn = 32'h43c8_0000; //400
        #2
        DataOutRdy = 1;
        #8
        DataOutRdy = 0;
    end
    always #1 clk = ~clk;
    
endmodule
