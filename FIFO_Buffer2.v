//for output data
module FIFO_Buffer2
        #(      parameter DataWidth = 32,
                parameter BufferWidth = 2,
                parameter BufferSize = 4)
        (clk, aclr, Pop2, Push, DataIn,
        Full, ReadyM, DataOut2);

        input clk, aclr;
        input Pop2, Push;
        input [DataWidth-1:0] DataIn;

        output Full;
        output [BufferSize-1:0] ReadyM; 
        output [DataWidth-1:0] DataOut2;

        wire [BufferWidth-1:0] W_Addr, R_Addr2;
        wire RoundM;

        wire [BufferSize-1:0] Valid;

        Buffer #(.DataWidth(DataWidth), .BufferSize(BufferSize), .BufferWidth(BufferWidth))
                buffer( .clk(clk), .aclr(aclr), .EN(Push), .W_Addr(W_Addr), .R_Addr2(R_Addr2), .DataIn(DataIn), 
                        .DataOut1(), .DataOut2(DataOut2));

        Pointer #(.BufferWidth(BufferWidth))
                TP( .clk(clk), .aclr(aclr), .EN(Push), .Pointer(W_Addr));

        Pointer #(.BufferWidth(BufferWidth))
                HPM( .clk(clk), .aclr(aclr), .EN(Pop2), .Pointer(R_Addr2));

        Round #(.BufferWidth(BufferWidth))
                RoundMUnit(.clk(clk), .aclr(aclr), .Push(Push), .Pop(Pop2), .W_Addr(W_Addr), .R_Addr(R_Addr2), .Round(RoundM));

        Ready #(.BufferWidth(BufferWidth), .BufferSize(BufferSize), .PseudoBufferWidth(BufferWidth+1), .PseudoBufferSize(BufferSize+BufferSize))
                ReadyMUnit(.W_Addr(W_Addr), .R_Addr(R_Addr2), .Round(RoundM), .Ready(ReadyM));

        genvar index;
        generate
                for(index = 0; index < BufferSize; index = index + 1) begin: ValidLogic
                assign Valid[index] = ReadyM[index];       
                end
        endgenerate

        assign Full = Valid[0] & Valid[1] & Valid[2] & Valid[3];
                
endmodule
