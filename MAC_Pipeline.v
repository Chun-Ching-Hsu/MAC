module MAC_Pipeline
    #(  parameter DataWidth = 32,
        parameter MUL_Pipeline_Stages = 5,
        parameter ADD_Pipeline_Stages = 7,
        parameter Pipeline_Stages = MUL_Pipeline_Stages + ADD_Pipeline_Stages)
    ( clk, aclr, NOPIn, NOPOut, W_Data, I_Data, O_Data, DataOut);
    input clk, aclr, NOPIn;
    input [DataWidth-1:0] W_Data, I_Data, O_Data;
        
    output NOPOut;
    output [DataWidth-1:0] DataOut;
    
    wire [DataWidth-1:0] MulResult;
    wire [DataWidth-1:0] O_Data_Pipeline_Out;
    //32-bit FP mul (5 Stages)
    FP_MUL FP_MulPipelineUnit(
        .aclr(aclr),
        .clock(clk),
        .dataa(W_Data),
        .datab(I_Data),
        .result(MulResult));
    //32-bit FP add (7 Stages)
    FP_ADD FP_AddUnit(
        .aclr(aclr),
        .clock(clk),
        .dataa(MulResult),
        .datab(O_Data_Pipeline_Out),
        .result(DataOut));

    NOPPipeline #(.Stages(Pipeline_Stages)) NOPPipelineUnit
        (.clk(clk), 
        .aclr(aclr),
        .NOPIn(NOPIn), 
        .NOPOut(NOPOut));

    OutputDataPipeline #(.DataWidth(DataWidth), .Stages(MUL_Pipeline_Stages)) OutputDataPipelineUnit
        (.clk(clk),
        .aclr(aclr), 
        .DataIn(O_Data),
        .DataOut(O_Data_Pipeline_Out));

endmodule
