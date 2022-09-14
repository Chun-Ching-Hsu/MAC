`timescale 1ps/1ps
module MAC_Pipeline_tb    
    #(  parameter DataWidth = 32,
        parameter MUL_Pipeline_Stages = 5,
        parameter ADD_Pipeline_Stages = 7,
        parameter Pipeline_Stages = MUL_Pipeline_Stages + ADD_Pipeline_Stages)();

    reg clk, aclr, NOPIn;
    reg [DataWidth-1:0] W_Data, I_Data, O_Data;
        
    wire NOPOut;
    wire [DataWidth-1:0] DataOut;
    wire [DataWidth-1:0] MulResult;
    wire [DataWidth-1:0] O_Data_Pipeline_Out;

    MAC_Pipeline #(.DataWidth(DataWidth), .MUL_Pipeline_Stages(MUL_Pipeline_Stages), 
                .ADD_Pipeline_Stages(ADD_Pipeline_Stages), .Pipeline_Stages(Pipeline_Stages))
    dut (.clk(clk), .aclr(aclr), .NOPIn(NOPIn), .NOPOut(NOPOut), 
        .W_Data(W_Data), .I_Data(I_Data), .O_Data(O_Data), .DataOut(DataOut));
    
    initial begin
        clk = 1;
        aclr = 1;
        NOPIn = 1;
        W_Data = 0;
        I_Data = 0;
        O_Data = 0;   
        #1
        aclr = 0;
        NOPIn = 0;
        W_Data = 32'h4170_0000; //15
        I_Data = 32'h4080_0000; //4
        O_Data = 32'h4220_0000; //40
        #2
        W_Data = 32'h42c80000; //100
        I_Data = 32'h43480000; //200
        O_Data = 32'h447a0000; //1000
        #2
        NOPIn = 1;
    end
    
    always #1 clk = ~clk;

endmodule

