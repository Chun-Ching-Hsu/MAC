module ACC
	#(	parameter DataWidth = 32,
		parameter Pipeline_Stages = 7,
		parameter AccumulateCount = 2,
		parameter AccumulateCountWidth = 1)
	(clk, aclr, DataInValid, DataIn, DataOutValid, DataInRdy, DataOut);
	input clk, aclr;
	input DataInValid;
	input [DataWidth - 1 : 0] DataIn;

	reg [DataWidth - 1 : 0] AccumulatedData;
	reg busy; //indicate whether the ADD Unit is busy

	output DataOutValid;
	output DataInRdy;
	output [DataWidth - 1 : 0] DataOut;

	wire Accumulate;
	wire NOPIn, NOPOut;
	wire [AccumulateCountWidth - 1 : 0] ACC_Counter;
	wire Valid;

	wire [DataWidth - 1 : 0] AccumulatedResult;

	wire Rec_Handshaking;
	assign NOPIn = ~DataInValid;
	assign Accumulate = ~NOPOut;
	assign Rec_Handshaking = DataInValid & DataInRdy;
	assign DataInRdy = ~busy;
    
	//32-bit FP add (7 Stages)
    FP_ADD FP_AddUnit(
        .aclr(aclr),
        .clock(clk),
        .dataa(DataIn),
        .datab(AccumulatedData),
        .result(AccumulatedResult));

    NOPPipeline #(.Stages(Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .aclr(aclr),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));
	
	NOPPipeline #(.Stages(1)) DataOutValidPipelineUnit
    	(.clk(clk), 
        .aclr(aclr),
        .NOPIn(Valid), 
        .NOPOut(DataOutValid));
		  
    Pointer #(.BufferWidth(AccumulateCountWidth))
            AccumulateCounter( 	.clk(clk), .aclr(aclr), .sclr(Accumulate && ACC_Counter == AccumulateCount - 1), 
								.EN(Accumulate), .Pointer(ACC_Counter));

	always @(posedge clk, posedge aclr) begin
		if(aclr)
			AccumulatedData = 0;
		else if(Accumulate)
			AccumulatedData <= AccumulatedResult;
		else
			AccumulatedData <= AccumulatedData;
	end

	always @(posedge clk, posedge aclr) begin
		if(aclr)
			busy = 0;
		else if (Rec_Handshaking) //Start doing ACC computation
			busy <= 1;
		else if (Accumulate) //ACC computation done
			busy <= 0;
		else
			busy <= busy;
	end
	assign DataOut = AccumulatedData;
	assign Valid = Accumulate && (ACC_Counter == AccumulateCount - 1);

endmodule
