module z_equals_5(a, b, out);
  
   input [4:0] a, b;
   output out;
   
	wire [4:0] c;
	
	
	genvar i;
	generate
		for (i=0; i<5; i=i+1) begin: loop1
			xnor x1(c[i], a[i], b[i]);
		end
	endgenerate
	
	
	assign out = c[4] && c[3] && c[2] && c[1] && c[0];

   
endmodule