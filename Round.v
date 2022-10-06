module Round
    #(  parameter BufferWidth = 4,
        parameter BufferSize = 16)
    (clk, aclr, Push, Pop, W_Addr, R_Addr, Round);

    input clk, aclr, Push, Pop;
    input [BufferWidth-1:0] W_Addr, R_Addr;
    output reg Round;

    wire W_ADDR_EQUALS_TO_BUFFER_SIZE = (W_Addr == BufferSize - 1);
    wire R_ADDR_EQUALS_TO_BUFFER_SIZE = (R_Addr == BufferSize - 1);

    always @(posedge clk , posedge aclr)
    begin
        if(aclr) begin
            Round <= 1'b 0;
        end
        else if(W_ADDR_EQUALS_TO_BUFFER_SIZE && Push) begin
            Round <= 1'b 1;
        end
        else if (R_ADDR_EQUALS_TO_BUFFER_SIZE && Pop) begin
            Round <= 1'b 0 ;
        end
        else begin 
            Round <= Round; 
        end
    end
endmodule