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
		parameter I_BlockCount = 4,
		parameter I_BlockCountWidth = 2) 
	(	clk, aclr,
		W_DataInValid, W_DataInRdy, W_DataIn,
		I_DataInValid, I_DataInRdy, I_DataIn,
		O_DataInValid, O_DataInRdy, O_DataIn,
		O_DataOutValid, O_DataOutRdy, O_DataOut,
		Test_I_Data00, Test_I_Data10, Test_I_Data20, Test_I_Data30, Test_I_Data31, Test_I_Data32, Test_I_Data33,
		Test_I_PEAddr);

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

	assign W_Rec_Handshaking = W_DataInValid & W_DataInRdy;
	assign I_Rec_Handshaking = I_DataInValid & I_DataInRdy;
	assign O_Rec_Handshaking = O_DataInValid & O_DataInRdy;
	assign O_Send_Handshaking = O_DataOutValid & O_DataOutRdy;

	wire [W_PEAddrWidth - 1 : 0] W_PEAddr;
	wire [I_PEAddrWidth - 1 : 0] I_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_In_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_Out_PEAddr;

	wire [I_BlockCountWidth - 1 : 0] I_Block_Counter;
	wire I_BLOCK_EQUAL_TO_ZERO;
	wire I_BLOCK_EQUAL_TO_BLOCK_COUNT;

	//test
	output [DataWidth - 1 : 0] Test_I_Data00, Test_I_Data10, Test_I_Data20, Test_I_Data30, Test_I_Data31, Test_I_Data32, Test_I_Data33;
	assign Test_I_Data00 = I_Out[0][0];
	assign Test_I_Data10 = I_Out[1][0];
	assign Test_I_Data20 = I_Out[2][0];
	assign Test_I_Data30 = I_Out[3][0];
	assign Test_I_Data31 = I_Out[3][1];
	assign Test_I_Data32 = I_Out[3][2];
	assign Test_I_Data33 = I_Out[3][3];

	output [I_PEAddrWidth - 1 : 0] Test_I_PEAddr;
	assign Test_I_PEAddr = I_PEAddr;

	assign I_BLOCK_EQUAL_TO_ZERO = (I_Block_Counter == 0);
	assign I_BLOCK_EQUAL_TO_BLOCK_COUNT = (I_Block_Counter == I_BlockCount - 1);


	PE_Controller #(.W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), 
					.W_PEAddrWidth(W_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth),
					.I_BlockCount(I_BlockCount), .I_BlockCountWidth(I_BlockCountWidth))
	ctrl (			.clk(clk), .aclr(aclr), 
					.EN_W(W_Rec_Handshaking), .EN_I(I_Rec_Handshaking), .EN_O_In(O_Rec_Handshaking), .EN_O_Out(O_Send_Handshaking),
					.W_PEAddr(W_PEAddr), .I_PEAddr(I_PEAddr), .O_In_PEAddr(O_In_PEAddr), .O_Out_PEAddr(O_Out_PEAddr),
					.I_Block_Counter(I_Block_Counter));
	

	//edges
	assign W_InValid[0][0] = W_DataInValid && (W_PEAddr == 0);
	assign W_InValid[0][1] = W_DataInValid && (W_PEAddr == 1);
	assign W_InValid[0][2] = W_DataInValid && (W_PEAddr == 2);
	assign W_InValid[0][3] = W_DataInValid && (W_PEAddr == 3); 

	assign W_DataInRdy = W_InRdy[0][W_PEAddr];

	assign W_OutRdy[3][0] = 1'b 1;
	assign W_OutRdy[3][1] = 1'b 1;
	assign W_OutRdy[3][2] = 1'b 1;
	assign W_OutRdy[3][3] = 1'b 1;

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

	assign I_OutRdy[0][0] = 1'b 1;
	assign I_OutRdy[0][1] = 1'b 1;
	assign I_OutRdy[0][2] = 1'b 1;
	assign I_OutRdy[0][3] = 1'b 1;

	assign I_OutRdy[1][3] = (I_BLOCK_EQUAL_TO_BLOCK_COUNT) ? 1 : I_InRdy[0][0];
	assign I_OutRdy[2][3] = (I_BLOCK_EQUAL_TO_BLOCK_COUNT) ? 1 : I_InRdy[1][0];
	assign I_OutRdy[3][3] = (I_BLOCK_EQUAL_TO_BLOCK_COUNT) ? 1 : I_InRdy[2][0];

	assign O_InValid[0][0] = O_DataInValid && (O_In_PEAddr == 0);
	assign O_InValid[1][0] = O_DataInValid && (O_In_PEAddr == 1);
	assign O_InValid[2][0] = O_DataInValid && (O_In_PEAddr == 2);
	assign O_InValid[3][0] = O_DataInValid && (O_In_PEAddr == 3);

	assign O_DataInRdy = O_InRdy[O_In_PEAddr][0];

	assign O_OutRdy[0][3] = 1'b 1;
	assign O_OutRdy[1][3] = 1'b 1;
	assign O_OutRdy[2][3] = 1'b 1;
	assign O_OutRdy[3][3] = 1'b 1;

	assign W_In[0][0] = W_DataIn;
	assign W_In[0][1] = W_DataIn;
	assign W_In[0][2] = W_DataIn;
	assign W_In[0][3] = W_DataIn;

	assign I_In[0][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataIn : I_Out[1][3];
	assign I_In[1][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataIn : I_Out[2][3];
	assign I_In[2][0] = I_BLOCK_EQUAL_TO_ZERO ? I_DataIn : I_Out[3][3];
	assign I_In[3][0] = I_DataIn;
	assign I_In[3][1] = I_DataIn;
	assign I_In[3][2] = I_DataIn;
	assign I_In[3][3] = I_DataIn;

	assign O_In[0][0] = O_DataIn;
	assign O_In[1][0] = O_DataIn;
	assign O_In[2][0] = O_DataIn;
	assign O_In[3][0] = O_DataIn;

	wire [DataWidth - 1 : 0] O_ACCDataOut [0 : O_PEGroupSize - 1];
	wire O_ACCDataOutValid [0 : O_PEGroupSize - 1];
	
	assign O_DataOut = O_ACCDataOut[O_Out_PEAddr];
	assign O_DataOutValid =  O_ACCDataOutValid[O_Out_PEAddr];
	
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
			for(j = 1; j < W_PEGroupSize - 1; j = j + 1) begin: Inner_Output_Wires_j
				assign O_InValid[i][j] = O_OutValid[i][j-1];
				assign O_OutRdy[i][j-1] = O_InRdy[i][j];
				assign O_In[i][j] = O_Out[i][j-1];
			end
		end
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: generate_ACC
			ACC #(.DataWidth(DataWidth), .Pipeline_Stages(7), .AccumulateCount(4), .AccumulateCountWidth(2)) acc
				(	.clk(clk), .aclr(aclr), .DataInValid(O_OutValid[i][W_PEGroupSize - 1]), .DataIn(O_Out[i][W_PEGroupSize - 1]), 
					.DataInRdy(O_OutRdy[i][W_PEGroupSize - 1]), .DataOutValid(O_ACCDataOutValid[i]), .DataOut(O_ACCDataOut[i]));
		end
	
	endgenerate 

endmodule 