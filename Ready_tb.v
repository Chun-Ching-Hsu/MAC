`timescale 1ps/1ps
module Ready_tb
    #(  parameter BufferWidth = 2,
        parameter BufferSize = 4)();

    reg [BufferWidth-1:0] W_Addr, R_Addr;
    reg Round;
    
    wire [BufferSize-1:0] Ready;

    Ready #(.BufferWidth(BufferWidth), .BufferSize(BufferSize)) dut
    (.W_Addr(W_Addr), .R_Addr(R_Addr), .Round(Round), .Ready(Ready));

    initial begin
        W_Addr = 0;
        R_Addr = 0;
        Round = 0;        
    end
	 
	always #2 begin
		$monitor("%0d ns, W_Addr:%d, R_Addr: %d, Round: %b, Ready: %b",
         $stime, W_Addr, R_Addr, Round, Ready);
	end

	always #2 begin
        W_Addr = W_Addr + 1;
	end
    
    always #8 begin
        R_Addr = R_Addr + 1; 
    end

	always #32 begin
        Round = ~Round;
	end    


endmodule
