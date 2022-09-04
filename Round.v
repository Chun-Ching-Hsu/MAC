module Round
    #(  parameter BufferWidth = 2)
    (clk, rst, Push, Pop, W_Addr, R_Addr, Round);

    input clk, rst, Push, Pop;
    input [BufferWidth-1:0] W_Addr, R_Addr;
    output reg Round;
    always @(posedge clk , posedge rst)
    begin
        if(rst) begin
            Round <= 1'b 0;
        end
        else if(W_Addr == 2'b 11  && Push) begin
            Round <= 1'b 1;
        end
        else if (R_Addr == 2'b 11 && Pop) begin
            Round <= 1'b 0 ;
        end
        else begin 
            Round <= Round; 
        end
    end
endmodule