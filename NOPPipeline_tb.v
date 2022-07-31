`timescale 100ns/100ns
module NOPPipeline_tb();

	reg clk, sclr;
	reg NOPIn;
	wire NOPOut;

	NOPPipeline #(.stages(7)) dut (
        .clk(clk), .sclr(sclr), .NOPIn(NOPIn), .NOPOut(NOPOut));
	
    initial begin
        clk = 1;
        sclr = 1;
        NOPIn = 1;
        #2
        sclr = 0;
        NOPIn = 0;
        #2
        NOPIn = 1;
        #4
        NOPIn = 0;        
    end

    always #1 clk = ~clk;
    
    always #2 begin
        $monitor("%0d ns, NOPIn: %b, NOPOut: %b", $stime, NOPIn, NOPOut);
    end

endmodule
