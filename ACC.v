module ACC
	#(	parameter DataWidth = 32,
		parameter Pipeline_Stages = 7,
		parameter NumberOfAccumulate = 4,
		parameter NumberOfAccumulateWidth = 2)
	(clk, rst, DataInValid, DataIn, DataOutValid, DataOut);
	input clk, rst;
	input DataInValid;
	input [DataWidth - 1 : 0] DataIn;

	reg [DataWidth - 1 : 0] AccumulatedData;

	output DataOutValid;
	output [DataWidth - 1 : 0] DataOut;

	wire Accumulate;
	wire NOPIn, NOPOut;
	wire [NumberOfAccumulateWidth - 1 : 0] ACC_Counter;

	wire [DataWidth - 1 : 0] AccumulatedResult;

	assign NOPIn = ~DataInValid;
	assign Accumulate = ~NOPOut;
    
	//32-bit FP add (7 Stages)
    FP_ADD FP_AddUnit(
        .aclr(rst),
        .clock(clk),
        .dataa(DataIn),
        .datab(AccumulatedData),
        .result(AccumulatedResult));

    NOPPipeline #(.Stages(Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .aclr(rst),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));
		  
    Pointer #(.BufferWidth(NumberOfAccumulateWidth))
            AccumulateCounter( .clk(clk), .rst(rst), .EN(Accumulate), .Pointer(ACC_Counter));

	always @(posedge clk, posedge rst) begin
		if(rst)
			AccumulatedData = 0;
		else if(Accumulate)
			AccumulatedData <= AccumulatedResult;
		else
			AccumulatedData <= AccumulatedData;
	end

	assign DataOut = AccumulatedData;
	assign DataOutValid = Accumulate && (ACC_Counter == NumberOfAccumulate - 1);

endmodule
