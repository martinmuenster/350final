module z_adder_select_4x8(a, b, c_in, sum, c_out);

   input [31:0] a, b;
	input c_in;

   output [31:0] sum;
   output c_out;
	
	wire [4:0] c, c0, c1;
	wire c_in;
	
	wire [31:0] c0_sum, c1_sum;
	
	
	z_adder_cl_8x1 my_cla_adder0(.a(a[7:0]), .b(b[7:0]), .c_in(c_in), .sum(sum[7:0]), .c_out(c[0]));

	genvar i;
	generate
		for (i=1; i<4; i=i+1) begin: loop1
			z_adder_cl_8x1 my_cla_adder0(.a(a[i*8+7:i*8]), .b(b[i*8+7:i*8]), .c_in(1'b0), .sum(c0_sum[i*8+7:i*8]), .c_out(c0[i]));
			z_adder_cl_8x1 my_cla_adder1(.a(a[i*8+7:i*8]), .b(b[i*8+7:i*8]), .c_in(1'b1), .sum(c1_sum[i*8+7:i*8]), .c_out(c1[i]));
		end
	endgenerate
	
	assign sum[15:8] = c[0] ? c1_sum[15:8] : c0_sum[15:8];
	assign c[1] = c[0] ? c1[1] : c0[1];
	assign sum[23:16] = c[1] ? c1_sum[23:16] : c0_sum[23:16];
	assign c[2] = c[1] ? c1[2] : c0[2];
	assign sum[31:24] = c[2] ? c1_sum[31:24] : c0_sum[31:24];
	assign c_out = c[2] ? c1[3] : c0[3];
	
	
	//code for OF
	/*wire nota, notb, notsum, adding, w13, w14, w15, w16;
	not not7(notsum, sum[31]);
	not not8(adding, c_in);
	not not4(nota, a[31]);
	not not5(notb, b[31]);
	and and13(w13, a[31], b[31], notsum, adding);
	and and14(w14, nota, notb, sum[31], adding);
	and and15(w15, nota, b[31], sum[31], c_in);
	and and16(w16, a[31], notb, notsum, c_in);
	or OFor(overflow, w13, w14, w15, w16);*/
	
	
endmodule