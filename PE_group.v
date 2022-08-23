module PE_Group 
	#(	parameter DataInWidth = 8,
		parameter DataOutWidth = 16,
		parameter BufferWidth = 2,
		parameter BufferSize = 4,
		parameter IndexSize = 4,
		parameter I_Width	= 4,
		parameter J_Width = 4,
		parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = 7 ) 
	(	clk,reset,
		W_DataInValid,W_DataInRdy,W_DataIn,
		W_DataOut,W_DataOutValid,W_DataOutRdy,
		I_DataInValid,I_DataInRdy,I_DataIn,
		I_DataOut,I_DataOutValid,I_DataOutRdy,
		O_NOPIn,O_DataInRdy,O_DataIn,
		O_DataOut,O_NOPOut,O_DataOutRdy );
		// 不能用 一維以上array 當作輸入和輸出 另外接wire
	input clk,reset;
	input [ J_Width*I_Width-1:0] W_DataInValid,W_DataOutRdy ;
	input [ J_Width*I_Width-1:0] I_DataInValid,I_DataOutRdy;
	input [ J_Width*I_Width-1:0] O_NOPIn,O_DataOutRdy;
	input [ DataInWidth*W_PEGroupSize-1:0] W_DataIn;
	input [ DataInWidth*O_PEGroupSize-1:0] O_DataIn;
	input [ DataInWidth*I_PEGroupSize-1:0]	I_DataIn;
	
	wire [ DataInWidth-1:0] W_In[ I_Width-1:0][ J_Width-1:0];
	wire [ DataInWidth-1:0] I_In[ I_Width-1:0][ J_Width-1:0];
	wire [ DataInWidth-1:0] O_In[ I_Width-1:0][ J_Width-1:0];
	
	wire W_InValid[ I_Width-1:0][ J_Width-1:0],I_InValid[ I_Width-1:0][ J_Width-1:0],O_InNOP[ I_Width-1:0][ J_Width-1:0];
	
	wire W_OutRdy[ I_Width-1:0][ J_Width-1:0],I_OutRdy[ I_Width-1:0][ J_Width-1:0],O_OutRdy[ I_Width-1:0][ J_Width-1:0];
	
	wire W_OutValid[ I_Width-1:0][ J_Width-1:0],I_OutValid[ I_Width-1:0][ J_Width-1:0],O_OutNOP[ I_Width-1:0][ J_Width-1:0];
	
	wire W_InRdy[ I_Width-1:0][ J_Width-1:0],I_InRdy[ I_Width-1:0][ J_Width-1:0],O_InRdy[ I_Width-1:0][ J_Width-1:0];
	
	wire [ DataInWidth-1:0] W_Out[ I_Width-1:0][ J_Width-1:0];
	wire [ DataInWidth-1:0] I_Out[ I_Width-1:0][ J_Width-1:0];
	wire [ DataInWidth-1:0] O_Out[ I_Width-1:0][ J_Width-1:0];
	
	output [ DataInWidth*I_Width*J_Width-1:0] W_DataOut,I_DataOut,O_DataOut;
	output [ J_Width*I_Width-1:0] W_DataInRdy ,W_DataOutValid;
	output [ J_Width*I_Width-1:0] I_DataInRdy ,I_DataOutValid;
	output [ J_Width*I_Width-1:0] O_DataInRdy ,O_NOPOut;
	
	genvar i,j;
	generate    
		for ( i=0 ; i<I_Width ; i=i+1) begin :generate_PE_i
			for ( j=0 ; j<J_Width ; j=j+1)begin :generate_PE_j 
			// 先往右在向下 裡面先右 外面向下 i 上下 j 左右
			// i當大的 i*4+j
				assign W_InValid[i][j] = W_DataInValid[(i*4+j)];
				assign I_InValid[i][j] = I_DataInValid[(i*4+j)];
				assign O_InNOP[i][j] = O_NOPIn[(i*4+j)];
				
				assign W_OutRdy[i][j] = W_DataOutRdy[(i*4+j)];
				assign I_OutRdy[i][j] = I_DataOutRdy[(i*4+j)];
				assign O_OutRdy[i][j] = O_DataOutRdy[(i*4+j)];
				
				assign W_OutValid[i][j] = W_DataOutValid[(i*4+j)];
				assign I_OutValid[i][j] = I_DataOutValid[(i*4+j)];
				assign O_OutNOP[i][j] = O_NOPOut[(i*4+j)];
				
				assign W_InRdy[i][j] = W_DataOutRdy[(i*4+j)];
				assign I_InRdy[i][j] = I_DataOutRdy[(i*4+j)];
				assign O_InRdy[i][j] = O_DataOutRdy[(i*4+j)];
				
				assign W_DataOut[(i*4+j+1)*DataInWidth-1:(i*4+j)*DataInWidth] = W_Out[i][j];
				assign I_DataOut[(i*4+j+1)*DataInWidth-1:(i*4+j)*DataInWidth] = I_Out[i][j];
				assign O_DataOut[(i*4+j+1)*DataInWidth-1:(i*4+j)*DataInWidth] = O_Out[i][j];
				
				if ( i == 0)begin
					assign W_In [i][j] = W_DataIn[(j+1)*DataInWidth-1:j*DataInWidth];
				end 
				
				else if (j == 0) begin
					assign O_In [i][j] = O_DataIn[(i+1)*DataInWidth-1:i*DataInWidth];
					assign I_In [i][j] = I_DataIn[(i+j+1)*DataInWidth-1:(i+j)*DataInWidth];
				end
				
				else if ( i==3 &  j!=0)begin
					assign I_In [i][j] = I_DataIn[(i+j+1)*DataInWidth-1:(i+j)*DataInWidth];
				end
				
				else begin
						assign W_In[i][j] =  W_Out[i-1][j];			// [i-1][j]
						assign O_In[i][j] =  O_Out[i][j-1]; 		// [i][j-1]
						assign I_In[i][j] = 	I_Out[i+1][j-1];		// [i+1][j-1]
				end
				
				// 上面好像可以寫 case  
				
				PE PE_buffer(
						.clk(clk),
						.reset(reset), // reset 應該是大家一起麻
						
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
						.O_NOPIn(O_InNOP[i][j]),
						.O_DataInRdy(O_InRdy[i][j]),
						.O_DataIn(O_In[i][j]),
						.O_DataOut(O_Out[i][j]),
						.O_NOPOut(O_OutNOP[i][j]),
						.O_DataOutRdy(O_OutRdy[i][j])
				);
			end
		end	
	endgenerate 


endmodule 