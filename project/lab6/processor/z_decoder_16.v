module z_decoder_16(sel, en, out);
	input [3:0] sel;
	input en;
	output [15:0] out;
	wire [3:0] w0;
	
	z_decoder_4 d0(.sel(sel[3:2]), .en(en), .out(w0));
	
	z_decoder_4 d1(.sel(sel[1:0]), .en(w0[0]), .out(out[3:0]));
	z_decoder_4 d2(.sel(sel[1:0]), .en(w0[1]), .out(out[7:4]));
	z_decoder_4 d3(.sel(sel[1:0]), .en(w0[2]), .out(out[11:8]));
	z_decoder_4 d4(.sel(sel[1:0]), .en(w0[3]), .out(out[15:12]));
	
endmodule