module x_mult_shiftreg(d, clk, clrn, prn, ena, q);
   
   //Inputs
   input d;
	input clk, ena, clrn, prn;

   //Output
   output q;
	
	wire [3:0] shift;
	assign shift[0] = d;
	
	z_dflipflop dffe(.d(shift[0]), .q(shift[1]), .clk(clk), .ena(ena), .clrn(1'b1), .prn(prn));
	z_dflipflop dffe2(.d(shift[1]), .q(shift[2]), .clk(clk), .ena(ena), .clrn(1'b1), .prn(prn));
	
	/*genvar i;
	generate
		for (i=1; i<3; i=i+1) begin: loop1
			z_dflipflop dffe(.d(shift[i]), .q(shift[i+1]), .clk(clk), .ena(ena), .clrn(clrn), .prn(prn));
		end
	endgenerate*/

	assign q = shift[2];
   
endmodule