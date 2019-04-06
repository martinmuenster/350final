module x_negator(in, out);
	input [31:0] in;
	output [31:0] out;

	x_div_subtractor neg(.a(32'b0), .b(in), .result(out));

endmodule