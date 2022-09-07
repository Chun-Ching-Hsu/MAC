//have some problem when round = 1
//same distance means same pattern
//and the shift operation should be rotate left shift

module Ready
    #(  parameter BufferWidth = 2,
        parameter BufferSize = 4,
        parameter PseudoBufferWidth = 3,
        parameter PseudoBufferSize = 8)
    (W_Addr, R_Addr, Round, Ready);
    input [BufferWidth-1:0] W_Addr, R_Addr;
    input Round;

    wire [PseudoBufferWidth-1:0] Pseudo_W_Addr = Round ? W_Addr+4 : W_Addr ;
    wire [PseudoBufferWidth-1:0] Distance = Pseudo_W_Addr - R_Addr;
    reg [PseudoBufferSize-1:0] Pattern;
    reg [PseudoBufferSize-1:0] TmpReady;
    
    output reg [BufferSize-1:0] Ready;
    
    always @(*)begin
        case(Distance)
            3'b 000: Pattern = 4'b 0000;
            3'b 001: Pattern = 4'b 0001;
            3'b 010: Pattern = 4'b 0011;
            3'b 011: Pattern = 4'b 0111;
            3'b 100: Pattern = 4'b 1111;
            default: Pattern = 4'b 0000;
        endcase
        TmpReady = Pattern << R_Addr;
        if (Round) begin
            //Circular Shift    
            case(R_Addr)
                2'b 00: Ready = TmpReady[3:0];
                2'b 01: Ready = {TmpReady[3:1],TmpReady[4]};
                2'b 10: Ready = {TmpReady[3:2],TmpReady[5:4]};
                2'b 11: Ready = {TmpReady[3],TmpReady[6:4]};
                default: Ready = 4'b 0000;
            endcase
        end
        else begin
            Ready = TmpReady;
        end
    end
endmodule