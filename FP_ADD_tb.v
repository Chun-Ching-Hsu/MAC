`timescale 1ps/1ps
module FP_ADD_tb();

	reg	aclr;
	reg	clock;
	reg	[31:0]  dataa;
	reg	[31:0]  datab;
	wire [31:0]  result;

    FP_ADD dut(.aclr(aclr), .clock(clock), .dataa(dataa), .datab(datab), .result(result));

    initial begin
        clock = 1;
        aclr = 1;
        dataa = 0;
        datab = 0;           
        #1
        aclr = 0;
        dataa = 32'h4170_0000;
        datab = 32'h4080_0000;    
    end
    
    always #1 clock = ~clock;

endmodule
