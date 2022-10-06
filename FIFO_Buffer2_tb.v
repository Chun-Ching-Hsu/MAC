`timescale 1ps/1ps
module FIFO_Buffer2_tb
    #(  parameter DataWidth = 32)();
        parameter BufferWidth = 4;
        parameter BufferSize = 16;

        reg clk, aclr;
        reg Pop2, Push;
        reg [DataWidth-1:0] DataIn;

        wire Full;
        wire [BufferSize-1:0] ReadyM;
        wire [DataWidth-1:0] DataOut2;

        //test
        wire [BufferSize-1:0] Test_Valid;
        wire [BufferWidth-1:0] Test_W_Addr, Test_R_Addr2;

    FIFO_Buffer2 #(.DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize)) 
        dut (.clk(clk), .aclr(aclr), .Pop2(Pop2), .Push(Push), .DataIn(DataIn),
             .Full(Full), .ReadyM(ReadyM), .DataOut2(DataOut2),
             .Test_Valid(Test_Valid), .Test_W_Addr(Test_W_Addr), .Test_R_Addr2(Test_R_Addr2));

    initial begin
        clk = 1;
        aclr = 1;
        DataIn = 0;
        Push = 0;
        Pop2 = 0;
        #1
        aclr = 0;
        
        Push = 1;
        Pop2 = 0;
        #16
        Push = 1;
        Pop2 = 0;
        #2
        Push = 1;
        Pop2 = 0;
        #2
        Push = 1;
        Pop2 = 1;
        #2
        Push = 1;
        Pop2 = 1;
        #16
        Push = 0;
        Pop2 = 0;
        #8
        Push = 0;
        Pop2 = 0;   
    end

    always #1 clk = ~clk;
	always #2 DataIn = DataIn + 1;
        
	always #2 begin

	end
endmodule
