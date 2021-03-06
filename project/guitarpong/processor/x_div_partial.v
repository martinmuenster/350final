module x_div_partial(divisor, partial, outPartial);
	input [31:0] divisor;
	input [63:0] partial;
	output [63:0] outPartial;
	
	wire [31:0] sub;
	x_div_subtractor my_adder(.a(partial[63:32]), .b(divisor), .result(sub));
	
	//comparator here
	wire div_GT_rem;
	assign div_GT_rem = sub[31];
	
	wire [63:0] newPartial;
	assign newPartial[63:32] = div_GT_rem ? partial[63:32] : sub;
	assign newPartial[31:1] = partial[31:1];
	assign newPartial[0] = div_GT_rem ? partial[0] : 1'b1;

	assign outPartial = newPartial;
	
	
endmodule