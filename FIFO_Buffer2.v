//for output data
module FIFO_Buffer2
        #(parameter DataWidth = 32)
        (clk, aclr, Pop2, Push, DataIn,
        Full, ReadyM, DataOut2, 
        Test_Valid, Test_W_Addr, Test_R_Addr2);

        parameter BufferWidth = 4;
        parameter BufferSize = 16;

        input clk, aclr;
        input Pop2, Push;
        input [DataWidth-1:0] DataIn;

        output Full;
        output [BufferSize-1:0] ReadyM; 
        output [DataWidth-1:0] DataOut2;

        wire [BufferWidth-1:0] W_Addr, R_Addr2;
        wire RoundM;

        wire [BufferSize-1:0] Valid;
        
        //test
        output [BufferSize-1:0] Test_Valid;
        assign Test_Valid = Valid;
        output [BufferWidth-1:0] Test_W_Addr, Test_R_Addr2;
        assign Test_W_Addr = W_Addr;
        assign Test_R_Addr2 = R_Addr2;

        Buffer #(.DataWidth(DataWidth), .BufferSize(BufferSize), .BufferWidth(BufferWidth))
                buffer( .clk(clk), .aclr(aclr), .EN(Push), .W_Addr(W_Addr), .R_Addr2(R_Addr2), .DataIn(DataIn), 
                        .DataOut2(DataOut2));

        Pointer #(.BufferWidth(BufferWidth))
                TP( .clk(clk), .aclr(aclr), .EN(Push), .Pointer(W_Addr));

        Pointer #(.BufferWidth(BufferWidth))
                HPM( .clk(clk), .aclr(aclr), .EN(Pop2), .Pointer(R_Addr2));

        Round #(.BufferWidth(BufferWidth), .BufferSize(BufferSize))
                RoundMUnit(.clk(clk), .aclr(aclr), .Push(Push), .Pop(Pop2), .W_Addr(W_Addr), .R_Addr(R_Addr2), .Round(RoundM));

        Ready_16 ReadyMUnit(.W_Addr(W_Addr), .R_Addr(R_Addr2), .Round(RoundM), .Ready(ReadyM));

        genvar index;
        generate
                for(index = 0; index < BufferSize; index = index + 1) begin: ValidLogic
                assign Valid[index] = ReadyM[index];       
                end
        endgenerate

        assign Full =   Valid[0] & Valid[1] & Valid[2] & Valid[3] & 
                        Valid[4] & Valid[5] & Valid[6] & Valid[7] & 
                        Valid[8] & Valid[9] & Valid[10] & Valid[11] &
                        Valid[12] & Valid[13] & Valid[14] & Valid[15];
                
endmodule
