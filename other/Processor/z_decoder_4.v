module z_decoder_4(sel, en, out);
	input [1:0] sel;
	input en;
	output [3:0] out;
	wire [1:0] w0;
	
	z_decoder_2 d0(.sel(sel[1]), .en(en), .out(w0));
	
	z_decoder_2 d1(.sel(sel[0]), .en(w0[0]), .out(out[1:0]));
	z_decoder_2 d2(.sel(sel[0]), .en(w0[1]), .out(out[3:2]));
	
endmodule