module x_alu(data_operandA, data_operandB, ctrl_ALUopcode, ALU_op, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	input ALU_op;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	
	wire [31:0] op_results [4:0];
	
	wire [31:0] invert;
	
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: loop1
			not invert_sub(invert[i], data_operandB[i]);
			and my_and(op_results[1][i], data_operandA[i], data_operandB[i]);
			or my_or(op_results[2][i], data_operandA[i], data_operandB[i]);
		end
	endgenerate
	

	
	//cla_adder_4_8bit adder(.a(data_operandA), .b(data_operandB), .invert(invert), .c_in(ctrl_ALUopcode[0]), .sum(op_results[0]), .overflow(overflow));
	x_adder_select_4x8 adder(.a(data_operandA), .b(data_operandB), .invert(invert), .c_in(ctrl_ALUopcode[0]), .sum(op_results[0]), .overflow(overflow));
	//mega_function_32 adder(.a(data_operandA), .b(data_operandB), .invert(invert), .c_in(ctrl_ALUopcode[0]), .sum(op_results[0]), .overflow(overflow));
	
	x_comparator my_comparator(.a(data_operandA), .b(data_operandB), .sum(op_results[0]), .neq(isNotEqual), .lt(isLessThan));
	
	x_lshift my_lshift(.in(data_operandA), .shift(ctrl_shiftamt), .out(op_results[3]));
	x_rshift my_rshift(.in(data_operandA), .shift(ctrl_shiftamt), .out(op_results[4]));
	
	

   // YOUR CODE HERE //
	z_mux_8 op_select(ctrl_ALUopcode, op_results[0], op_results[0], op_results[1], op_results[2], op_results[3], op_results[4], 1'b0, 1'b0, data_result);
	
	

endmodule
