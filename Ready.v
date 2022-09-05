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
    reg [BufferSize-1:0] TmpReady;
    
    output reg [BufferSize-1:0] Ready;
    
    always @(*)begin
        case(Distance)
            3'b 000: TmpReady = 4'b 0000;
            3'b 001: TmpReady = 4'b 0001;
            3'b 010: TmpReady = 4'b 0011;
            3'b 011: TmpReady = 4'b 0111;
            3'b 100: TmpReady = 4'b 1111;
            default: TmpReady = 4'b 0000;
        endcase
        if (Round) begin
            //Circular Shift    
            case(R_Addr)
                2'b 00: Ready = TmpReady;
                2'b 01: Ready = {TmpReady << R_Addr, TmpReady[BufferSize-1:BufferSize-1-1]};
                2'b 10: Ready = {TmpReady << R_Addr, TmpReady[BufferSize-1:BufferSize-1-2]};
                2'b 11: Ready = {TmpReady << R_Addr, TmpReady[BufferSize-1:BufferSize-1-3]};
                default: Ready = 2'b 00;
            endcase
        end
        else begin
            Ready = TmpReady << R_Addr;
        end
            //brute-force here
            //need to be optimized here
            /*case({W_Addr,R_Addr})
                4'b 0000: Ready = 1111;
                4'b 0001: Ready = 1110;
                4'b 0101: Ready = 1111;
                4'b 0010: Ready = 1100;
                4'b 0110: Ready = 1101;
                4'b 1010: Ready = 1111;
                4'b 0011: Ready = 1000;
                4'b 0111: Ready = 1001; 
                4'b 1011: Ready = 1011;
                4'b 1111: Ready = 1111;
                default: Ready = 0000;
            endcase
            */
    end
endmodule