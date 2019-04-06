module z_reg_64(d, clk, clrn, prn, ena, q);
   
   //Inputs
   input [63:0] d;
	input clk, ena, clrn, prn;

   //Output
   output [63:0] q;
   
	genvar i;
	generate
		for (i=0; i<64; i=i+1) begin: loop1
			z_dflipflop dffe(.d(d[i]), .q(q[i]), .clk(clk), .ena(ena), .clrn(clrn), .prn(prn));
		end
	endgenerate

   
endmodule