module adder_half(a, b, sum, c_out);
	input a, b;
	output sum, c_out;
	xor xor_1(sum, a, b);
	and and_c2(c_out, a, b);
endmodule
