module x_adder_cl_8x1(a, b, c_in, sum, c_out);

   input [7:0] a, b;
   input c_in;

   output [7:0] sum;
   //output c_out;
	output c_out;
	
	wire [7:0] p, g, c;
	wire [35:0] temp;
	
	assign c[0] = c_in;

	genvar i;
	generate
		for (i=0; i<8; i=i+1) begin: loop1
			and my_and(g[i], a[i], b[i]);
			or my_or(p[i], a[i], b[i]);
		end
	endgenerate
	
	
	and c1_calc_and0(temp[0], p[0], c[0]);
	or c1_calc_or0(c[1], g[0], temp[0]);

	and c2_calc_and0(temp[1], p[1], g[0]);
	and c2_calc_and1(temp[2], p[1], p[0], c[0]);
	or c2_calc_or1(c[2], g[1], temp[1], temp[2]);

	and c3_calc_and0(temp[3], p[2], g[1]);
	and c3_calc_and1(temp[4], p[2], p[1], g[0]);
	and c3_calc_and2(temp[5], p[2], p[1], p[0], c[0]);
	or c3_calc_or2(c[3], g[2], temp[3], temp[4], temp[5]);

	and c4_calc_and0(temp[6], p[3], g[2]);
	and c4_calc_and1(temp[7], p[3], p[2], g[1]);
	and c4_calc_and2(temp[8], p[3], p[2], p[1], g[0]);
	and c4_calc_and3(temp[9], p[3], p[2], p[1], p[0], c[0]);
	or c4_calc_or3(c[4], g[3], temp[6], temp[7], temp[8], temp[9]);


	and c5_calc_and0(temp[10], p[4], g[3]);
	and c5_calc_and1(temp[11], p[4], p[3], g[2]);
	and c5_calc_and2(temp[12], p[4], p[3], p[2], g[1]);
	and c5_calc_and3(temp[13], p[4], p[3], p[2], p[1], g[0]);
	and c5_calc_and4(temp[14], p[4], p[3], p[2], p[1], p[0], c[0]);
	or c5_calc_or4(c[5], g[4], temp[10], temp[11], temp[12], temp[13], temp[14]);


	and c6_calc_and0(temp[15], p[5], g[4]);
	and c6_calc_and1(temp[16], p[5], p[4], g[3]);
	and c6_calc_and2(temp[17], p[5], p[4], p[3], g[2]);
	and c6_calc_and3(temp[18], p[5], p[4], p[3], p[2], g[1]);
	and c6_calc_and4(temp[19], p[5], p[4], p[3], p[2], p[1], g[0]);
	and c6_calc_and5(temp[20], p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
	or c6_calc_or5(c[6], g[5], temp[15], temp[16], temp[17], temp[18], temp[19], temp[20]);


	and c7_calc_and0(temp[21], p[6], g[5]);
	and c7_calc_and1(temp[22], p[6], p[5], g[4]);
	and c7_calc_and2(temp[23], p[6], p[5], p[4], g[3]);
	and c7_calc_and3(temp[24], p[6], p[5], p[4], p[3], g[2]);
	and c7_calc_and4(temp[25], p[6], p[5], p[4], p[3], p[2], g[1]);
	and c7_calc_and5(temp[26], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and c7_calc_and6(temp[27], p[6], p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
	or c7_calc_or6(c[7], g[6], temp[21], temp[22], temp[23], temp[24], temp[25], temp[26], temp[27]);
	
	and c8_calc_and0(temp[28], p[7], g[6]);
	and c8_calc_and1(temp[29], p[7], p[6], g[5]);
	and c8_calc_and2(temp[30], p[7], p[6], p[5], g[4]);
	and c8_calc_and3(temp[31], p[7], p[6], p[5], p[4], g[3]);
	and c8_calc_and4(temp[32], p[7], p[6], p[5], p[4], p[3], g[2]);
	and c8_calc_and5(temp[33], p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
	and c8_calc_and6(temp[34], p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and c8_calc_and7(temp[35], p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
	or c8_calc_or7(c_out, g[7], temp[28], temp[29], temp[30], temp[31], temp[32], temp[33], temp[34], temp[35]);
	
	//or G_calc_or(G, g[7], temp[28], temp[29], temp[30], temp[31], temp[32], temp[33], temp[34]);
	//and P_calc_and(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
	
	genvar j;
	generate
		for (j=0; j<8; j=j+1) begin: loop2
			xor my_sum(sum[j], c[j], a[j], b[j]);
		end
	endgenerate
	
	
	
	
endmodule
