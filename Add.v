
module Add (
	dataa,
	datab,
	result);

	input	[7:0]  dataa;
	input	[7:0]  datab;
	output	[7:0]  result;
	
	assign result = dataa + datab;

endmodule

