module ACC
	#(	parameter DataWidth = 32,
		parameter Pipeline_Stages = 7,
		parameter AccumulateCount = 2,
		parameter AccumulateCountWidth = 1,
        parameter BufferWidth = 2,
        parameter BufferSize = 4)
	(clk, aclr, sclr, DataInValid, DataIn, DataOutValid, DataInRdy, DataOut
	, Test_Accumulate);
	input clk, aclr, sclr;
	input DataInValid;
	input [DataWidth - 1 : 0] DataIn;

	output DataOutValid;
	output DataInRdy;
	output [DataWidth - 1 : 0] DataOut;

	reg [DataWidth - 1 : 0] AccumulatedData;
	reg Add_Busy; //indicate whether the ADD Unit is busy

	wire [DataWidth - 1 : 0] ReadyData;

	wire Accumulate;
	wire NOPIn, NOPOut;
	wire [AccumulateCountWidth - 1: 0] ACC_Counter;
	wire Valid;

	wire [DataWidth - 1 : 0] AccumulatedResult;
	
	wire Full;
	wire [BufferSize - 1 : 0] ReadyM;
	wire Rec_Handshaking;
	wire [BufferWidth - 1 : 0] HPM;
	
	assign NOPIn = ~(ReadyM[HPM] && ~Add_Busy);
	assign Accumulate = ~NOPOut;
	assign Rec_Handshaking = DataInValid & DataInRdy;

	assign DataInRdy = ~Full;


	//test
	output Test_Accumulate;
	assign Test_Accumulate = Accumulate;
	//test
    
	//32-bit FP add (7 Stages)
    FP_ADD FP_AddUnit(
        .aclr(aclr),
        .clock(clk),
        .dataa(ReadyData),
        .datab(AccumulatedData),
        .result(AccumulatedResult));

    NOPPipeline #(.Stages(Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .aclr(aclr),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));
	
	ValidPipeline #(.Stages(Pipeline_Stages+1)) DataOutValidPipelineUnit
    	(.clk(clk), 
        .aclr(aclr),
        .NOPIn(Valid), 
        .NOPOut(DataOutValid));
		  
    Pointer #(.BufferWidth(AccumulateCountWidth))
            AccumulateCounter( 	.clk(clk), .aclr(aclr), .sclr(sclr), 
								.EN(~NOPIn), .Pointer(ACC_Counter));
								
    Pointer #(.BufferWidth(BufferWidth))
            HPMUnit( .clk(clk), .aclr(aclr), .EN(~NOPIn), .Pointer(HPM));

    FIFO_Buffer2 #(.DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize))
            Ready_Buffer(.clk(clk), .aclr(aclr), .Pop2(~NOPIn), .Push(Rec_Handshaking), .DataIn(DataIn),
                            .Full(Full), .ReadyM(ReadyM), .DataOut2(ReadyData));

	always @(posedge clk, posedge aclr) begin
		if(aclr)
			AccumulatedData = 0;
		else if(sclr)
			AccumulatedData <= 0;
		else if(Accumulate)
			AccumulatedData <= AccumulatedResult;
		else
			AccumulatedData <= AccumulatedData;
	end

	always @(posedge clk, posedge aclr) begin
		if(aclr)
			Add_Busy = 0;
		else if(sclr)
			Add_Busy <= 0;
		else if (Accumulate) //ACC computation done
			Add_Busy <= 0;
		else if (~NOPIn) //Start doing ACC computation
			Add_Busy <= 1;
		else
			Add_Busy <= Add_Busy;
	end

	assign DataOut = AccumulatedData;
	assign Valid = ~NOPIn && (ACC_Counter == AccumulateCount - 1);

endmodule
