module z_pmux_3(sel0, sel1, sel2, in0, in1, in2, out);
	input sel0, sel1, sel2;
	input [31:0] in0, in1, in2;
	output [31:0] out;
	
	wire [31:0] w1, w2;
	
	assign w1 = sel0 ? in1 : in0;
	assign out = sel1 ? in2 : w1;
	
endmodule
