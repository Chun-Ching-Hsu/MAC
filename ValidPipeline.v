//Multiply + Add = 5 + 2 = 7 Cycles latency
module ValidPipeline
	#(parameter Stages = 7)
	(clk, aclr, ValidIn, ValidOut);
	input clk, aclr;
	input ValidIn;
	output ValidOut;
	
	reg [Stages-1:0] Validreg;
	
	integer index;
	
	always@(posedge clk, posedge aclr) begin
		if(aclr) begin
			for(index = 0; index < Stages; index = index + 1) begin: clearRegs
				Validreg[index] <= 0;
			end
		end
		else begin
			Validreg[0] <= ValidIn;
			for(index = 0; index < Stages - 1; index = index + 1) begin: Tranmit
				Validreg[index+1] <= Validreg[index];
			end		
		end
	end

	assign ValidOut = Validreg[Stages-1];
	
endmodule
