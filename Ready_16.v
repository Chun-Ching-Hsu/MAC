//have some problem when round = 1
//same distance means same pattern
//and the shift operation should be rotate left shift

module Ready_16
    (W_Addr, R_Addr, Round, Ready);

    parameter BufferWidth = 4;
    parameter BufferSize = 16;
    parameter PseudoBufferWidth = 5;
    parameter PseudoBufferSize = 32;

    input [BufferWidth-1:0] W_Addr, R_Addr;
    input Round;

    wire [PseudoBufferWidth-1:0] Pseudo_W_Addr = Round ? W_Addr + BufferSize : W_Addr ;
    wire [PseudoBufferWidth-1:0] Distance = Pseudo_W_Addr - R_Addr;
    reg [PseudoBufferSize-1:0] Pattern;
    reg [PseudoBufferSize-1:0] TmpReady;
    
    output reg [BufferSize-1:0] Ready;

    
    always @(*)begin
        
        //Pattern = {(Distance){1}};
        case(Distance)
            0: Pattern = {32'b0};
            1: Pattern = {31'b0,1'b1};
            2: Pattern = {30'b0,2'b11};
            3: Pattern = {29'b0,3'b111};
            4: Pattern = {28'b0,4'b1111};
            5: Pattern = {27'b0,5'b1_1111};
            6: Pattern = {26'b0,6'b11_1111};
            7: Pattern = {25'b0,7'b111_1111};
            8: Pattern = {24'b0,8'b1111_1111};
            9: Pattern = {23'b0,9'b1_1111_1111};
            10: Pattern = {22'b0,10'b11_1111_1111};
            11: Pattern = {21'b0,11'b111_1111_1111};
            12: Pattern = {20'b0,12'b1111_1111_1111};
            13: Pattern = {19'b0,13'b1_1111_1111_1111};
            14: Pattern = {18'b0,14'b11_1111_1111_1111};
            15: Pattern = {17'b0,15'b111_1111_1111_1111};
            16: Pattern = {16'b0,16'b1111_1111_1111_1111};
            default: Pattern = 32'b0;
        endcase
        
        TmpReady = Pattern << R_Addr;
        if (Round) begin
            //Circular Shift    
            case(R_Addr)
                0: Ready = TmpReady[15:0];
                1: Ready = {TmpReady[15:1], TmpReady[16]};
                2: Ready = {TmpReady[15:2], TmpReady[17:16]};
                3: Ready = {TmpReady[15:3], TmpReady[18:16]};
                4: Ready = {TmpReady[15:4], TmpReady[19:16]};
                5: Ready = {TmpReady[15:5], TmpReady[20:16]};
                6: Ready = {TmpReady[15:6], TmpReady[21:16]};
                7: Ready = {TmpReady[15:7], TmpReady[22:16]};
                8: Ready = {TmpReady[15:8], TmpReady[23:16]};
                9: Ready = {TmpReady[15:9], TmpReady[24:16]};
                10: Ready = {TmpReady[15:10], TmpReady[25:16]};
                11: Ready = {TmpReady[15:11], TmpReady[26:16]};
                12: Ready = {TmpReady[15:12], TmpReady[27:16]};
                13: Ready = {TmpReady[15:13], TmpReady[28:16]};
                14: Ready = {TmpReady[15:14], TmpReady[29:16]};
                15: Ready = {TmpReady[15], TmpReady[30:16]};
                default: Ready = 16'b0;
            endcase
        end
        else begin
            Ready = TmpReady;
        end
    end
endmodule