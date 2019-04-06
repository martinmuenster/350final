module z_decoder_32(select, out);
	input [4:0] select;
	output [31:0] out;
	
	wire [1:0] w0;
	
	z_decoder_2 d0(.sel(select[4]), .en(1'b1), .out(w0));
	
	z_decoder_16 d1(.sel(select[3:0]), .en(w0[0]), .out(out[15:0]));
	z_decoder_16 d2(.sel(select[3:0]), .en(w0[1]), .out(out[31:16]));

	


	/*wire w0, w1, w2, w3, w4;

	not not0(w0, select[0]);
	not not1(w1, select[1]);
	not not2(w2, select[2]);
	not not3(w3, select[3]);
	not not4(w4, select[4]);

	and and0(out[0], w4, w3, w2, w1, w0);
	and and1(out[1], w4, w3, w2, w1, select[0]);
	and and2(out[2], w4, w3, w2, select[1], w0);
	and and3(out[3], w4, w3, w2, select[1], select[0]);
	and and4(out[4], w4, w3, select[2], w1, w0);
	and and5(out[5], w4, w3, select[2], w1, select[0]);
	and and6(out[6], w4, w3, select[2], select[1], w0);
	and and7(out[7], w4, w3, select[2], select[1], select[0]);
	and and8(out[8], w4, select[3], w2, w1, w0);
	and and9(out[9], w4, select[3], w2, w1, select[0]);
	and and10(out[10], w4, select[3], w2, select[1], w0);
	and and11(out[11], w4, select[3], w2, select[1], select[0]);
	and and12(out[12], w4, select[3], select[2], w1, w0);
	and and13(out[13], w4, select[3], select[2], w1, select[0]);
	and and14(out[14], w4, select[3], select[2], select[1], w0);
	and and15(out[15], w4, select[3], select[2], select[1], select[0]);
	and and16(out[16], select[4], w3, w2, w1, w0);
	and and17(out[17], select[4], w3, w2, w1, select[0]);
	and and18(out[18], select[4], w3, w2, select[1], w0);
	and and19(out[19], select[4], w3, w2, select[1], select[0]);
	and and20(out[20], select[4], w3, select[2], w1, w0);
	and and21(out[21], select[4], w3, select[2], w1, select[0]);
	and and22(out[22], select[4], w3, select[2], select[1], w0);
	and and23(out[23], select[4], w3, select[2], select[1], select[0]);
	and and24(out[24], select[4], select[3], w2, w1, w0);
	and and25(out[25], select[4], select[3], w2, w1, select[0]);
	and and26(out[26], select[4], select[3], w2, select[1], w0);
	and and27(out[27], select[4], select[3], w2, select[1], select[0]);
	and and28(out[28], select[4], select[3], select[2], w1, w0);
	and and29(out[29], select[4], select[3], select[2], w1, select[0]);
	and and30(out[30], select[4], select[3], select[2], select[1], w0);
	and and31(out[31], select[4], select[3], select[2], select[1], select[0]);*/

endmodule