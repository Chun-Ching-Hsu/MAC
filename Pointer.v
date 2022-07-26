module Pointer
    #(parameter BufferWidth = 2)
    (clk, reset, EN, Pointer);
    input clk;
    input reset;
    input EN;

    output reg [BufferWidth-1:0] Pointer;

    always@(posedge clk)begin
        // 學姊增加了reset 功能 20220726
        if(reset) begin
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