module OutputDataPipeline_tb
    #(  parameter DataWidth = 32,
        parameter Stages = 5)();

    reg clk, aclr;
    reg [DataWidth-1:0] DataIn;
    wire [DataWidth-1:0] DataOut;

    OutputDataPipeline #(.DataWidth(DataWidth), .Stages(Stages))
    dut (.clk(clk), .aclr(aclr), .DataIn(DataIn), .DataOut(DataOut));

        
    initial begin
        clk = 1;
        aclr = 1;
        DataIn = 0; 
        #1
        aclr = 0;
        DataIn = 32'h4170_0000; //15
        #2
        DataIn = 32'h4080_0000;
        #2
        DataIn = 32'h4220_0000;
    end
    
    always #1 clk = ~clk;

endmodule
