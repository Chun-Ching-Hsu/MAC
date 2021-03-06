
module PE
    #(  parameter DataInWidth = 8,
        parameter DataOutWidth = 16,
        parameter BufferWidth = 2,
        parameter BufferSize = 4,
        parameter IndexSize = 4  )
    (   clk, reset,
        W_DataInValid,W_DataInRdy,W_DataIn,
        W_DataOut,W_DataOutValid,W_DataOutRdy,
        I_DataInValid,I_DataInRdy,I_DataIn,
        I_DataOut,I_DataOutValid,I_DataOutRdy,
        O_NOPIn,O_DataInRdy,O_DataIn,
        O_DataOut,O_NOPOut,O_DataOutRdy );

    input [DataInWidth-1:0] W_DataIn,I_DataIn,O_DataIn;
    input W_DataInValid,W_DataOutRdy;
    input I_DataInValid,I_DataOutRdy;
    input O_NOPIn,O_DataOutRdy; //O_DataOutRdy is used to peek the next PE
    
    input clk;
    input reset;
    
    wire [BufferWidth-1:0] W_TP,I_TP,O_TP,W_HPP,I_HPP,HPM;
    wire W_RoundP,I_RoundP,W_RoundM,I_RoundM,O_RoundM;
    wire W_Rec_Handshanking,W_Send_Handshaking;
    wire I_Rec_Handshanking,I_Send_Handshaking;
    
    wire [BufferSize-1:0] W_ReadyP,I_ReadyP;
    wire [BufferSize-1:0] W_ReadyM,I_ReadyM,O_ReadyM;
    wire [BufferSize-1:0] ReadyM;
    
    wire [BufferSize-1:0] W_Valid,I_Valid,O_Valid; 

    wire W_Full,I_Full,O_Full;
    wire W_Empty,I_Empty;

    wire NOP;

    wire [DataInWidth-1:0] W_DataOut2,I_DataOut2,O_DataOut2;

    output  [DataInWidth-1:0] W_DataOut,I_DataOut;
    output  [DataInWidth-1:0] O_DataOut;
    output  W_DataInRdy,W_DataOutValid;
    output  I_DataInRdy,I_DataOutValid;
    output  O_DataInRdy,O_NOPOut;


    Round W_RoundPBlock(
        .TP(W_TP),
        .HP(W_HPP),
        .Round(W_RoundP),
        .Rec_Handshanking(W_Rec_Handshanking),
        .Send_Handshaking(W_Send_Handshaking),
        .clk(clk),
        .reset(reset)
    );
    Round I_RoundPBlock(
        .TP(I_TP),
        .HP(I_HPP),
        .Round(I_RoundP),
        .Rec_Handshanking(I_Rec_Handshanking),
        .Send_Handshaking(I_Send_Handshaking),
        .clk(clk),
        .reset(reset)
    );
    Round W_RoundMBlock(
        .TP(W_TP),
        .HP(HPM),
        .Round(W_RoundM),
        .Rec_Handshanking(W_Rec_Handshanking),
        .Send_Handshaking(ReadyM[HPM]),
        .clk(clk),
        .reset(reset)
    );
    Round I_RoundMBlock(
        .TP(I_TP),
        .HP(HPM),
        .Round(I_RoundM),
        .Rec_Handshanking(I_Rec_Handshanking),
        .Send_Handshaking(ReadyM[HPM]),
        .clk(clk),
        .reset(reset)
    );
    Round O_RoundMBlock(
        .TP(O_TP),
        .HP(HPM),
        .Round(O_RoundM),
        .Rec_Handshanking(O_Rec_Handshanking),
        .Send_Handshaking(ReadyM[HPM]),
        .clk(clk),
        .reset(reset)
    );

    Ready W_ReadyPBlock(
        .TP(W_TP),
        .HP(W_HPP),
        .Round(W_RoundP),
        .Ready(W_ReadyP)
    );
    Ready I_ReadyPBlock(
        .TP(I_TP),
        .HP(I_HPP),
        .Round(I_RoundP),
        .Ready(I_ReadyP)
    );
    Ready W_ReadyMBlock(
        .TP(W_TP),
        .HP(HPM),
        .Round(W_RoundM),
        .Ready(W_ReadyM)
    );
    Ready I_ReadyMBlock(
        .TP(I_TP),
        .HP(HPM),
        .Round(I_RoundM),
        .Ready(I_ReadyM)
    );
    Ready O_ReadyMBlock(
        .TP(O_TP),
        .HP(HPM),
        .Round(O_RoundM),
        .Ready(O_ReadyM)
    );

    Pointer W_HPPBlock(
        .EN(W_Send_Handshaking),
        .Pointer(W_HPP),
        .clk(clk),
        .reset(reset)
    );
    Pointer I_HPPBlock(
        .EN(I_Send_Handshaking),
        .Pointer(I_HPP),
        .clk(clk),
        .reset(reset)
    );
    Pointer HPMBlock(
        .EN(ReadyM[HPM] & O_DataOutRdy),
        .Pointer(HPM),
        .clk(clk),
        .reset(reset)
    );
    Pointer W_TPBlock(
        .EN(W_Rec_Handshanking),
        .Pointer(W_TP),
        .clk(clk),
        .reset(reset)
    );
    Pointer I_TPBlock(
        .EN(I_Rec_Handshanking),
        .Pointer(I_TP),
        .clk(clk),
        .reset(reset)
    );
    Pointer O_TPBlock(       
        .EN(O_Rec_Handshanking),
        .Pointer(O_TP),
        .clk(clk),
        .reset(reset)
    );

    Buffer W_Buffer(
        .clk(clk),
        .reset(reset),
        .EN(W_Rec_Handshanking),
        .DataIn(W_DataIn),
        .DataOut1(W_DataOut),
        .DataOut2(W_DataOut2),
        .W_Addr(W_TP),
        .R_Addr1(W_HPP),
        .R_Addr2(HPM)
    );
    Buffer I_Buffer(
        .clk(clk),
        .reset(reset),
        .EN(I_Rec_Handshanking),
        .DataIn(I_DataIn),
        .DataOut1(I_DataOut),
        .DataOut2(I_DataOut2),
        .W_Addr(I_TP),
        .R_Addr1(I_HPP),
        .R_Addr2(HPM)
    );
    Buffer O_Buffer(
        .clk(clk),
        .reset(reset),
        .EN(O_Rec_Handshanking),
        .DataIn(O_DataIn),
        .DataOut1(),
        .DataOut2(O_DataOut2),
        .W_Addr(O_TP),
        .R_Addr1(),
        .R_Addr2(HPM)
    );
/*
    MAC MACUnit(
        .clk(clk),
        .reset(reset),
        .NOPIn(NOP),
        .NOPOut(O_NOPOut),
        .W_Data(W_DataOut2),
        .I_Data(I_DataOut2),
        .O_Data(O_DataOut2),
        .DataOut(O_DataOut)
    );
*/
    wire [DataOutWidth-1:0] mul_result;
	//5 stages
	multiply multiply_pipeline(
		.aclr(reset),
		.clken(1'b0),
		.clock(clk),
		.dataa(W_DataOut2),
		.datab(I_DataOut2),
		.result(mul_result));
	// 2 stages	
	Add add_pipeline(
		.aclr(reset),
		.clken(1'b0),
		.clock(clk),
		.dataa(mul_result[DataInWidth-1:0]),
		.datab(O_DataOut2),
		.result(O_DataOut));

    NOPPipeline noppipeline(
        .clk(clk), 
        .sclr(reset), 
        .NOPIn(NOP), 
        .NOPOut(O_NOPOut));	

    assign ReadyM = W_ReadyM & I_ReadyM & O_ReadyM;
    
    // assign W_Valid = W_ReadyP | W_ReadyM;
    // assign I_Valid = I_ReadyM | I_ReadyP;
    // assign O_Valid = O_ReadyM;
    // ??????????????????
    //always@(posedge clk)begin
    //    for (index=0; index<IndexSize ; index = index + 1 )begin
    //        assign W_Valid[index] =  W_ReadyP[index] | W_ReadyM[index];
    //        assign I_Valid[i] = I_ReadyP[i] | ReadyM[i];
    //       assign O_Valid[i] = O_ReadyM[i];
    //    end
    //end

    genvar index;
    generate
        for(index = 0; index < IndexSize; index = index + 1) begin: ValidLogic
            assign W_Valid[index] =  W_ReadyP[index] | W_ReadyM[index];
            assign I_Valid[index] = I_ReadyP[index] | ReadyM[index];
            assign O_Valid[index] = O_ReadyM[index];        
        end
    endgenerate

    assign W_Full = W_Valid[0] & W_Valid[1] & W_Valid[2] & W_Valid[3];
    assign I_Full = I_Valid[0] & I_Valid[1] & I_Valid[2] & I_Valid[3]; 
    assign O_Full = O_Valid[0] & O_Valid[1] & O_Valid[2] & O_Valid[3]; 

    assign W_Empty = ~W_ReadyP[0] & ~W_ReadyP[1] & ~W_ReadyP[2] & ~W_ReadyP[3];
    assign I_Empty = ~I_ReadyP[0] & ~I_ReadyP[1] & ~I_ReadyP[2] & ~I_ReadyP[3];

    assign W_DataOutValid = ~W_Empty;
    assign I_DataOutValid = ~I_Empty;

    assign W_Rec_Handshanking = W_DataInRdy & W_DataInValid;
    assign I_Rec_Handshanking = I_DataInRdy & I_DataInValid;
    assign O_Rec_Handshanking = O_DataInRdy & O_NOPIn;

    assign W_Send_Handshaking = W_DataOutValid & W_DataOutRdy;
    assign I_Send_Handshaking = I_DataOutValid & I_DataOutRdy;

    assign W_DataInRdy = ~W_Full;
    assign I_DataInRdy = ~I_Full;
    assign O_DataInRdy = ~O_Full;

    assign NOP = ~(ReadyM[HPM] & O_DataOutRdy);

    
endmodule