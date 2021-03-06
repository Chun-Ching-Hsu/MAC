module Buffer
    #(  parameter DataWidth = 8,
        parameter BufferSize = 4,
        parameter BufferWidth = 2 )
    (clk, reset, EN, DataIn, DataOut1, DataOut2, W_Addr, R_Addr1, R_Addr2 );
    input clk;
    input reset;
    input EN;
    input [BufferWidth-1:0] W_Addr,R_Addr1,R_Addr2;
    input [DataWidth-1:0] DataIn;
    //測試是否ok
    reg [DataWidth-1:0] Buffer [0:BufferSize-1];

    output [DataWidth-1:0] DataOut1,DataOut2;
    
    integer index;

    always @(posedge clk)begin
        if(reset)
            for(index = 0; index < BufferSize; index = index + 1) begin: resetBuf
                Buffer[index] <= 0;
            end
        else if(EN)begin
            Buffer[W_Addr] <= DataIn;
        end
    end

    assign DataOut1 = Buffer[R_Addr1];
    assign DataOut2 = Buffer[R_Addr2];


endmodule