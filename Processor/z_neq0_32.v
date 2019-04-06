module z_neq0_32(in, out);
   
   input [31:0] in;
	output out;
	
	wire [3:0] mid;
	
	
	genvar i;
	generate
		for (i=0; i<4; i=i+1) begin: loop1
			assign mid[i] = in[i*8] || in[i*8+1] || in[i*8+2] || in[i*8+3] || in[i*8+4] || in[i*8+5] || in[i*8+6] || in[i*8+7];
		end
	endgenerate

	assign out = mid[0] || mid[1] || mid[2] || mid[3];
   
endmodule