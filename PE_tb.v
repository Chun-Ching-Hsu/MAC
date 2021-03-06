`timescale 100ns/100ns
module PE_tb
    #(  parameter DataInWidth = 8,
        parameter DataOutWidth = 16,
        parameter BufferWidth = 2,
        parameter BufferSize = 4,
        parameter IndexSize = 4  )
        ();
        reg clk, reset;
        reg W_DataInValid, I_DataInValid;
        wire W_DataInRdy, I_DataInRdy, O_DataInRdy;
        reg [DataInWidth-1:0] W_DataIn, I_DataIn, O_DataIn;
        wire [DataInWidth-1:0] W_DataOut, I_DataOut;

        wire W_DataOutValid, I_DataOutValid;
        reg W_DataOutRdy, I_DataOutRdy, O_DataOutRdy;

        reg O_NOPIn;
        wire O_NOPOut;
        
        wire [DataInWidth-1:0] O_DataOut;

        PE dut(.clk(clk), .reset(reset),
        .W_DataInValid(W_DataInValid), .W_DataInRdy(W_DataInRdy), .W_DataIn(W_DataIn),
        .W_DataOut(W_DataOut), .W_DataOutValid(W_DataOutValid), .W_DataOutRdy(W_DataOutRdy),
        .I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(I_DataIn),
        .I_DataOut(I_DataOut), .I_DataOutValid(I_DataOutValid), .I_DataOutRdy(I_DataOutRdy),
        .O_NOPIn(O_NOPIn), .O_DataInRdy(O_DataInRdy), .O_DataIn(O_DataIn),
        .O_DataOut(O_DataOut), .O_NOPOut(O_NOPOut), .O_DataOutRdy(O_DataOutRdy));

    initial begin
        clk = 1;
        reset = 1;
        W_DataInValid = 0;
        I_DataInValid = 0;
        W_DataIn = 0;
        I_DataIn = 0;
        O_DataIn = 0;
        W_DataOutRdy = 0;
        I_DataOutRdy = 0;
        O_DataOutRdy = 0;
        O_NOPIn = 0;
        #2
        reset = 0;
        W_DataInValid = 1;
        I_DataInValid = 1;
        W_DataIn = 2;
        I_DataIn = 3;
        O_DataIn = 4;
        W_DataOutRdy = 0;
        I_DataOutRdy = 0;
        O_DataOutRdy = 0;
        O_NOPIn = 1;
        #6
        W_DataOutRdy = 1;
        I_DataOutRdy = 1;
        O_DataOutRdy = 1;                        
    end

    always #1 clk = ~clk;
	 
	always #2 begin
		$monitor("%0d ns, clk:%b, \n W_DataInValid: %b, I_DataInValid: %b, \n W_DataInRdy: %b, I_DataInRdy: %b, O_DataInRdy: %b, \n W_DataIn: %d, I_DataIn: %d, O_DataIn: %d \n W_DataOut: %d, I_DataOut: %d, O_DataOut: %d \n W_DataOutValid: %b, I_DataOutValid: %b, \n W_DataOutRdy: %b, I_DataOutRdy: %b, O_DataOutRdy: %b \n O_NOPIn: %b \n O_NOPOut: %b \n",
         $stime, clk, W_DataInValid, I_DataInValid, W_DataInRdy, I_DataInRdy, O_DataInRdy, W_DataIn, I_DataIn, O_DataIn, W_DataOut, I_DataOut, O_DataOut,
         W_DataOutValid, I_DataOutValid, W_DataOutRdy, I_DataOutRdy, O_DataOutRdy, O_NOPIn, O_NOPOut);
	end

endmodule
