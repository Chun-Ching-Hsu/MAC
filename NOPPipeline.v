//Multiply + Add = 5 + 2 = 7 Cycles latency
module NOPPipeline
	#(parameter stages = 7)
	(clk, sclr, NOPIn, NOPOut);
	input clk, sclr;
	input NOPIn;
	output NOPOut;
	
	reg [stages:0] NOPreg;
	
	integer index;
	
	always@(posedge clk) begin
		if(sclr) begin
			for(index = 0; index < stages + 1; index = index + 1) begin: clearRegs
				NOPreg[index] <= 1;
			end
		end
		else begin
			NOPreg[0] <= NOPIn;
			for(index = 0; index < stages; index = index + 1) begin: Tranmit
				NOPreg[index+1] <= NOPreg[index];
			end		
		end
	end

	assign NOPOut = NOPreg[stages];
	
endmodule
