`timescale 1ps/1ps
module Buffer_tb
    #(  parameter DataWidth = 8,
        parameter BufferSize = 4,
        parameter BufferWidth = 2 )();

    reg clk, aclr, EN;
    reg [BufferWidth-1:0] W_Addr, R_Addr1, R_Addr2;
    reg [DataWidth-1:0] DataIn;

    wire [DataWidth-1:0] DataOut1, DataOut2;

    Buffer #(.DataWidth(DataWidth), .BufferSize(BufferSize), .BufferWidth(BufferWidth)) dut
        (.clk(clk), .aclr(aclr), .EN(EN), .DataIn(DataIn), 
        .DataOut1(DataOut1), .DataOut2(DataOut2), .W_Addr(W_Addr), .R_Addr1(R_Addr1), .R_Addr2(R_Addr2));

    initial begin
        clk = 1;
        aclr = 1;
        EN = 0;
        DataIn = 0;
        W_Addr = 0;
        R_Addr1 = 0;
        R_Addr2 = 0;
        #3
        aclr = 0;
        EN = 1;
        W_Addr = 0;
        R_Addr1 = 0;
        R_Addr2 = 0;
        #2
        EN = 1;
        W_Addr = 1;
        R_Addr1 = 0;
        R_Addr2 = 0;
        #2
        EN = 1;
        W_Addr = 2;
        R_Addr1 = 1;
        R_Addr2 = 0;
        #2
        EN = 1;
        W_Addr = 3;
        R_Addr1 = 2;
        R_Addr2 = 1;
        #2
        aclr = 1;
        
    end

    always #1 clk = ~clk;
	always #2 DataIn = DataIn + 1;

endmodule
