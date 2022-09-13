module PE_Group_tb
	#(	parameter DataWidth = 32,
		parameter BufferWidth = 2,
		parameter BufferSize = 4,
		parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = 7 )();
    
    reg clk, rst;
	reg [O_PEGroupSize * W_PEGroupSize -1 : 0] W_DataInValid, W_DataOutRdy;
	reg [O_PEGroupSize * W_PEGroupSize -1 : 0] I_DataInValid, I_DataOutRdy;
	reg [O_PEGroupSize * W_PEGroupSize -1 : 0] O_DataInValid, O_DataOutRdy;
	reg [DataWidth * W_PEGroupSize -1 : 0] W_DataIn;
	reg [DataWidth * O_PEGroupSize -1 : 0] O_DataIn;
	reg [DataWidth * I_PEGroupSize -1 : 0] I_DataIn;

	wire [DataWidth * W_PEGroupSize * O_PEGroupSize - 1 : 0] W_DataOut,I_DataOut,O_DataOut;
	wire [O_PEGroupSize * W_PEGroupSize - 1 : 0] W_DataInRdy ,W_DataOutValid;
	wire [O_PEGroupSize * W_PEGroupSize - 1 : 0] I_DataInRdy ,I_DataOutValid;
	wire [O_PEGroupSize * W_PEGroupSize - 1 : 0] O_DataInRdy ,O_DataOutValid;

    PE_Group #( .DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize),
                .W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), .I_PEGroupSize(I_PEGroupSize))
    dut
	(   .clk(clk), .rst(rst),
		.W_DataInValid(W_DataInValid), .W_DataInRdy(W_DataInRdy), .W_DataIn(W_DataIn),
		.I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(I_DataIn),
		.O_DataInValid(O_DataInValid), .O_DataInRdy(O_DataInRdy), .O_DataIn(O_DataIn),
		.O_DataOutValid(O_DataOutValid), .O_DataOutRdy(O_DataOutRdy), .O_DataOut(O_DataOut));

    initial begin
        clk = 1;
        rst = 1;
        #1
        rst = 0;
            
    end

    always #1 clk = ~clk;
endmodule
