module z_decoder_2(sel, en, out);
	input sel, en;
	output [1:0] out;
	wire w0;
	not not1(w0, sel);
	and and0(out[0], w0, en);
	and and1(out[1], sel, en);
	//assign out = sel ? 1'b1 : 1'b10;
endmodule