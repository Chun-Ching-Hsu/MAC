
module PE
    #(  parameter DataWidth = 32,
        parameter MUL_Pipeline_Stages = 5,
        parameter ADD_Pipeline_Stages = 7,
        parameter Pipeline_Stages = MUL_Pipeline_Stages + ADD_Pipeline_Stages)
    (   clk, aclr,
        W_DataInValid, W_DataInRdy, W_DataIn,
        W_DataOut, W_DataOutValid, W_DataOutRdy,
        I_DataInValid, I_DataInRdy, I_DataIn,
        I_DataOut, I_DataOutValid, I_DataOutRdy,
        O_DataInValid, O_DataInRdy, O_DataIn,
        O_DataOut, O_DataOutValid, O_DataOutRdy);

    parameter BufferWidth = 4;
    parameter BufferSize = 16;
	
    input [DataWidth-1:0] W_DataIn, I_DataIn, O_DataIn;
    input W_DataInValid, W_DataOutRdy;
    input I_DataInValid, I_DataOutRdy;
    input O_DataInValid, O_DataOutRdy; //O_DataOutRdy is used to peek the next PE
    
    input clk;
    input aclr;
    
    wire [BufferWidth-1:0] HPM;

    wire W_Rec_Handshaking,W_Send_Handshaking;
    wire I_Rec_Handshaking,I_Send_Handshaking;
    wire O_Rec_Handshaking;
    
    wire [BufferSize-1:0] ReadyM, W_ReadyM, I_ReadyM, O_ReadyM;
    
    wire [BufferSize-1:0] W_Valid, I_Valid, O_Valid; 

    wire W_Full, I_Full, O_Full;
    wire W_Empty, I_Empty;

    wire [DataWidth-1:0] W_DataOut2, I_DataOut2, O_DataOut2;

    output  [DataWidth-1:0] W_DataOut,I_DataOut;
    output  [DataWidth-1:0] O_DataOut;
    output  W_DataInRdy,W_DataOutValid;
    output  I_DataInRdy,I_DataOutValid;
    output  O_DataInRdy,O_DataOutValid;

    wire NOPIn, NOPOut;

    FIFO_Buffer #(.DataWidth(DataWidth))
                    W_Buffer(.clk(clk), .aclr(aclr), .Pop1(W_Send_Handshaking), .Pop2(~NOPIn), .Push(W_Rec_Handshaking), .DataIn(W_DataIn),
                            .Empty(W_Empty), .Full(W_Full), .ReadyM(W_ReadyM), .DataOut1(W_DataOut), .DataOut2(W_DataOut2));

    FIFO_Buffer #(.DataWidth(DataWidth))
                    I_Buffer(.clk(clk), .aclr(aclr), .Pop1(I_Send_Handshaking), .Pop2(~NOPIn), .Push(I_Rec_Handshaking), .DataIn(I_DataIn),
                            .Empty(I_Empty), .Full(I_Full), .ReadyM(I_ReadyM), .DataOut1(I_DataOut), .DataOut2(I_DataOut2));

    FIFO_Buffer2    #(.DataWidth(DataWidth))
                    O_Buffer(.clk(clk), .aclr(aclr), .Pop2(~NOPIn), .Push(O_Rec_Handshaking), .DataIn(O_DataIn),
                            .Full(O_Full), .ReadyM(O_ReadyM), .DataOut2(O_DataOut2));

    MAC_Pipeline    #(.DataWidth(DataWidth), .MUL_Pipeline_Stages(MUL_Pipeline_Stages), 
                        .ADD_Pipeline_Stages(ADD_Pipeline_Stages), .Pipeline_Stages(Pipeline_Stages))
                    MAC_Unit(.clk(clk), .aclr(aclr), .NOPIn(NOPIn), .NOPOut(NOPOut), 
                        .W_Data(W_DataOut2), .I_Data(I_DataOut2), .O_Data(O_DataOut2), .DataOut(O_DataOut));

    Pointer #(.BufferWidth(BufferWidth))
            HPMUnit( .clk(clk), .aclr(aclr), .EN(~NOPIn), .Pointer(HPM));

    assign ReadyM = W_ReadyM & I_ReadyM & O_ReadyM;

    assign W_DataOutValid = ~W_Empty;
    assign I_DataOutValid = ~I_Empty;

    assign W_DataInRdy = ~W_Full;
    assign I_DataInRdy = ~I_Full;
    assign O_DataInRdy = ~O_Full;

    assign W_Rec_Handshaking = W_DataInRdy & W_DataInValid;
    assign I_Rec_Handshaking = I_DataInRdy & I_DataInValid;
    assign O_Rec_Handshaking = O_DataInRdy & O_DataInValid;

    assign W_Send_Handshaking = W_DataOutValid & W_DataOutRdy;
    assign I_Send_Handshaking = I_DataOutValid & I_DataOutRdy;

    assign NOPIn = ~(ReadyM[HPM] & O_DataOutRdy);

    assign O_DataOutValid = ~NOPOut;

    
endmodule