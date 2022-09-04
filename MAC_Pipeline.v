module MAC_Pipeline
    #(  parameter DataInWidth = 32,
        parameter DataOutWidth = 64,
        parameter MUL_Pipeline_Stages = 5)
    ( clk, rst, NOPIn, NOPOut, W_Data, I_Data, O_Data, DataOut);
    input clk, rst, NOPIn;
    input [DataInWidth-1:0] W_Data, I_Data, O_Data;
        
    output NOPOut;
    output [DataInWidth-1:0] DataOut;
    
    wire [DataOutWidth-1:0] MulResult;
    wire [DataInWidth-1:0] O_Data_Pipeline_Out;
    //32-bit mul
    Mul MulPipelineUnit(
        .aclr(rst),
        .clock(clk),
        .dataa(W_Data),
        .datab(I_Data),
        .result(MulResult));
    //32-bit add
    Add AddUnit(
        .dataa(O_Data_Pipeline_Out),
        .datab(MulResult[DataInWidth-1:0]),
        .result(DataOut));

    NOPPipeline #(.stages(MUL_Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .aclr(rst),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));

    OutputDataPipeline #(.DataOutputWidth(DataOutWidth), .Stages(MUL_Pipeline_Stages)) OutputDataPipelineUnit
        (.clk(clk), 
        .aclr(rst), 
        .DataIn(O_Data), 
        .DataOut(O_Data_Pipeline_Out));

endmodule
