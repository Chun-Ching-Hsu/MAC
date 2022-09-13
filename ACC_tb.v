module ACC_tb
	#(	parameter DataWidth = 32,
		parameter Pipeline_Stages = 7,
		parameter NumberOfAccumulate = 4,
		parameter NumberOfAccumulateWidth = 2)();

	reg clk, rst;
	reg DataInValid;
    reg [DataWidth - 1 : 0] DataIn;

	wire DataOutValid;
	wire [DataWidth - 1 : 0] DataOut;
    
    ACC #(  .DataWidth(DataWidth), .Pipeline_Stages(Pipeline_Stages),
            .NumberOfAccumulate(NumberOfAccumulate), .NumberOfAccumulateWidth(NumberOfAccumulateWidth)) 
	dut (.clk(clk), .rst(rst), .DataInValid(DataInValid), .DataIn(DataIn), .DataOutValid(DataOutValid), .DataOut(DataOut));
    
    initial begin
        clk = 1;
        rst = 1;
        DataInValid = 0;
        DataIn = 32'h0000_0000;
        #1
        rst = 0;
        DataInValid = 1;
        DataIn = 32'h4170_0000;
        #2
        DataInValid = 1;
        DataIn = 32'h4080_0000;
        #2
        DataInValid = 0;

    end
    always #1 clk = ~clk;
    
endmodule
