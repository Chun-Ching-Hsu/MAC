module MAC_Pipeline
    #(  parameter DataInWidth = 8,
        parameter DataOutWidth = 16,
        parameter MUL_Pipeline_Stages = 5)
    ( clk, reset, NOPIn, NOPOut, W_Data, I_Data, O_Data, DataOut);
    input clk, reset, NOPIn;
    input [DataInWidth-1:0] W_Data, I_Data, O_Data;
        
    output NOPOut;
    output [DataInWidth-1:0] DataOut;
    
    wire [DataOutWidth-1:0] MulResult;
    wire [DataInWidth-1:0] O_Data_Pipeline_Out;

    Mul MulPipelineUnit(
        .aclr(reset),
        .clock(clk),
        .dataa(W_Data),
        .datab(I_Data),
        .result(MulResult));

    Add AddUnit(
        .dataa(O_Data_Pipeline_Out),
        .datab(MulResult[DataInWidth-1:0]),
        .result(DataOut));

    NOPPipeline #(.stages(MUL_Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .sclr(reset),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));

    OutputDataPipeline #(.DataOutputWidth(8), .Stages(MUL_Pipeline_Stages)) OutputDataPipelineUnit
        (.clk(clk), 
        .sclr(reset), 
        .DataIn(O_Data), 
        .DataOut(O_Data_Pipeline_Out));

endmodule
