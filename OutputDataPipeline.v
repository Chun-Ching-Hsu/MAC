module OutputDataPipeline   
    #(  parameter DataOutputWidth = 8,
        parameter Stages = 5)
    (clk, sclr, DataIn, DataOut);

    input clk, sclr;
    input [DataOutputWidth-1:0] DataIn;
    output [DataOutputWidth-1:0] DataOut;

	reg [Stages:0] DataRegs [0:DataOutputWidth-1];
	
	integer index;

	always@(posedge clk) begin
		if(sclr) begin
			for(index = 0; index < Stages + 1; index = index + 1) begin: clearRegs
				DataRegs[index] <= 0;
			end
		end
		else begin
            DataRegs[0] <= DataIn;
			for(index = 0; index < Stages; index = index + 1) begin: Tranmit
				DataRegs[index+1] <= DataRegs[index];
			end		
		end
	end
	
	assign DataOut = DataRegs[Stages];

endmodule
