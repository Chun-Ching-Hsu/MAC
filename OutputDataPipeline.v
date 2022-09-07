module OutputDataPipeline   
    #(  parameter DataWidth = 32,
        parameter Stages = 5)
    (clk, aclr, DataIn, DataOut);

    input clk, aclr;
    input [DataWidth-1:0] DataIn;
    output [DataWidth-1:0] DataOut;

	reg [DataWidth-1:0] DataRegs [0:Stages-1];
	
	integer index;

	always@(posedge clk, posedge aclr) begin
		if(aclr) begin
			for(index = 0; index < Stages; index = index + 1) begin: clearRegs
				DataRegs[index] <= 0;
			end
		end
		else begin
            DataRegs[0] <= DataIn;
			for(index = 0; index < Stages - 1; index = index + 1) begin: Tranmit
				DataRegs[index+1] <= DataRegs[index];
			end		
		end
	end
	
	assign DataOut = DataRegs[Stages-1];

endmodule
