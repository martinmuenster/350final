module x_rshift(in, shift, out);
	input [31:0] in;
	input [4:0] shift;
	output [31:0] out;
	
	wire [31:0] w0, w1, w2, w3, w4;
	wire [31:0] result0, result1, result2, result3;
	
	assign w0[30:0] = in[31:1];
	assign w0[31] = in[31];
	assign result0 = shift[0] ? w0 : in;
	
	assign w1[29:0] = result0[31:2];
	assign w1[30] = result0[31];
	assign w1[31] = result0[31];
	assign result1 = shift[1] ? w1 : result0;
	
	assign w2[27:0] = result1[31:4];
	assign w2[28] = result1[31];
	assign w2[29] = result1[31];
	assign w2[30] = result1[31];
	assign w2[31] = result1[31];
	assign result2 = shift[2] ? w2 : result1;
	
	assign w3[23:0] = result2[31:8];
	assign w3[24] = result2[31];
	assign w3[25] = result2[31];
	assign w3[26] = result2[31];
	assign w3[27] = result2[31];
	assign w3[28] = result2[31];
	assign w3[29] = result2[31];
	assign w3[30] = result2[31];
	assign w3[31] = result2[31];
	assign result3 = shift[3] ? w3 : result2;
	
	assign w4[15:0] = result3[31:16];
	assign w4[16] = result3[31];
	assign w4[17] = result3[31];
	assign w4[18] = result3[31];
	assign w4[19] = result3[31];
	assign w4[20] = result3[31];
	assign w4[21] = result3[31];
	assign w4[22] = result3[31];
	assign w4[23] = result3[31];
	assign w4[24] = result3[31];
	assign w4[25] = result3[31];
	assign w4[26] = result3[31];
	assign w4[27] = result3[31];
	assign w4[28] = result3[31];
	assign w4[29] = result3[31];
	assign w4[30] = result3[31];
	assign w4[31] = result3[31];
	assign out = shift[4] ? w4 : result3;
	
endmodule