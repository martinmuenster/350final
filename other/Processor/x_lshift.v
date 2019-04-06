module x_lshift(in, shift, out);
	input [31:0] in;
	input [4:0] shift;
	output [31:0] out;
	
	wire [31:0] w0, w1, w2, w3, w4;
	wire [31:0] result0, result1, result2, result3;
	
	assign w0 = in << 1;
	assign result0 = shift[0] ? w0 : in;
	
	assign w1 = result0 << 2;
	assign result1 = shift[1] ? w1 : result0;
	
	assign w2 = result1 << 4;
	assign result2 = shift[2] ? w2 : result1;
	
	assign w3 = result2 << 8;
	assign result3 = shift[3] ? w3 : result2;
	
	assign w4 = result3 << 16;
	assign out = shift[4] ? w4 : result3;
	
	
endmodule