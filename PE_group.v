module PE_Group 
	#(	parameter DataWidth = 32,
		parameter BufferWidth = 2,
		parameter BufferSize = 4,
		parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = W_PEGroupSize + O_PEGroupSize - 1,
		parameter W_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter BlockCount = 4,
		parameter BlockCountWidth = 3,
		parameter ACC_Pipeline_Stages = 7) 
	(	clk, aclr,
		W_DataInValid, W_DataInRdy, W_DataIn,
		I_DataInValid, I_DataInRdy, I_DataIn,
		O_DataInValid, O_DataInRdy, O_DataIn,
		O_DataOutValid, O_DataOutRdy, O_DataOut,
		Test_O_Data00, Test_O_Data01, Test_O_Data02, Test_O_Data03,
		Test_O_In_PEAddr, Test_O_Out_PEAddr, Test_I_PEAddr,
		Test_InValid00, Test_InValid01, Test_InValid02, Test_InValid03,
		Test_InValid10, Test_InValid11, Test_InValid12, Test_InValid13,
		Test_OutValid00, Test_OutValid01, Test_OutValid02, Test_OutValid03,
		Test_OutValid10, Test_OutValid11, Test_OutValid12, Test_OutValid13,
		Acc,
		Test_ACC_DataOut, Test_Accumulate, Test_O_In_Block_Counter, Test_I_Block_Counter);

	input clk, aclr;
	input W_DataInValid;
	input I_DataInValid;
	input O_DataInValid, O_DataOutRdy;
	input [DataWidth - 1 : 0] W_DataIn;
	input [DataWidth - 1 : 0] O_DataIn;
	input [DataWidth - 1 : 0] I_DataIn;
	
	wire [DataWidth - 1 : 0] W_Data [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] I_Data [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] O_Data [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	
	wire W_InValid [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire I_InValid [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire O_InValid [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];

	wire W_InRdy [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire I_InRdy [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire O_InRdy [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];

	wire W_OutValid [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire I_OutValid [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire O_OutValid [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];

	wire W_OutRdy [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire I_OutRdy [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire O_OutRdy [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];

	wire [DataWidth - 1 : 0] W_In [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] I_In [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] O_In [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];

	wire [DataWidth - 1 : 0] W_Out [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] I_Out [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] O_Out [0 : W_PEGroupSize - 1][0 : O_PEGroupSize - 1];
	
	output [DataWidth - 1: 0] O_DataOut;
	output W_DataInRdy;
	output reg I_DataInRdy;
	output O_DataInRdy, O_DataOutValid;

	wire W_Rec_Handshaking;
	wire I_Rec_Handshaking;
	wire O_Rec_Handshaking;
	wire O_Send_Handshaking;

	wire [W_PEAddrWidth - 1 : 0] W_PEAddr;
	wire [I_PEAddrWidth - 1 : 0] I_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_In_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_Out_PEAddr;

	assign W_Rec_Handshaking = W_DataInValid & W_DataInRdy;

	reg I_Edge_PE_InValid;
	always @(*) begin
		case(I_PEAddr)
			0: I_Edge_PE_InValid = I_InValid[0][0];
			1: I_Edge_PE_InValid = I_InValid[1][0];
			2: I_Edge_PE_InValid = I_InValid[2][0];
			3: I_Edge_PE_InValid = I_InValid[3][0];
			4: I_Edge_PE_InValid = I_InValid[3][1];
			5: I_Edge_PE_InValid = I_InValid[3][2];
			6: I_Edge_PE_InValid = I_InValid[3][3];
			default: I_Edge_PE_InValid = 0;
		endcase
	end

	assign I_Rec_Handshaking = I_Edge_PE_InValid & I_DataInRdy;
	
	reg O_Edge_PE_InValid;
	always @(*) begin
		case(O_In_PEAddr)
			0: O_Edge_PE_InValid = O_InValid[0][0];
			1: O_Edge_PE_InValid = O_InValid[1][0];
			2: O_Edge_PE_InValid = O_InValid[2][0];
			3: O_Edge_PE_InValid = O_InValid[3][0];
			default: O_Edge_PE_InValid = 0;
		endcase
	end

	assign O_Rec_Handshaking = O_Edge_PE_InValid & O_DataInRdy;

	assign O_Send_Handshaking = O_DataOutValid & O_DataOutRdy;


	wire [BlockCountWidth - 1 : 0] I_Block_Counter;
	wire [BlockCountWidth - 1 : 0] O_In_Block_Counter;
	wire [BlockCountWidth - 1 : 0] O_Out_Block_Counter;

	wire I_BLOCK_EQUAL_TO_ZERO;
	wire I_BLOCK_EQUAL_TO_BLOCK_COUNT;

	wire O_IN_BLOCK_EQUAL_TO_ZERO;
	wire O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT;
	wire O_IN_BLOCK_MORE_THAN_BLOCK_COUNT;

	wire O_OUT_BLOCK_EQUAL_TO_ZERO;
	wire O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT;



	PE_Controller #(.W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), 
					.W_PEAddrWidth(W_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth),
					.BlockCount(BlockCount), .BlockCountWidth(BlockCountWidth))
	ctrl (			.clk(clk), .aclr(aclr), 
					.EN_W(W_Rec_Handshaking), .EN_I(I_Rec_Handshaking), .EN_O_In(O_Rec_Handshaking), .EN_O_Out(O_Send_Handshaking),
					.W_PEAddr(W_PEAddr), .I_PEAddr(I_PEAddr), .O_In_PEAddr(O_In_PEAddr), .O_Out_PEAddr(O_Out_PEAddr),
					.I_BLOCK_EQUAL_TO_ZERO(I_BLOCK_EQUAL_TO_ZERO), .I_BLOCK_EQUAL_TO_BLOCK_COUNT(I_BLOCK_EQUAL_TO_BLOCK_COUNT),
					.O_IN_BLOCK_EQUAL_TO_ZERO(O_IN_BLOCK_EQUAL_TO_ZERO), .O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT(O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT),
					.O_IN_BLOCK_MORE_THAN_BLOCK_COUNT(O_IN_BLOCK_MORE_THAN_BLOCK_COUNT),
					.O_OUT_BLOCK_EQUAL_TO_ZERO(O_OUT_BLOCK_EQUAL_TO_ZERO), .O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT(O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT),
					.I_Block_Counter(I_Block_Counter), .O_In_Block_Counter(O_In_Block_Counter), .O_Out_Block_Counter(O_Out_Block_Counter));

	//edges
	assign W_InValid[0][0] = W_DataInValid && (W_PEAddr == 0);
	assign W_InValid[0][1] = W_DataInValid && (W_PEAddr == 1);
	assign W_InValid[0][2] = W_DataInValid && (W_PEAddr == 2);
	assign W_InValid[0][3] = W_DataInValid && (W_PEAddr == 3); 

	assign W_DataInRdy = W_InRdy[0][W_PEAddr];
	
	//just discard the w value
	assign W_OutRdy[3][0] = 1'b 1;
	assign W_OutRdy[3][1] = 1'b 1;
	assign W_OutRdy[3][2] = 1'b 1;
	assign W_OutRdy[3][3] = 1'b 1;
	
	//input data have 2 sources, one is from outside, the other is from other PEs
	assign I_InValid[0][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataInValid && (I_PEAddr == 0) : I_OutValid[1][3];
	assign I_InValid[1][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataInValid && (I_PEAddr == 1) : I_OutValid[2][3];
	assign I_InValid[2][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataInValid && (I_PEAddr == 2) : I_OutValid[3][3];
	assign I_InValid[3][0] = I_DataInValid && (I_PEAddr == 3);
	assign I_InValid[3][1] = I_DataInValid && (I_PEAddr == 4);
	assign I_InValid[3][2] = I_DataInValid && (I_PEAddr == 5);
	assign I_InValid[3][3] = I_DataInValid && (I_PEAddr == 6);

	always @(*) begin
		case(I_PEAddr)
			0: I_DataInRdy = I_InRdy[0][0];
			1: I_DataInRdy = I_InRdy[1][0];
			2: I_DataInRdy = I_InRdy[2][0];
			3: I_DataInRdy = I_InRdy[3][0];
			4: I_DataInRdy = I_InRdy[3][1];
			5: I_DataInRdy = I_InRdy[3][2];
			6: I_DataInRdy = I_InRdy[3][3];
			default: I_DataInRdy = 0;
		endcase
	end

	//just discard the value
	assign I_OutRdy[0][0] = 1'b 1;
	assign I_OutRdy[0][1] = 1'b 1;
	assign I_OutRdy[0][2] = 1'b 1;
	assign I_OutRdy[0][3] = 1'b 1;

	//input data have 2 destination, one is no where(just discard the value), the other is to other PEs(connect to that PE)
	assign I_OutRdy[1][3] = (I_BLOCK_EQUAL_TO_BLOCK_COUNT) ? 1 : I_InRdy[0][0];
	assign I_OutRdy[2][3] = (I_BLOCK_EQUAL_TO_BLOCK_COUNT) ? 1 : I_InRdy[1][0];
	assign I_OutRdy[3][3] = (I_BLOCK_EQUAL_TO_BLOCK_COUNT) ? 1 : I_InRdy[2][0];

	//output data have 2 sources, one is from outside, the other is constant 0 until sending of data done
	assign O_InValid[0][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataInValid && (O_In_PEAddr == 0) : ~O_IN_BLOCK_MORE_THAN_BLOCK_COUNT && (O_In_PEAddr == 0);
	assign O_InValid[1][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataInValid && (O_In_PEAddr == 1) : ~O_IN_BLOCK_MORE_THAN_BLOCK_COUNT && (O_In_PEAddr == 1);
	assign O_InValid[2][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataInValid && (O_In_PEAddr == 2) : ~O_IN_BLOCK_MORE_THAN_BLOCK_COUNT && (O_In_PEAddr == 2);
	assign O_InValid[3][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataInValid && (O_In_PEAddr == 3) : ~O_IN_BLOCK_MORE_THAN_BLOCK_COUNT && (O_In_PEAddr == 3);

	assign O_DataInRdy = O_InRdy[O_In_PEAddr][0];

	//Broadcast weight to each edge PE
	assign W_In[0][0] = W_DataIn;
	assign W_In[0][1] = W_DataIn;
	assign W_In[0][2] = W_DataIn;
	assign W_In[0][3] = W_DataIn;

	//input data have 2 sources, one is from outside, the other is from other PEs
	assign I_In[0][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataIn : I_Out[1][3];
	assign I_In[1][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataIn : I_Out[2][3];
	assign I_In[2][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataIn : I_Out[3][3];
	assign I_In[3][0] = I_DataIn;
	assign I_In[3][1] = I_DataIn;
	assign I_In[3][2] = I_DataIn;
	assign I_In[3][3] = I_DataIn;
	
	////output data have 2 sources, one is from outside, the other is constant 0 until sending of data done
	assign O_In[0][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataIn : 0;
	assign O_In[1][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataIn : 0;
	assign O_In[2][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataIn : 0;
	assign O_In[3][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataIn : 0;

	wire [DataWidth - 1 : 0] O_ACCDataOut [0 : O_PEGroupSize - 1];
	wire O_ACCDataOutValid [0 : O_PEGroupSize - 1];
	
	assign O_DataOut = O_ACCDataOut[O_Out_PEAddr];
	assign O_DataOutValid = O_ACCDataOutValid[O_Out_PEAddr];

	//test
	output [3:0] Test_Accumulate;
	output [BlockCountWidth - 1 : 0] Test_O_In_Block_Counter;
	assign Test_O_In_Block_Counter = O_In_Block_Counter;
	output [BlockCountWidth - 1 : 0] Test_I_Block_Counter;
	assign Test_I_Block_Counter = I_Block_Counter;
	output Acc;
	assign Acc = Test_Accumulate[1];
	//test
	
	genvar i, j;

	generate    
		for ( i = 0 ; i < O_PEGroupSize ; i = i + 1) begin :generate_PE_i
			for ( j = 0 ; j < W_PEGroupSize ; j = j + 1)begin :generate_PE_j   
				PE PE_buffer(
						.clk(clk),
						.aclr(aclr),
						
						// W part
						.W_DataInValid(W_InValid[i][j]),
						.W_DataInRdy(W_InRdy[i][j]),
						.W_DataIn(W_In[i][j]),
						.W_DataOut(W_Out[i][j]),
						.W_DataOutValid(W_OutValid[i][j]),
						.W_DataOutRdy(W_OutRdy[i][j]),
						
						// I part
						.I_DataInValid(I_InValid[i][j]),
						.I_DataInRdy(I_InRdy[i][j]),
						.I_DataIn(I_In[i][j]),
						.I_DataOut(I_Out[i][j]),
						.I_DataOutValid(I_OutValid[i][j]),
						.I_DataOutRdy(I_OutRdy[i][j]),
						
						// O part
						.O_DataInValid(O_InValid[i][j]),
						.O_DataInRdy(O_InRdy[i][j]),
						.O_DataIn(O_In[i][j]),
						.O_DataOut(O_Out[i][j]),
						.O_DataOutValid(O_OutValid[i][j]),
						.O_DataOutRdy(O_OutRdy[i][j])
				);
			end
		end
		
		for(i = 0; i < O_PEGroupSize - 1; i = i + 1) begin: Inner_Weight_Wires_i
			for(j = 0; j < W_PEGroupSize; j = j + 1) begin: Inner_Weight_Wires_j
				assign W_InValid[i+1][j] = W_OutValid[i][j];
				assign W_OutRdy[i][j] = W_InRdy[i+1][j];
				assign W_In[i+1][j] = W_Out[i][j];
			end
		end
		
		
		for(i = 0; i < O_PEGroupSize - 1; i = i + 1) begin: Inner_Input_Wires_i
			for(j = 1; j < W_PEGroupSize; j = j + 1) begin: Inner_Input_Wire_j
				assign I_InValid[i][j] = I_OutValid[i+1][j-1];
				assign I_OutRdy[i+1][j-1] = I_InRdy[i][j];
				assign I_In[i][j] = I_Out[i+1][j-1];
			end
		end
		
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: Inner_Output_Wires_i
			for(j = 1; j < W_PEGroupSize; j = j + 1) begin: Inner_Output_Wires_j
				assign O_InValid[i][j] = O_OutValid[i][j-1];
				assign O_OutRdy[i][j-1] = O_InRdy[i][j];
				assign O_In[i][j] = O_Out[i][j-1];
			end
		end
		
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: generate_ACC
			ACC #(	.DataWidth(DataWidth), .Pipeline_Stages(ACC_Pipeline_Stages), 
					.AccumulateCount(BlockCount), .AccumulateCountWidth(BlockCountWidth)) acc
				(	.clk(clk), .aclr(aclr), .sclr(O_Send_Handshaking && (O_Out_PEAddr == i)), 
					.DataInValid(O_OutValid[i][W_PEGroupSize - 1]), .DataIn(O_Out[i][W_PEGroupSize - 1]), 
					.DataInRdy(O_OutRdy[i][W_PEGroupSize - 1]), .DataOutValid(O_ACCDataOutValid[i]), .DataOut(O_ACCDataOut[i]),
					.Test_Accumulate(Test_Accumulate[i]));
		end
		
	endgenerate 

	//test
	output [DataWidth - 1 : 0] Test_O_Data00, Test_O_Data01, Test_O_Data02, Test_O_Data03;
	assign Test_O_Data00 = O_Out[1][0];
	assign Test_O_Data01 = O_Out[1][1];
	assign Test_O_Data02 = O_Out[1][2];
	assign Test_O_Data03 = O_Out[1][3];

	output [O_PEAddrWidth - 1 : 0] Test_O_In_PEAddr, Test_O_Out_PEAddr;
	assign Test_O_In_PEAddr = O_In_PEAddr;
	assign Test_O_Out_PEAddr = O_Out_PEAddr;
	output [I_PEAddrWidth - 1 : 0] Test_I_PEAddr;
	assign Test_I_PEAddr = I_PEAddr;
	output Test_OutValid00, Test_OutValid01, Test_OutValid02, Test_OutValid03;
	output Test_OutValid10, Test_OutValid11, Test_OutValid12, Test_OutValid13;
	assign Test_OutValid00 = O_OutValid[0][0];
	assign Test_OutValid01 = O_OutValid[0][1];
	assign Test_OutValid02 = O_OutValid[0][2];
	assign Test_OutValid03 = O_OutValid[0][3];
	assign Test_OutValid10 = O_OutValid[3][0];
	assign Test_OutValid11 = O_OutValid[3][1];
	assign Test_OutValid12 = O_OutValid[3][2];
	assign Test_OutValid13 = O_OutValid[3][3];
	output Test_InValid00, Test_InValid01, Test_InValid02, Test_InValid03;
	output Test_InValid10, Test_InValid11, Test_InValid12, Test_InValid13;
	assign Test_InValid00 = O_InValid[0][0];
	assign Test_InValid01 = O_InValid[0][1];
	assign Test_InValid02 = O_InValid[0][2];
	assign Test_InValid03 = O_InValid[0][3];

	assign Test_InValid10 = O_InValid[1][0];
	assign Test_InValid11 = O_InValid[1][1];
	assign Test_InValid12 = O_InValid[1][2];
	assign Test_InValid13 = O_InValid[1][3];

	output [DataWidth - 1 : 0] Test_ACC_DataOut;
	assign Test_ACC_DataOut = O_ACCDataOut[1];

	//test

endmodule 