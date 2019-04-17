module z_neq_12(a, b, out);
  
   input [11:0] a, b;
   output out;
   
	wire [11:0] c;
	
	
	genvar i;
	generate
		for (i=0; i<12; i=i+1) begin: loop1
			xor x1(c[i], a[i], b[i]);
		end
	endgenerate
	
	
	assign out = c[11] || c[10] || c[9] || c[8] || c[7] || c[6] || c[5] || c[4] || c[3] || c[2] || c[1] || c[0];

   
endmodule