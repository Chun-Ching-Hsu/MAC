module Pointer
    #(  parameter BufferWidth = 2)
    (clk, aclr, sclr, EN, Pointer);
    input clk, aclr, sclr;
    input EN;

    output reg [BufferWidth-1:0] Pointer;

    always@(posedge clk, posedge aclr)begin
        // 學姊增加了reset 功能 20220726
        if(aclr) begin
            Pointer = 0;
        end
        else if (sclr) begin
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