module ACC
	#(	parameter DataWidth = 32,
		parameter Pipeline_Stages = 7,
		parameter AccumulateCount = 4,
		parameter AccumulateCountWidth = 2,
        parameter BufferWidth = 2,
        parameter BufferSize = 4)
	(clk, aclr, sclr, DataInValid, DataIn, DataOutValid, DataInRdy, DataOutRdy, DataOut
	,Test_NOP, Test_Accumulate, Test_ReadyDataFromBuffer, Test_ReadyDataFromAccumulatedData, Test_ACC_Counter);

	input clk, aclr, sclr;
	input DataInValid;
	input DataOutRdy;
	input [DataWidth - 1 : 0] DataIn;

	output DataOutValid;
	output DataInRdy;
	output [DataWidth - 1 : 0] DataOut;

	reg [DataWidth - 1 : 0] AccumulatedData;
	reg Add_Busy; //indicate whether the ADD Unit is busy

	wire [AccumulateCountWidth - 1: 0] ACC_Counter;

	wire ACC_COUNTER_EQUAL_TO_ZERO = (ACC_Counter == 0);
	wire ACC_COUNTER_EQUAL_TO_ACCUMULATE_COUNT = (ACC_Counter == AccumulateCount - 1);

	wire [DataWidth - 1 : 0] ReadyDataFromBuffer;
	wire [DataWidth - 1 : 0] ReadyDataFromAccumulatedData;

	assign ReadyDataFromAccumulatedData = ACC_COUNTER_EQUAL_TO_ZERO ? 0 : AccumulatedData;

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

	//test
	output Test_NOP;
	assign Test_NOP = NOPIn;
	output Test_Accumulate;
	assign Test_Accumulate = Accumulate;
	output [DataWidth - 1 : 0] Test_ReadyDataFromBuffer;
	output [DataWidth - 1 : 0] Test_ReadyDataFromAccumulatedData;
	assign Test_ReadyDataFromBuffer = ReadyDataFromBuffer;
	assign Test_ReadyDataFromAccumulatedData = ReadyDataFromAccumulatedData;
	output [AccumulateCountWidth - 1 : 0] Test_ACC_Counter;
	assign Test_ACC_Counter = ACC_Counter;
	//test
    
	//32-bit FP add (7 Stages)
    FP_ADD FP_AddUnit(
        .aclr(aclr),
        .clock(clk),
        .dataa(ReadyDataFromBuffer),
        .datab(Test_ReadyDataFromAccumulatedData),
        .result(AccumulatedResult));

    NOPPipeline #(.Stages(Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .aclr(aclr),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));
	
	ValidPipeline #(.Stages(Pipeline_Stages+1)) OutData_DataInValidPipelineUnit
    	(.clk(clk), 
        .aclr(aclr),
        .NOPIn(Valid), 
        .NOPOut(OutData_DataInValid));
		  
    Pointer #(.BufferWidth(AccumulateCountWidth))
            AccumulateCounter( 	.clk(clk), .aclr(aclr), .sclr(sclr || (~NOPIn && ACC_COUNTER_EQUAL_TO_ACCUMULATE_COUNT)), 
								.EN(~NOPIn), .Pointer(ACC_Counter));

    FIFO_Buffer_ACC #(.DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize))
            ReadyData_Buffer(.clk(clk), .aclr(aclr), .Pop(~NOPIn), .Push(Rec_Handshaking), .DataIn(DataIn),
                            .Full(Ready_Full), .Empty(Ready_Empty), .DataOut(ReadyDataFromBuffer));
	
    FIFO_Buffer_ACC #(.DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize))
            OutData_Buffer(.clk(clk), .aclr(aclr), .Pop(Send_Handshaking), .Push(OutData_DataInValid), .DataIn(AccumulatedData),
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

	assign Valid = ~NOPIn & ACC_COUNTER_EQUAL_TO_ACCUMULATE_COUNT;

endmodule
