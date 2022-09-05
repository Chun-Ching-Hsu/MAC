`timescale 1ps/1ps
module Pointer_tb
    #(parameter BufferWidth = 2)();
    
    reg clk, rst;
    reg EN;

    wire [BufferWidth-1:0] Pointer;

    Pointer #(.BufferWidth(BufferWidth)) dut
            (.clk(clk), .rst(rst), .EN(EN), .Pointer(Pointer));

    initial begin
        clk = 1;
        rst = 1;
        EN = 0;
        #1
        rst = 0;
        EN = 1;
        #10
        EN = 0;
        #2
        rst = 1;
        EN = 1;
        #2
        rst = 0;
    end

    always #1 clk = ~clk;
	 
	always #2 begin
		$monitor("%0d ns, clk:%b, rst: %b, EN: %b, Pointer: %d",
         $stime, clk, rst, EN, Pointer);
	end

endmodule
