module MAC_Pipeline
    #(  parameter DataWidth = 32,
        parameter MUL_Pipeline_Stages = 5,
        parameter ADD_Pipeline_Stages = 7,
        parameter Pipeline_Stages = MUL_Pipeline_Stages + ADD_Pipeline_Stages)
    ( clk, rst, NOPIn, NOPOut, W_Data, I_Data, O_Data, DataOut, MulResult, O_Data_Pipeline_Out);
    input clk, rst, NOPIn;
    input [DataWidth-1:0] W_Data, I_Data, O_Data;
        
    output NOPOut;
    output [DataWidth-1:0] DataOut;
    
    output [DataWidth-1:0] MulResult;
    output [DataWidth-1:0] O_Data_Pipeline_Out;
    //32-bit FP mul (5 Stages)
    FP_MUL FP_MulPipelineUnit(
        .aclr(rst),
        .clock(clk),
        .dataa(W_Data),
        .datab(I_Data),
        .result(MulResult));
    //32-bit FP add (7 Stages)
    FP_ADD FP_AddUnit(
        .aclr(rst),
        .clock(clk),
        .dataa(MulResult),
        .datab(O_Data_Pipeline_Out),
        .result(DataOut));

    NOPPipeline #(.Stages(Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .aclr(rst),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));

    OutputDataPipeline #(.DataWidth(DataWidth), .Stages(MUL_Pipeline_Stages)) OutputDataPipelineUnit
        (.clk(clk),
        .aclr(rst), 
        .DataIn(O_Data),
        .DataOut(O_Data_Pipeline_Out));

endmodule
