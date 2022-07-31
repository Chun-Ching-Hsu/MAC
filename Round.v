module Round(TP, HP, Round, Rec_Handshanking, Send_Handshaking, clk, reset);
    input clk, reset, Rec_Handshanking, Send_Handshaking;
    input [1:0] TP, HP;
    output reg Round;
    always @(posedge clk)
    begin
        if(reset) begin
            Round <= 1'b 0;
        end
        else if(TP == 2'b 11  && Rec_Handshanking) begin
            Round <= 1'b 1;
        end
        else if (HP == 2'b 11 && Send_Handshaking) begin
            Round <= 1'b 0 ;
        end
        else begin 
            Round <= Round; 
        end
    end
endmodule