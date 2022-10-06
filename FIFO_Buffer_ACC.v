//for ACC data
module FIFO_Buffer_ACC
        #(parameter DataWidth = 32)
	(clk, aclr, Pop, Push, DataIn, Empty, Full, DataOut);

        parameter BufferWidth = 2;
        parameter BufferSize = 4;

        input clk, aclr;
        input Pop, Push;
        input [DataWidth-1:0] DataIn;

        output Empty, Full;
        output [DataWidth-1:0] DataOut;

        wire [BufferWidth-1:0] W_Addr, R_Addr;
        wire Round;
        wire [BufferSize-1:0] Valid;

        Buffer #(.DataWidth(DataWidth), .BufferSize(BufferSize), .BufferWidth(BufferWidth))
                buffer( .clk(clk), .aclr(aclr), .EN(Push), .DataIn(DataIn), 
                .DataOut1(DataOut), .W_Addr(W_Addr), .R_Addr1(R_Addr));

        Pointer #(.BufferWidth(BufferWidth))
                TP( .clk(clk), .aclr(aclr), .EN(Push), .Pointer(W_Addr));

        Pointer #(.BufferWidth(BufferWidth))
                HP( .clk(clk), .aclr(aclr), .EN(Pop), .Pointer(R_Addr));

        Round #(.BufferWidth(BufferWidth), .BufferSize(BufferSize))
                RoundMUnit(.clk(clk), .aclr(aclr), .Push(Push), .Pop(Pop), .W_Addr(W_Addr), .R_Addr(R_Addr), .Round(Round));

        Ready_4 ReadyUnit
                (.W_Addr(W_Addr), .R_Addr(R_Addr), .Round(Round), .Ready(Valid));

        assign Full = Valid[0] & Valid[1] & Valid[2] & Valid[3];
        assign Empty = ~Valid[0] & ~Valid[1] & ~Valid[2] & ~Valid[3];

endmodule
