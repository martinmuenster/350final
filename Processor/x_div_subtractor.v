module x_div_subtractor(a, b, result);

   input [31:0] a, b;

   output [31:0] result;
	
	wire [4:0] c, c0, c1;
	wire c_in;
	wire [31:0] invert;
	
	wire [31:0] c0_sum, c1_sum;
	assign c_in = 1'b1;
	

	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: loop1
			not invert_sub(invert[i], b[i]);
		end
	endgenerate
	
	x_adder_cl_8x1 my_cla_adder0(.a(a[7:0]), .b(invert[7:0]), .c_in(1'b1), .sum(result[7:0]), .c_out(c[0]));
	
	generate
		for (i=1; i<4; i=i+1) begin: loop2
			x_adder_cl_8x1 my_cla_adder0(.a(a[i*8+7:i*8]), .b(invert[i*8+7:i*8]), .c_in(1'b0), .sum(c0_sum[i*8+7:i*8]), .c_out(c0[i]));
			x_adder_cl_8x1 my_cla_adder1(.a(a[i*8+7:i*8]), .b(invert[i*8+7:i*8]), .c_in(1'b1), .sum(c1_sum[i*8+7:i*8]), .c_out(c1[i]));
		end
	endgenerate
	
	assign result[15:8] = c[0] ? c1_sum[15:8] : c0_sum[15:8];
	assign c[1] = c[0] ? c1[1] : c0[1];
	assign result[23:16] = c[1] ? c1_sum[23:16] : c0_sum[23:16];
	assign c[2] = c[1] ? c1[2] : c0[2];
	assign result[31:24] = c[2] ? c1_sum[31:24] : c0_sum[31:24];
	
	
endmodule