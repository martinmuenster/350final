module z_pmux_3_12(sel0, sel1, in0, in1, in2, out);
	input sel0, sel1;
	input [11:0] in0, in1, in2;
	output [11:0] out;
	
	wire [11:0] w1, w2;
	
	assign w1 = sel0 ? in1 : in0;
	assign out = sel1 ? in2 : w1;
	
endmodule

module z_pmux_3_8(sel0, sel1, in0, in1, in2, out);
	input sel0, sel1;
	input [7:0] in0, in1, in2;
	output [7:0] out;
	
	wire [7:0] w1, w2;
	
	assign w1 = sel0 ? in1 : in0;
	assign out = sel1 ? in2 : w1;
	
endmodule
