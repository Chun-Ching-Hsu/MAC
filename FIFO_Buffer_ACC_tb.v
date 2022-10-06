`timescale 1ps/1ps
module FIFO_Buffer_ACC_tb
    #(  parameter DataWidth = 32)();
    parameter BufferWidth = 2;
    parameter BufferSize = 4;

    reg clk, aclr;
    reg Pop, Push;
    reg [DataWidth-1:0] DataIn;

    wire Empty, Full;
    wire [DataWidth-1:0] DataOut;


    FIFO_Buffer_ACC #(.DataWidth(DataWidth)) 
        dut (.clk(clk), .aclr(aclr), .Pop(Pop), .Push(Push), .DataIn(DataIn),
        .Empty(Empty), .Full(Full), .DataOut(DataOut));

    initial begin
        clk = 1;
        aclr = 1;
        DataIn = 0;
        Push = 0;
        Pop = 0;
        #1
        aclr = 0;
        Push = 1;
        Pop = 0;
        #2
        Push = 1;
        Pop = 0;
        #2
        Push = 1;
        Pop = 0;
        #2
        Push = 1;
        Pop = 0;
        #2
        Push = 0;
        Pop = 0;
        #2
        Push = 0;
        Pop = 1;
        #2
        Push = 0;
        Pop = 0;
        #2
        Push = 0;
        Pop = 1;
        #2
        Push = 0;
        Pop = 1;
        #2
        Push = 0;
        Pop = 0;
        #2
        Push = 1;
        Pop = 1;
        #4
        Push = 1;
        Pop = 0;
        #2
        Push = 0;
        Pop = 0;
        #2
        Push = 0;
        Pop = 0;
    end

    always #1 clk = ~clk;
	always #2 DataIn = DataIn + 1;
        
	always #2 begin
		//$monitor("%0d ns, clk:%b, rst:%b, Pop1: %b, Pop2: %b, Push: %b, Round:%b\n",
        // $stime, clk, rst, Pop1, Pop2, Push, Round);
	end
endmodule
