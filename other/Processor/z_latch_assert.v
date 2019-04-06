module z_latch_assert(is_ALU_op, ALU_op);
	input is_ALU_op;
	input [4:0] ALU_op;
	
	/*wire reg_in;
	assign reg_in = is_ALU_op && 

	z_dflipflop dffe(.d(is_ALU_op && ALU_op == ), .q(q[i]), .clk(clk), .ena(ena), .clrn(clrn), .prn(prn));
	
   genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: loop1
			z_dflipflop dffe(.d(d[i]), .q(q[i]), .clk(clk), .ena(ena), .clrn(clrn), .prn(prn));
		end
	endgenerate
	
	
	
	
	
	module shiftreg_32(d, clk, clrn, prn, ena, q);
   
   //Inputs
   input d;
	input clk, ena, clrn, prn;

   //Output
   output q;
	
	wire [33:0] shift;
	assign shift[0] = d;
	
	dflipflop dffe(.d(shift[0]), .q(shift[1]), .clk(clk), .ena(ena), .clrn(1'b1), .prn(prn));
	
	genvar i;
	generate
		for (i=1; i<33; i=i+1) begin: loop1
			dflipflop dffe(.d(shift[i]), .q(shift[i+1]), .clk(clk), .ena(ena), .clrn(clrn), .prn(prn));
		end
	endgenerate

	assign q = shift[33];
   
	endmodule*/





   
endmodule
