module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	
	
	wire isAdd, isSubtract, isLeftShift, isRightShift, isAnd, isOr;
	wire n_ctrl_ALUopcode2, n_ctrl_ALUopcode1, n_ctrl_ALUopcode0;
	
	not not_ctrl_ALUopcode2(n_ctrl_ALUopcode2, ctrl_ALUopcode[2]);
	not not_ctrl_ALUopcode1(n_ctrl_ALUopcode1, ctrl_ALUopcode[1]);
	not not_ctrl_ALUopcode0(n_ctrl_ALUopcode0, ctrl_ALUopcode[0]);
	
	and opd_0(isAdd, n_ctrl_ALUopcode2, n_ctrl_ALUopcode1, n_ctrl_ALUopcode0);
	and opd_1(isSubtract, n_ctrl_ALUopcode2, n_ctrl_ALUopcode1, ctrl_ALUopcode[0]);
	and opd_2(isAnd, n_ctrl_ALUopcode2, ctrl_ALUopcode[1], n_ctrl_ALUopcode0);
	and opd_3(isOr, n_ctrl_ALUopcode2, ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
	and opd_4(isLeftShift, ctrl_ALUopcode[2], n_ctrl_ALUopcode1, n_ctrl_ALUopcode0);
	and opd_5(isRightShift, ctrl_ALUopcode[2], n_ctrl_ALUopcode1, ctrl_ALUopcode[0]);
	
	wire [31:0] not_data_operandB;
	wire cout_add;
	
	bit_not_32 notInpB(data_operandB, not_data_operandB);
	
	
	// The regular adder isn't fast enough. Maybe because computation for both adder and subtractor is too much. 
	wire [31:0] opB_post_opchoose;
	wire carry_in_post_opchoose;
	
	assign opB_post_opchoose = isAdd ? data_operandB : not_data_operandB;
	assign carry_in_post_opchoose = isAdd ? 1'b0 : 1'b1;
	
	// Compute ops. 
	wire [31:0] addRes, lsRes, rsRes, andRes, orRes;
	
	cselect_adder_32 exec_op0(.in1(data_operandA), .in2(opB_post_opchoose), .cin(carry_in_post_opchoose), .cout(cout_add), .s(addRes));
	bit_and_32 exec_op2(.out(andRes), .in1(data_operandA), .in2(data_operandB));
	bit_or_32 exec_op3(.out(orRes), .in1(data_operandA), .in2(data_operandB));
	l_shift_main exec_op4(.out(lsRes), .num(data_operandA), .ctrl_shiftamt(ctrl_shiftamt));
	r_shift_main exec_op5(.out(rsRes), .num(data_operandA), .ctrl_shiftamt(ctrl_shiftamt));
	
	// Choose correct data_res

   tristate_buffer_32 tsb0(addRes, data_result, isAdd);
   tristate_buffer_32 tsb1(addRes, data_result, isSubtract);
   tristate_buffer_32 tsb2(andRes, data_result,  isAnd);
   tristate_buffer_32 tsb3(orRes, data_result, isOr);
   tristate_buffer_32 tsb4(lsRes, data_result, isLeftShift);
   tristate_buffer_32 tsb5(rsRes, data_result, isRightShift);
	
	// Calculate other results
	
	wire isANeg, isBNeg, isSNeg;
	assign isANeg = data_operandA[31];
	assign isBNeg = data_operandB[31];
	assign isSNeg = data_result[31];
	
	   
   not_equal_check ne_check(.in(data_result), .out(isNotEqual));
   less_than_check lt_check(.in1(isANeg), .in2(isBNeg), .res(isSNeg), .out(isLessThan));
   overflow_check of_check(.in1(isANeg), .in2(isBNeg), .res(isSNeg), .isSub(isSubtract), .out(overflow));
endmodule


module overflow_check(in1, in2, res, isSub, out);

	input in1, in2, res, isSub;
	output out;
	
	wire n_in1, n_in2, n_res, n_isSub;

	not n1(n_in1,in1);
	not n2(n_in2, in2);
	not n3(n_res, res);
	not n4(n_isSub, isSub);

	wire c0, c1, c2, c3;

	and case0(c0, in1, in2, n_isSub, n_res);
	and case1(c1, n_in1, n_in2, n_isSub, res);
	and case2(c2, n_in1, in2, isSub, res);
	and case3(c3, in1, n_in2, isSub, n_res);

	or res_or(out, c0, c1, c2, c3);
endmodule