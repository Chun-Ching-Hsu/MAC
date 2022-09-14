`timescale 1ps/1ps
module Pointer_tb
    #(parameter BufferWidth = 2)();
    
    reg clk, aclr, sclr;
    reg EN;

    wire [BufferWidth-1:0] Pointer;

    Pointer #(.BufferWidth(BufferWidth)) dut
            (.clk(clk), .aclr(aclr), .sclr(sclr), .EN(EN), .Pointer(Pointer));

    initial begin
        clk = 1;
        aclr = 1;
        sclr = 0;
        EN = 0;
        #1
        aclr = 0;
        EN = 1;
        #10
        EN = 0;
        #2
        aclr = 0;
        EN = 1;
        #4
        sclr = 1;

    end

    always #1 clk = ~clk;
	 

endmodule
