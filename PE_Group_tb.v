`timescale 1ps/1ps
module PE_Group_tb
	#(	parameter DataWidth = 32,
		parameter BufferWidth = 4,
		parameter BufferSize = 16,
		parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = 7,
		parameter W_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter BlockCount = 2,
		parameter BlockCountWidth = 1)();
    
	reg clk, aclr;
	reg W_DataInValid;
	reg I_DataInValid;
	reg O_DataInValid, O_DataOutRdy;
	reg [DataWidth - 1 : 0] W_DataIn;
	reg [DataWidth - 1 : 0] O_DataIn;
	reg [DataWidth - 1 : 0] I_DataIn;
	
	wire [DataWidth - 1: 0] O_DataOut;
	wire W_DataInRdy;
	wire I_DataInRdy;
	wire O_DataInRdy, O_DataOutValid;

	//test
	wire [DataWidth - 1 : 0] O_DataOut00, O_DataOut01, O_DataOut02, O_DataOut03;
	wire [3:0] Test_O_OutValid;
	wire [DataWidth - 1 : 0] I_DataOut00, I_DataOut01, I_DataOut02, I_DataOut03;
	wire [3:0] Test_I_OutValid;


    PE_Group #( .DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize),
                .W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), .I_PEGroupSize(I_PEGroupSize),
				.W_PEAddrWidth(W_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth),
				.BlockCount(BlockCount), .BlockCountWidth(BlockCountWidth))
    dut
	(   .clk(clk), .aclr(aclr),
		.W_DataInValid(W_DataInValid), .W_DataInRdy(W_DataInRdy), .W_DataIn(W_DataIn),
		.I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(I_DataIn),
		.O_DataInValid(O_DataInValid), .O_DataInRdy(O_DataInRdy), .O_DataIn(O_DataIn),
		.O_DataOutValid(O_DataOutValid), .O_DataOutRdy(O_DataOutRdy), .O_DataOut(O_DataOut),
		.O_DataOut00(O_DataOut00), .O_DataOut01(O_DataOut01), .O_DataOut02(O_DataOut02), .O_DataOut03(O_DataOut03), 
		.Test_O_OutValid(Test_O_OutValid),
		.I_DataOut00(I_DataOut00), .I_DataOut01(I_DataOut01), .I_DataOut02(I_DataOut02), .I_DataOut03(I_DataOut03), 
		.Test_I_OutValid(Test_I_OutValid));

	parameter W_Size = 8;
	parameter I_Size = 15;
	parameter O_Size = 8;

	parameter W_TileSize = 8;
	parameter I_TileSize = 11;
	parameter O_TileSize = 4;

	parameter W_On_ReadTimes = (O_Size / O_TileSize) * (O_TileSize / O_PEGroupSize) * (W_Size / W_TileSize) * (W_TileSize / W_PEGroupSize) * W_PEGroupSize;
	parameter I_On_ReadTimes = (O_Size / O_TileSize) * (O_TileSize / O_PEGroupSize) * (W_Size / W_TileSize) * (O_PEGroupSize + W_TileSize - 1);
	parameter O_On_ReadTimes = (O_Size / O_TileSize) * (O_TileSize / O_PEGroupSize) * O_PEGroupSize * (W_Size / W_TileSize);

	parameter W_Off_ReadTimes = (O_Size / O_TileSize) * (W_Size / W_TileSize) * W_TileSize;
	parameter I_Off_ReadTimes = (O_Size / O_TileSize) * (W_Size / W_TileSize) * (O_PEGroupSize + W_TileSize - 1);
	parameter O_Off_ReadTimes = (O_Size / O_TileSize) * O_TileSize;
	
	parameter ReadTimesWidth = 32;

	integer W_ptr = 0;
	integer I_ptr = 0;
	integer O_ptr = 0;

	integer W_Count = 0;
	integer I_Count = 0;
	integer O_Count = 0;

	reg [DataWidth-1:0] W_Buffer [0:W_Size-1];
	reg [DataWidth-1:0] I_Buffer [0:I_Size-1];
	reg [DataWidth-1:0] O_Buffer [0:O_Size-1];
	reg [DataWidth-1:0] Ans_Buffer [0:O_Size-1];
	
	reg [ReadTimesWidth-1:0] W_On_Addr_Buffer [0:W_On_ReadTimes-1];
	reg [ReadTimesWidth-1:0] I_On_Addr_Buffer [0:I_On_ReadTimes-1];
	reg [ReadTimesWidth-1:0] O_On_Addr_Buffer [0:O_On_ReadTimes-1];

	reg [ReadTimesWidth-1:0] W_Off_Addr_Buffer [0:W_Off_ReadTimes-1];
	reg [ReadTimesWidth-1:0] I_Off_Addr_Buffer [0:I_Off_ReadTimes-1];
	reg [ReadTimesWidth-1:0] O_Off_Addr_Buffer [0:O_Off_ReadTimes-1];
	
	integer i;

	initial begin
		$readmemb("Data/W_Data.txt",W_Buffer);
		$readmemb("Data/I_Data.txt",I_Buffer);
		$readmemb("Data/O_Data.txt",O_Buffer);

		$display("Weight Data");
		for (i = 0; i < W_Size; i = i + 1) $display("%d: %h", i, W_Buffer[i]);
		$display("Input Data");
		for (i = 0; i < I_Size; i = i + 1) $display("%d: %h", i, I_Buffer[i]);
		$display("Output Data");
		for (i = 0; i < O_Size; i = i + 1) $display("%d: %h", i, O_Buffer[i]);

		$display("W_On_ReadTimes: %d\n", W_On_ReadTimes);
		$display("I_On_ReadTimes: %d\n", I_On_ReadTimes);
		$display("O_On_ReadTimes: %d\n", O_On_ReadTimes);

		$display("W_Off_ReadTimes: %d\n", W_Off_ReadTimes);
		$display("I_Off_ReadTimes: %d\n", I_Off_ReadTimes);
		$display("O_Off_ReadTimes: %d\n", O_Off_ReadTimes);
		
	end

	integer Result_Fptr;
	integer W_On_Chip_Addr_Fptr;
	integer I_On_Chip_Addr_Fptr;
	integer O_On_Chip_Addr_Fptr;
	integer W_Off_Chip_Addr_Fptr;
	integer I_Off_Chip_Addr_Fptr;
	integer O_Off_Chip_Addr_Fptr;

	integer cnt;
	initial begin
		Result_Fptr = $fopen("Data/Result.txt", "w");
		W_Off_Chip_Addr_Fptr = $fopen("Data/W_Off_Address.txt", "r");
		I_Off_Chip_Addr_Fptr = $fopen("Data/I_Off_Address.txt", "r");
		O_Off_Chip_Addr_Fptr = $fopen("Data/O_Off_Address.txt", "r");

		for(i = 0; i < W_Off_ReadTimes; i = i + 1) begin
			cnt = $fscanf(W_Off_Chip_Addr_Fptr, "%d", W_Off_Addr_Buffer[i]);
			$display("Weight Address: %d\n", W_Off_Addr_Buffer[i]);
		end
		for(i = 0; i < I_Off_ReadTimes; i = i + 1) begin
			cnt = $fscanf(I_Off_Chip_Addr_Fptr, "%d", I_Off_Addr_Buffer[i]);
			$display("Input Address: %d\n", I_Off_Addr_Buffer[i]);
		end
		for(i = 0; i < O_Off_ReadTimes; i = i + 1) begin
			cnt = $fscanf(O_Off_Chip_Addr_Fptr, "%d", O_Off_Addr_Buffer[i]);
			$display("Output Address: %d\n", O_Off_Addr_Buffer[i]);
		end

		$fclose(W_Off_Chip_Addr_Fptr);
		$fclose(I_Off_Chip_Addr_Fptr);
		$fclose(O_Off_Chip_Addr_Fptr);

	end

	initial begin
		clk = 1;
		aclr = 1;
		W_DataInValid = 0;
		I_DataInValid = 0;
		O_DataInValid = 0;
		O_DataOutRdy = 0;
		W_DataIn = 0;
		I_DataIn = 0;
		O_DataIn = 0;
		#1
		aclr = 0;
		O_DataOutRdy = 1;
	end


	integer Output_Count = 0;
	//check O_DataOutValid in each cycle, if DataOutValid is 1, write O_DataOut into Ans_Buffer
	always #2 begin
		if(O_DataOutValid) begin
			$display("%h", O_DataOut);
			$fwrite(Result_Fptr, "%b\n", O_DataOut);
			if (Output_Count == O_Size - 1) begin
				$fclose(Result_Fptr);
			end
			else begin
				Output_Count = Output_Count + 1;
			end
		end
	end
	
	//Weight Data
	integer W_Off_Read_Count = 0;

	always #2 begin
		if(W_Off_Read_Count < W_Off_ReadTimes) begin
			W_DataInValid = 1;
			$display("Write [%d]:%h into Weight", W_Off_Addr_Buffer[W_Off_Read_Count], W_Buffer[W_Off_Addr_Buffer[W_Off_Read_Count]]);
			W_DataIn = W_Buffer[W_Off_Addr_Buffer[W_Off_Read_Count]];
			W_Off_Read_Count = W_Off_Read_Count + 1;
		end
		else begin
			W_DataInValid = 0;
		end
	end

	
	//Input Data
	integer I_Off_Read_Count = 0;
	integer I_Test_Fptr;
	initial begin
		I_Test_Fptr = $fopen("Data/Test_Input.csv","w");
	end
	
	always #1 begin
		if($time % 2 != 0) begin
			if(I_Off_Read_Count < I_Off_ReadTimes) begin
				I_DataInValid = 1;
				$fwrite(I_Test_Fptr, "%d, %d, %h\n", $time, I_Off_Addr_Buffer[I_Off_Read_Count], I_Buffer[I_Off_Addr_Buffer[I_Off_Read_Count]]);
				$display("Write [%d]:%h into Input", I_Off_Addr_Buffer[I_Off_Read_Count], I_Buffer[I_Off_Addr_Buffer[I_Off_Read_Count]]);
				I_DataIn = I_Buffer[I_Off_Addr_Buffer[I_Off_Read_Count]];
				I_Off_Read_Count = I_Off_Read_Count + 1;
				if(I_Off_Read_Count == I_Off_ReadTimes) begin
					$fclose(I_Test_Fptr);
				end
			end
			else begin
				I_DataInValid = 0;
			end			
		end
	end
	
	

	//Output Data
	integer O_Off_Read_Count = 0;
	always #1 begin
		if($time %2 != 0) begin
			if(O_Off_Read_Count < O_Off_ReadTimes) begin
				O_DataInValid = 1;
				O_DataIn = O_Buffer[O_Off_Addr_Buffer[O_Off_Read_Count]];
				if(O_DataInValid && O_DataInRdy) begin
					$display("Write [%d]:%h into Output", O_Off_Addr_Buffer[O_Off_Read_Count], O_Buffer[O_Off_Addr_Buffer[O_Off_Read_Count]]);
					O_Off_Read_Count = O_Off_Read_Count + 1;
				end
			end
			else begin
				O_DataInValid = 0;
			end
		end		
	end
/*
    initial begin
		#1
		//Tile0
		
		//Block 0
		O_DataInValid = 1;
		$display("Write %h into Output", O_Buffer[0]);
		O_DataIn = O_Buffer[0];
        //O_DataIn = 32'h41200000; //10
		
		#2
		O_DataInValid = 1;
		$display("Write %h into Output", O_Buffer[1]);
		O_DataIn = O_Buffer[1];
        //O_DataIn = 32'h41a00000; //20

		#2
		O_DataInValid = 1;
		$display("Write %h into Output", O_Buffer[2]);
		O_DataIn = O_Buffer[2];
        //O_DataIn = 32'h41f00000; //30

		#2
		O_DataInValid = 1;
		$display("Write %h into Output", O_Buffer[3]);
		O_DataIn = O_Buffer[3];
        //O_DataIn = 32'h42200000; //40

        //40

		#2
		O_DataInValid = 0;

		//End of Block 0
		
		//End of Tile 0	
		
		#20

		//Tile1
		
		//Block 0

		O_DataInValid = 1;
		$display("Write %h into Output", O_Buffer[4]);
		O_DataIn = O_Buffer[4];
        //O_DataIn = 32'h41200000; //10
		
		#2
		O_DataInValid = 1;
		$display("Write %h into Output", O_Buffer[5]);
		O_DataIn = O_Buffer[5];
        //O_DataIn = 32'h41a00000; //20

		#2
		O_DataInValid = 1;
		$display("Write %h into Output", O_Buffer[6]);
		O_DataIn = O_Buffer[6];
        //O_DataIn = 32'h41f00000; //30

		#2
		O_DataInValid = 1;
		$display("Write %h into Output", O_Buffer[7]);
		O_DataIn = O_Buffer[7];
        //O_DataIn = 32'h42200000; //40

		#2
		O_DataInValid = 0;
		
		//End of Block 0

		//End of Tile 1

    end
	*/

    always #1 clk = ~clk;
		
	
endmodule
