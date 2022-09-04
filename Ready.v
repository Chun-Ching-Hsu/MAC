module Ready
    #(  parameter BufferWidth = 2,
        parameter BufferSize = 4,
        parameter PseudoBufferWidth = 3,
        parameter PseudoBufferSize = 8)
    (W_Addr, R_Addr, Round, Ready);
    input [BufferWidth-1:0] W_Addr, R_Addr;
    input Round;

    wire Pseudo_W_Addr = Round ? W_Addr+4 : W_Addr ;
    wire [PseudoBufferWidth-1:0] Distance = Pseudo_W_Addr - R_Addr;
    reg [BufferSize-1:0] TmpReady;
    
    output [BufferSize-1:0] Ready;
    
    always @(*)begin
        case(Distance)
            3'b 000: TmpReady = 4'b 0000;
            3'b 001: TmpReady = 4'b 0001;
            3'b 010: TmpReady = 4'b 0010;
            3'b 011: TmpReady = 4'b 0011;
            3'b 100: TmpReady = 4'b 0100;
            default : TmpReady = 4'b 0000;
        endcase
    end
    assign Ready = TmpReady << R_Addr ;
endmodule