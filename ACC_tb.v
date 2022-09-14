`timescale 1ps/1ps
module ACC_tb
	#(	parameter DataWidth = 32,
		parameter Pipeline_Stages = 7,
		parameter AccumulateCount = 2,
		parameter AccumulateCountWidth = 1)();

	reg clk, aclr;
	reg DataInValid;
    reg [DataWidth - 1 : 0] DataIn;

	wire DataOutValid;
	wire DataInRdy;
    wire [DataWidth - 1 : 0] DataOut;
    
    ACC #(  .DataWidth(DataWidth), .Pipeline_Stages(Pipeline_Stages),
            .AccumulateCount(AccumulateCount), .AccumulateCountWidth(AccumulateCountWidth)) 
	dut (   .clk(clk), .aclr(aclr), .DataInValid(DataInValid), .DataInRdy(DataInRdy),
            .DataIn(DataIn), .DataOutValid(DataOutValid), .DataOut(DataOut));
    
    initial begin
        clk = 1;
        aclr = 1;
        DataInValid = 0;
        DataIn = 32'h0000_0000;
        #1
        aclr = 0;
        DataInValid = 1;
        DataIn = 32'h4170_0000; //15
        #2
        DataInValid = 0;
        DataIn = 32'h0000_0000;
        #16
        DataInValid = 1;
        DataIn = 32'h4080_0000; //4
        #2
        DataInValid = 0;
        DataIn = 32'h0000_0000;

    end
    always #1 clk = ~clk;
    
endmodule
