module x_comparator(a, b, sum, neq, lt);
	input [31:0] a, b, sum;
	output neq, lt;
	
	wire [31:0] xors;
	
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: loop2
			xor my_xor(xors[i], a[i], b[i]);
		end
	endgenerate
	
	wire [7:0] xor2;
	generate
		for (i=0; i<8; i=i+1) begin: loop3
			or my_or(xor2[i], xors[i*4], xors[i*4+1], xors[i*4+2], xors[i*4+3]);
		end
	endgenerate
	or neq_or(neq, xor2[0], xor2[1], xor2[2], xor2[3], xor2[4], xor2[5], xor2[6], xor2[7]);
	
	// code for LT
	wire nota, notb, w10, w11, w12;
	not not4(nota, a[31]);
	not not5(notb, b[31]);
	and and10(w10, a[31], notb);
	and and11(w11, nota, notb, sum[31]);
	and and12(w12, a[31], b[31], sum[31]);
	or ltor(lt, w10, w11, w12);
	
	/*assign neqs[16] = 1'b0;
	assign lts[16] = 1'b0;
	
	
	genvar i;
	generate
		for (i=15; i>=0; i=i-1) begin: loop1
			comparator_2 c(.a(a[i*2+1:i*2]), .b(b[i*2+1:i*2]), .neq_in(neqs[i+1]), .lt_in(lts[i+1]), .neq_out(neqs[i]), .lt_out(lts[i]));
		end
	endgenerate

	assign neq = neqs[0];
	assign lt = lts[0];*/
	
	
endmodule