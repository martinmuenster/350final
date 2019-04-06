module d_reg_32(q, d, clk, en, clr);
   
   //Inputs
   input [31:0] d;
	input clk, en, clr;

   //Output
   output [31:0] q;
   
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: loop1
			d_dffe_ref dffe(.d(d[i]), .q(q[i]), .clk(clk), .en(en), .clr(clr));
		end
	endgenerate

   
endmodule