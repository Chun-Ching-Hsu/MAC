`timescale 100ns/100ns
module Add_tb();
//	reg	  aclr;
//	reg	  clken;
//	reg	  clock;
	reg	[7:0]  dataa;
	reg	[7:0]  datab;
	wire [7:0]  result;

    Add dut(
//        .aclr(aclr),
//        .clock(clock),
        .dataa(dataa),
        .datab(datab),
        .result(result));
    initial begin
//        aclr = 1;
//        clock = 1;
        dataa = 0;
        datab = 0;
        #2
//        aclr = 0;
        dataa = 5;
        datab = 10;
        #2
        dataa = 11;
        datab = 10;
        #2
        dataa = 3;
        datab = 10;
    end

//    always #1 clock = ~clock;
    always #2 begin
//        $monitor("%0d ns, dataa: %d, datab: %d, result: %d", $stime, dataa, datab, result);
		  $monitor("%0d ns, dataa: %d, datab: %d, result: %d", $stime, dataa, datab, result);
    end
endmodule
