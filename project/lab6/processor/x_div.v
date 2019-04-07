module x_div(dividend, divisor_in, clock, div_asserted, result, error, start_div);
	input [31:0] dividend, divisor_in;
	input clock, div_asserted;
	output [31:0] result;
	output error, start_div;
	
	//wire start_div;
	wire [31:0] a_neg, b_neg, div_a_in, div_b_in, div_out, div_result, pos_out, divisor_in_pos, dividend_pos;
	wire [63:0] reg_in;
	//wire negAnswer, hold_negAnswer, div_by_0, div_by_0_hold;
	
	x_negator n0(.in(dividend), .out(a_neg));
	x_negator n1(.in(divisor_in), .out(b_neg));
	assign div_a_in = dividend[31] ? a_neg : dividend;
	assign div_b_in = divisor_in[31] ? b_neg : divisor_in;
	z_reg_32 neg_hold0(.d(div_a_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(div_asserted), .q(dividend_pos));
	z_reg_32 neg_hold1(.d(div_b_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(div_asserted), .q(divisor_in_pos));
	z_dflipflop shiftreg_1(.d(div_asserted), .q(start_div), .clk(clock), .ena(1'b1), .clrn(1'b1), .prn(1'b1));
	
	wire [31:0] divisor_hold, divisor;
	//reg_32 divisor_regs(.d(divisor_in_pos), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(start_div), .q(divisor_hold));
	//assign divisor = start_div ? divisor_in_pos : divisor_hold;
	assign divisor = divisor_in_pos;
	
	
	wire [63:0] partial, initial_partial, partial_hold, unshifted_partial;
	assign initial_partial [31:0] = dividend_pos;
	assign initial_partial [63:32] = 32'b0;
		
	assign partial = start_div ? initial_partial : partial_hold;
	z_reg_64 regs(.d(reg_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(partial_hold));
	
	x_div_partial partial_div(.divisor(divisor), .partial(partial), .outPartial(unshifted_partial));
	x_div_lshift lshift(.in(unshifted_partial), .out(reg_in));
	
	assign result = unshifted_partial[31:0];
	
	genvar i;
	wire [7:0] ors;
	generate
		for (i=0; i<8; i=i+1) begin: loop3
			or my_or(ors[i], divisor_in[i*4], divisor_in[i*4+1], divisor_in[i*4+2], divisor_in[i*4+3]);
		end
	endgenerate
	nor div_by_0(error, ors[0], ors[1], ors[2], ors[3], ors[4], ors[5], ors[6], ors[7]);
	
	
endmodule