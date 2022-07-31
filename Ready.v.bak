module Ready
    #(  parameter BufferWidth = 2,
        parameter BufferSize = 4,
        parameter PseudoBufferWidth = 3,
        parameter PseudoBufferSize = 8)
    (TP,HP,Round,Ready);
    input [BufferWidth-1] TP,HP;
    input Round;

    wire PseudoTP = Round ? TP+4 : TP ;
    wire [PseudoBufferWidth-1:0] Distance = PseudoTP - HP;
    reg [BufferSize-1] TmpReady;
    
    output [BufferSize-1] Ready;
    
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
    assign Ready = TmpReady << HP ;
endmodule