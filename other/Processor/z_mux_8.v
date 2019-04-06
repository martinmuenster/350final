module z_mux_8(select, in0, in1, in2, in3, in4, in5, in6, in7, out);
	input [2:0] select;
	input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
	output [31:0] out;
	wire [31:0] w1, w2, w3, w4;
	
	assign w1 = select[0] ? in1 : in0;
	assign w2 = select[0] ? in3 : in2;
	assign w3 = select[0] ? in5 : in4;
	assign w4 = select[0] ? in7 : in6;
	
	z_mux_4 second_1(.select(select[2:1]), .in0(w1), .in1(w2), .in2(w3), .in3(w4), .out(out));
	
endmodule