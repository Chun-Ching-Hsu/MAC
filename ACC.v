module ACC
	#(	parameter DataWidth = 32,
		parameter Pipeline_Stages = 7,
		parameter NOPCount = 4,
		parameter NOPCountWidth = 2,
        parameter BufferWidth = 2,
        parameter BufferSize = 4)
	(clk, aclr, sclr, DataInValid, DataIn, DataOutValid, DataInRdy, DataOutRdy, DataOut);

	input clk, aclr, sclr;
	input DataInValid;
	input DataOutRdy;
	input [DataWidth - 1 : 0] DataIn;

	output DataOutValid;
	output DataInRdy;
	output [DataWidth - 1 : 0] DataOut;

	reg [DataWidth - 1 : 0] AccumulatedData;
	reg Add_Busy; //indicate whether the ADD Unit is busy

	//NOP Counter
	wire [NOPCountWidth - 1: 0] NOP_Counter;

	wire NOP_COUNTER_EQUAL_TO_ZERO = (NOP_Counter == 0);
	wire NOP_COUNTER_EQUAL_TO_ACCUMULATE_COUNT = (NOP_Counter == NOPCount - 1);
	//End of NOP Counter

	wire [DataWidth - 1 : 0] ReadyDataFromBuffer;
	wire [DataWidth - 1 : 0] ReadyDataFromAccumulatedData;

	assign ReadyDataFromAccumulatedData = NOP_COUNTER_EQUAL_TO_ZERO ? 0 : AccumulatedData;

	wire Accumulate;

	wire NOPIn, NOPOut;
	wire Valid;

	wire [DataWidth - 1 : 0] AccumulatedResult;
	
	wire Ready_Full, Out_Full;
	wire Ready_Empty, Out_Empty;

	wire Rec_Handshaking, Send_Handshaking;
	
	assign NOPIn = ~(~Ready_Empty && ~Add_Busy);

	assign Accumulate = ~NOPOut;

	assign DataOutValid = ~Out_Empty;
	assign DataInRdy = ~Ready_Full;

	assign Rec_Handshaking = DataInValid & DataInRdy;
	assign Send_Handshaking = DataOutValid & DataOutRdy;

	assign Valid = ~NOPIn & NOP_COUNTER_EQUAL_TO_ACCUMULATE_COUNT;
    
	//32-bit FP add (7 Stages)
    FP_ADD FP_AddUnit(
        .aclr(aclr),
        .clock(clk),
        .dataa(ReadyDataFromBuffer),
        .datab(ReadyDataFromAccumulatedData),
        .result(AccumulatedResult));

    NOPPipeline #(.Stages(Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .aclr(aclr || Valid),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));
	
	ValidPipeline #(.Stages(Pipeline_Stages)) OutData_DataInValidPipelineUnit
    	(.clk(clk), 
        .aclr(aclr),
        .ValidIn(Valid), 
        .ValidOut(OutData_DataInValid));
		  
    Pointer #(.BufferWidth(NOPCountWidth))
            NOPCounter( 	.clk(clk), .aclr(aclr), .sclr(sclr || (~NOPIn && NOP_COUNTER_EQUAL_TO_ACCUMULATE_COUNT)), 
								.EN(~NOPIn), .Pointer(NOP_Counter));

    FIFO_Buffer_ACC #(.DataWidth(DataWidth))
            ReadyData_Buffer(.clk(clk), .aclr(aclr), .Pop(~NOPIn), .Push(Rec_Handshaking), .DataIn(DataIn),
                            .Full(Ready_Full), .Empty(Ready_Empty), .DataOut(ReadyDataFromBuffer));
	
    FIFO_Buffer_ACC #(.DataWidth(DataWidth))
            OutData_Buffer(.clk(clk), .aclr(aclr), .Pop(Send_Handshaking), .Push(OutData_DataInValid), .DataIn(AccumulatedResult),
                            .Full(Out_Full), .Empty(Out_Empty), .DataOut(DataOut));

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
		if (aclr)
			Add_Busy = 0;
		else if (sclr)
			Add_Busy <= 0;
		else if (Accumulate) //ACC Computation for a block done
			Add_Busy <= 0;
		else if (Valid) //ACC computation for a tile done
			Add_Busy <= 0;
		else if (~NOPIn) //Start doing ACC computation
			Add_Busy <= 1;
		else
			Add_Busy <= Add_Busy;
	end

endmodule
