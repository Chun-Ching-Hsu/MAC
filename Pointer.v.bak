module Pointer
    #(parameter BufferWidth = 2)
    (EN,Pointer,clk);
    input clk;
    input EN;

    output [BufferWidth-1:0] Pointer;

    always@(posedge clk)begin
        if(EN)begin
	        Pointer <= Pointer+1;
        end
        else begin
           Pointer <= Pointer; 
        end
    end
endmodule