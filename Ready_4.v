//have some problem when round = 1
//same distance means same pattern
//and the shift operation should be rotate left shift

module Ready_4
    (W_Addr, R_Addr, Round, Ready);

    parameter BufferWidth = 2;
    parameter BufferSize = 4;
    parameter PseudoBufferWidth = 3;
    parameter PseudoBufferSize = 8;

    input [BufferWidth-1:0] W_Addr, R_Addr;
    input Round;

    wire [PseudoBufferWidth-1:0] Pseudo_W_Addr = Round ? W_Addr+4 : W_Addr ;
    wire [PseudoBufferWidth-1:0] Distance = Pseudo_W_Addr - R_Addr;
    reg [PseudoBufferSize-1:0] Pattern;
    reg [PseudoBufferSize-1:0] TmpReady;
    
    output reg [BufferSize-1:0] Ready;
    
    always @(*)begin
        case(Distance)
            0: Pattern = 4'b 0000;
            1: Pattern = 4'b 0001;
            2: Pattern = 4'b 0011;
            3: Pattern = 4'b 0111;
            4: Pattern = 4'b 1111;
            default: Pattern = 4'b 0000;
        endcase
        TmpReady = Pattern << R_Addr;
        if (Round) begin
            //Circular Shift    
            case(R_Addr)
                0: Ready = TmpReady[3:0];
                1: Ready = {TmpReady[3:1],TmpReady[4]};
                2: Ready = {TmpReady[3:2],TmpReady[5:4]};
                3: Ready = {TmpReady[3],TmpReady[6:4]};
                default: Ready = 4'b 0000;
            endcase
        end
        else begin
            Ready = TmpReady;
        end
    end
endmodule