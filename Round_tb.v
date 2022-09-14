`timescale 1ps/1ps
module Round_tb 
    #(  parameter BufferWidth = 4)();

    reg clk, aclr, Push, Pop;
    reg [BufferWidth-1:0] W_Addr, R_Addr;
    wire Round;

    Round #(.BufferWidth(BufferWidth)) round
    (.clk(clk), .aclr(aclr), .Push(Push), .Pop(Pop), .W_Addr(W_Addr), .R_Addr(R_Addr), .Round(Round));

    initial begin
        clk = 1;
        aclr = 1;
        Push = 0;
        Pop = 0;
        W_Addr = 0;
        R_Addr = 0;
        $display("Answer: 0");
        #1
        aclr = 0;
        Push = 1;
        Pop = 0;
        W_Addr = 3;
        R_Addr = 0;
        $display("Answer: 0");
        #2
        Push = 0;
        Pop = 1;
        W_Addr = 1;
        R_Addr = 3;
        $display("Answer: 1");
        #2
        Push = 1;
        Pop = 1;
        W_Addr = 2;
        R_Addr = 0;
        $display("Answer: 1");
        #2
        Push = 1;
        Pop = 1;
        W_Addr = 3;
        R_Addr = 1;
        $display("Answer: 0");
        #2
        Push = 1;
        Pop = 0;
        W_Addr = 0;
        R_Addr = 2;
        $display("Answer: 1");
    end

    always #1 clk = ~clk;
	 
	always #2 begin
		$monitor("%0d ns, clk:%b, \n Push: %b, Pop: %b, \n W_Addr: %d, R_Addr: %d, Round: %b",
         $stime, clk, Push, Pop, W_Addr, R_Addr, Round);
	end

endmodule
