`timescale 1ps/1ps
module NOPPipeline_tb
    #(parameter Stages = 7)();

	reg clk, aclr;
	reg NOPIn;
	wire NOPOut;

	NOPPipeline #(.Stages(Stages)) dut (
        .clk(clk), .aclr(aclr), .NOPIn(NOPIn), .NOPOut(NOPOut));
	
    initial begin
        clk = 1;
        aclr = 1;
        NOPIn = 1;
        #1
        aclr = 0;
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
