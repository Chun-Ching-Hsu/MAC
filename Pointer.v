module Pointer
    #(  parameter BufferWidth = 2)
    (clk, rst, EN, Pointer);
    input clk, rst;
    input EN;

    output reg [BufferWidth-1:0] Pointer;

    always@(posedge clk, posedge rst)begin
        // 學姊增加了reset 功能 20220726
        if(rst) begin
            Pointer <= 0;
        end
        else if(EN) begin
	        Pointer <= Pointer+1;
        end
        else begin
           Pointer <= Pointer; 
        end
    end
endmodule