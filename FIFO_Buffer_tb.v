`timescale 1ps/1ps
module FIFO_Buffer_tb
    #(  parameter DataWidth = 32,
        parameter BufferWidth = 2,
        parameter BufferSize = 4)();

        reg clk, rst;
        reg Pop1, Pop2, Push;
        reg [DataWidth-1:0] DataIn;

        wire Empty, Full;
        wire [BufferSize-1:0] ReadyM;
        wire [DataWidth-1:0] DataOut1, DataOut2;

    FIFO_Buffer #(.DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize)) 
        dut (.clk(clk), .rst(rst), .Pop1(Pop1), .Pop2(Pop2), .Push(Push), .DataIn(DataIn),
        .Empty(Empty), .Full(Full), .ReadyM(ReadyM), .DataOut1(DataOut1), .DataOut2(DataOut2));

    initial begin
        clk = 1;
        rst = 1;
        DataIn = 0;
        Push = 0;
        Pop1 = 0;
        Pop2 = 0;
        #1
        rst = 0;
        Push = 1;
        Pop1 = 0;
        Pop2 = 0;
        #2
        Push = 1;
        Pop1 = 0;
        Pop2 = 0;
        #2
        Push = 1;
        Pop1 = 0;
        Pop2 = 0;
        #2
        Push = 1;
        Pop1 = 0;
        Pop2 = 0;
        #2
        Push = 0;
        Pop1 = 0;
        Pop2 = 0;
        #2
        Push = 0;
        Pop1 = 1;
        Pop2 = 0;
        #2
        Push = 0;
        Pop1 = 0;
        Pop2 = 1;
        #2
        Push = 0;
        Pop1 = 1;
        Pop2 = 0;
        #2
        Push = 0;
        Pop1 = 1;
        Pop2 = 0;
        #2
        Push = 0;
        Pop1 = 0;
        Pop2 = 1;
        #2
        Push = 1;
        Pop1 = 1;
        Pop2 = 1;
        #4
        Push = 1;
        Pop1 = 0;
        Pop2 = 1;
        #2
        Push = 0;
        Pop1 = 0;
        Pop2 = 1;
        #2
        Push = 0;
        Pop1 = 0;
        Pop2 = 0;                       
    end

    always #1 clk = ~clk;
	always #2 DataIn = DataIn + 1;
        
	always #2 begin
		//$monitor("%0d ns, clk:%b, rst:%b, Pop1: %b, Pop2: %b, Push: %b, Round:%b\n",
        // $stime, clk, rst, Pop1, Pop2, Push, Round);
	end
endmodule
