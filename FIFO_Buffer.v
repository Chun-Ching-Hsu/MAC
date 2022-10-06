//for weight and input data
module FIFO_Buffer
        #(  parameter DataWidth = 32)
	(clk, aclr, Pop1, Pop2, Push, DataIn,
        Empty, Full, ReadyM, DataOut1, DataOut2,
        Test_Valid);

        parameter BufferWidth = 4;
        parameter BufferSize = 16;

        input clk, aclr;
        input Pop1, Pop2, Push;
        input [DataWidth-1:0] DataIn;

        output Empty, Full;
        output [BufferSize-1:0] ReadyM;
        output [DataWidth-1:0] DataOut1, DataOut2;

        wire [BufferWidth-1:0] W_Addr, R_Addr1, R_Addr2;
        wire RoundP, RoundM;
        wire [BufferSize-1:0] ReadyP;
        wire [BufferSize-1:0] Valid;

        //test
        output [BufferSize-1:0] Test_Valid;
        assign Test_Valid = Valid;


        Buffer #(.DataWidth(DataWidth), .BufferSize(BufferSize), .BufferWidth(BufferWidth))
                buffer( .clk(clk), .aclr(aclr), .EN(Push), .DataIn(DataIn), 
                .DataOut1(DataOut1), .DataOut2(DataOut2), .W_Addr(W_Addr), .R_Addr1(R_Addr1), .R_Addr2(R_Addr2));

        Pointer #(.BufferWidth(BufferWidth))
                TP( .clk(clk), .aclr(aclr), .EN(Push), .Pointer(W_Addr));

        Pointer #(.BufferWidth(BufferWidth))
                HPP( .clk(clk), .aclr(aclr), .EN(Pop1), .Pointer(R_Addr1));

        Pointer #(.BufferWidth(BufferWidth))
                HPM( .clk(clk), .aclr(aclr), .EN(Pop2), .Pointer(R_Addr2));

        Round #(.BufferWidth(BufferWidth), .BufferSize(BufferSize))
                RoundPUnit(.clk(clk), .aclr(aclr), .Push(Push), .Pop(Pop1), .W_Addr(W_Addr), .R_Addr(R_Addr1), .Round(RoundP));

        Round #(.BufferWidth(BufferWidth), .BufferSize(BufferSize))
                RoundMUnit(.clk(clk), .aclr(aclr), .Push(Push), .Pop(Pop2), .W_Addr(W_Addr), .R_Addr(R_Addr2), .Round(RoundM));

        Ready_16 ReadyPUnit(.W_Addr(W_Addr), .R_Addr(R_Addr1), .Round(RoundP), .Ready(ReadyP));

        Ready_16 ReadyMUnit(.W_Addr(W_Addr), .R_Addr(R_Addr2), .Round(RoundM), .Ready(ReadyM));
        
        genvar index;
        generate
                for(index = 0; index < BufferSize; index = index + 1) begin: ValidLogic
                assign Valid[index] =  ReadyP[index] | ReadyM[index];       
                end
        endgenerate

        assign Full =   Valid[0] & Valid[1] & Valid[2] & Valid[3] & 
                        Valid[4] & Valid[5] & Valid[6] & Valid[7] & 
                        Valid[8] & Valid[9] & Valid[10] & Valid[11] &
                        Valid[12] & Valid[13] & Valid[14] & Valid[15];
        assign Empty =  ~ReadyP[0] & ~ReadyP[1] & ~ReadyP[2] & ~ReadyP[3] &
                        ~ReadyP[4] & ~ReadyP[5] & ~ReadyP[6] & ~ReadyP[7] &
                        ~ReadyP[8] & ~ReadyP[9] & ~ReadyP[10] & ~ReadyP[11] &
                        ~ReadyP[12] & ~ReadyP[13] & ~ReadyP[14] & ~ReadyP[15];

endmodule
