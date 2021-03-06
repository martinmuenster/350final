module mux_16(c, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, out);
	input [15:0] c;
	input [18:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
	output [18:0] out;
	wire [18:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13;
	
	
	assign w0 = c[0] ?  in0  : in1;
	assign w1 = c[2] ?  in2  : in3;
	assign w2 = c[4] ?  in4  : in5;
	assign w3 = c[6] ?  in6  : in7;
	assign w4 = c[8] ?  in8  : in9;
	assign w5 = c[10] ? in10 : in11;
	assign w6 = c[12] ? in12 : in13;
	assign w7 = c[14] ? in14 : in15;
	
	assign w8  = (c[0] || c[1]) ? w0 : w1;
	assign w9  = (c[4] || c[5]) ? w2 : w3;
	assign w10 = (c[8] || c[9]) ? w4 : w5;
	assign w11 = (c[12] || c[13]) ? w6 : w7;
	
	
	assign w12 = (c[0] || c[1] || c[2] || c[3]) ? w8 : w9;
	assign w13 = (c[8] || c[9] || c[10] || c[11]) ? w10 : w11;
	
	assign out = (c[0] || c[1] || c[2] || c[3] || c[4] || c[5] || c[6] || c[7]) ? w12 : w13;

	
endmodule