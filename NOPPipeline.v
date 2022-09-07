//Multiply + Add = 5 + 2 = 7 Cycles latency
module NOPPipeline
	#(parameter Stages = 7)
	(clk, aclr, NOPIn, NOPOut);
	input clk, aclr;
	input NOPIn;
	output NOPOut;
	
	reg [Stages-1:0] NOPreg;
	
	integer index;
	
	always@(posedge clk, posedge aclr) begin
		if(aclr) begin
			for(index = 0; index < Stages; index = index + 1) begin: clearRegs
				NOPreg[index] <= 1;
			end
		end
		else begin
			NOPreg[0] <= NOPIn;
			for(index = 0; index < Stages - 1; index = index + 1) begin: Tranmit
				NOPreg[index+1] <= NOPreg[index];
			end		
		end
	end

	assign NOPOut = NOPreg[Stages-1];
	
endmodule
