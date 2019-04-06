module adder_full(a, b, c_in, sum, c_out);
	input a, b, c_in;
	output sum, c_out;
	wire w1, w2, w3;
	xor xor_1(w1, a, b);
	xor xor_sum(sum, w1, c_in);
	and and_c1(w2, w1, c_in);
	and and_c2(w3, a, b);
	or or_c(c_out, w2, w3);
endmodule
