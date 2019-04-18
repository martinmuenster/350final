/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
 
module processor_processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,                 // I: Data from port B of regfile
	pc
);
    // Control signals
   input clock, reset;
	
	output [11:0] pc;
	assign pc = pc_out;

   // Imem
   output [11:0] address_imem;
   input [31:0] q_imem;

   // Dmem
   output [11:0] address_dmem;
   output [31:0] data;
   output wren;
   input [31:0] q_dmem;

   // Regfile
   output ctrl_writeEnable;
   output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   output [31:0] data_writeReg;
   input [31:0] data_readRegA, data_readRegB;

	//--------------------------------------------------------------------------------------------------------------------------------------
   // Control Wires
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	wire [11:0] pc_in, pc_out, f_pc, d_pc, x_pc, m_pc, w_pc;
	wire [26:0] d_ctrl, x_ctrl, m_ctrl, w_ctrl;
	wire [31:0] d_inst, f_inst;
	wire [31:0] w_op ,m_op, d_op, x_op; 
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// I/O Data Wires
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	wire [31:0] d_a_out, d_b_out, dx_a_in, dx_b_in;
	wire [31:0] dx_a_out, dx_b_out, x_a_in, x_b_in, x_o_out, xm_o_in, xm_b_in;
	wire [31:0] xm_b_out, xm_o_out, m_ad_in, m_dt_in, m_dt_out, mw_o_in, mw_dt_in;
	wire [31:0] mw_o_out, mw_dt_out, w_dt_in, w_o_in;
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// Bypass Control
	//--------------------------------------------------------------------------------------------------------------------------------------
	wire bp_wm_dt_ctrl;
	wire bp_mx_a_ctrl, bp_wx_a_ctrl, bp_mx_b_ctrl, bp_wx_b_ctrl;
	wire bp_md_ctrl, bp_wd_ctrl;
	
	wire [4:0] bp_x_ctrl, bp_d_ctrl, bp_m_ctrl, bp_w_ctrl;
	
	// If sel0, out=in1... if sel1 or sel0&sel1, out=in2... else out=in0
	z_pmux_3 bp_mux1(.sel0(m_op[3]), .sel1(m_op[21]), .in0(m_ctrl[26:22]), .in1(5'b11111), .in2(5'b11110), .out(bp_m_ctrl));
	z_pmux_3 bp_mux2(.sel0(w_op[3]), .sel1(w_op[21]), .in0(w_ctrl[26:22]), .in1(5'b11111), .in2(5'b11110), .out(bp_w_ctrl));
	
	assign bp_d_ctrl = d_op[22] ? 5'b11110 : d_ctrl[26:22];
	assign bp_x_ctrl = x_op[22] ? 5'b11110 : x_ctrl[26:22];
	
	wire bp_mrd_wrd, bp_xrs_mrd, bp_xrs_wrd, bp_xrt_mrd, bp_xrt_wrd, bp_xrd_mrd, bp_xrd_wrd, bp_drd_mrd, bp_drd_wrd;
	z_equals_5 zeq1(.a(m_ctrl[26:22]), .b(bp_w_ctrl), .out(bp_mrd_wrd));
	z_equals_5 zeq2(.a(x_ctrl[21:17]), .b(bp_m_ctrl), .out(bp_xrs_mrd));
	z_equals_5 zeq3(.a(x_ctrl[21:17]), .b(bp_w_ctrl), .out(bp_xrs_wrd));
	z_equals_5 zeq4(.a(x_ctrl[16:12]), .b(bp_m_ctrl), .out(bp_xrt_mrd));
	z_equals_5 zeq5(.a(x_ctrl[16:12]), .b(bp_w_ctrl), .out(bp_xrt_wrd));
	z_equals_5 zeq6(.a(bp_x_ctrl), .b(bp_m_ctrl), .out(bp_xrd_mrd));
	z_equals_5 zeq7(.a(bp_x_ctrl), .b(bp_w_ctrl), .out(bp_xrd_wrd));
	z_equals_5 zeq8(.a(bp_d_ctrl), .b(bp_m_ctrl), .out(bp_drd_mrd));
	z_equals_5 zeq9(.a(bp_d_ctrl), .b(bp_w_ctrl), .out(bp_drd_wrd));
	
	
	assign bp_wm_dt_ctrl = m_op[7] && w_op[8] && (bp_mrd_wrd); // sw after a lw, if $rds are eqivalent
	

	// x_ctrl_rs == m_ctrl_rd & m_op == ALU, addi & x_op == ALU, addi, sw, lw, bne, blt
	assign bp_mx_a_ctrl = (bp_xrs_mrd) && (m_op[0] || m_op[5] || m_op[21] || m_op[3]) 
		&& (x_op[0] || x_op[5] || x_op[7] || x_op[8] || x_op[2] || x_op[6]);
	
	// x_ctrl_rs == w_ctrl_rd & w_op == ALU, addi, lw & x_op == ALU, addi, sw, lw, bne, blt
	assign bp_wx_a_ctrl = (bp_xrs_wrd) && (w_op[0] || w_op[5] || w_op[8] || w_op[21] || w_op[3]) 
		&& (x_op[0] || x_op[5] || x_op[7] || x_op[8] || x_op[2] || x_op[6]);
	
	// (x_ctrl_rt == m_ctrl_rd & x_op == ALU & m_op == ALU, addi) | (x_ctrl_rd == m_ctrl_rd & x_op == sw, bne, blt & m_op == ALU, addi)
	assign bp_mx_b_ctrl = ((bp_xrt_mrd) && x_op[0] && (m_op[0] || m_op[5] || m_op[21] || m_op[3]))
		|| ((bp_xrd_mrd) && (x_op[7] || x_op[2] || x_op[6]) && (m_op[0] || m_op[5] || m_op[21] || m_op[3]));
	
	// (x_ctrl_rt == w_ctrl_rd & x_op == ALU & w_op == ALU, addi, lw) | (x_ctrl_rd == w_ctrl_rd & x_op == sw, bne, blt & w_op == ALU, addi, lw)
	assign bp_wx_b_ctrl = ((bp_xrt_wrd) && x_op[0] && (w_op[0] || w_op[5] || w_op[8] || w_op[21] || w_op[3]))
		|| ((bp_xrd_wrd) && (x_op[7] || x_op[2] || x_op[6]) && (w_op[0] || w_op[5] || w_op[8] || w_op[21] || w_op[3]));
		
	assign bp_md_ctrl = ((bp_drd_mrd) && (d_op[4] || d_op[22]) && (m_op[0] || m_op[5] || m_op[21] || m_op[3]));
		
	assign bp_wd_ctrl = ((bp_drd_wrd) && (d_op[4] || d_op[22]) && (w_op[0] || w_op[5] || w_op[8] || w_op[21] || w_op[3]));
		
		
	//--------------------------------------------------------------------------------------------------------------------------------------
	// Stall Control
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	wire d_stall, x_stall;
	
	wire bp_ALU_op;
	assign bp_ALU_op = x_op[0] && x_alu_opcode[4] || x_alu_opcode[3] || ~x_alu_opcode[2] || ~x_alu_opcode[1];
	
	wire [4:0] stall_x_ctrl, stall_x_ctrl2;
	wire st_drd_xrd, st_drs_xrd, st_drt_xrd, st_jal_setx;
	assign stall_x_ctrl = x_op[21] ? 5'b11110 : d_ctrl[26:22];
	//z_pmux_3 st_mux1(.sel0(x_op[3]), .sel1(x_op[21]), .in0(x_ctrl[26:22]), .in1(5'b11111), .in2(5'b11110), .out(stall_x_ctrl2));
	assign stall_x_ctrl2 = d_op[22] ? 5'b11110 : d_ctrl[26:22];
	
	z_equals_5 st1(.a(d_ctrl[26:22]), .b(x_ctrl[26:22]), .out(st_drd_xrd));
	z_equals_5 st2(.a(d_ctrl[21:17]), .b(x_ctrl[26:22]), .out(st_drs_xrd));
	z_equals_5 st3(.a(d_ctrl[16:12]), .b(x_ctrl[26:22]), .out(st_drt_xrd));
	z_equals_5 st4(.a(stall_x_ctrl), .b(stall_x_ctrl2), .out(st_jal_setx));
	
	assign d_stall = ((d_ctrl[26:22] == x_ctrl[26:22]) && x_op[8] && (d_op[2] || d_op[6] || d_op[4]))
		|| ((st_drs_xrd) && x_op[8] && (d_op[0] || d_op[5] || d_op[7] || d_op[8] || d_op[2] || d_op[6]))
		|| ((st_drt_xrd) && x_op[8] && d_op[0])
		|| ((st_jal_setx) && (x_op[8] || x_op[0] || x_op[5] || x_op[21] || x_op[3]) && d_op[22]);
	assign x_stall = (x_div_op && ~div_resultRDY) || (x_mult_op && ~mult_resultRDY);
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// Program counter
	//--------------------------------------------------------------------------------------------------------------------------------------
	//program_counter my_pc(.clock(clock), .pc_in(pc_in), .pc_out(pc_out))
	z_reg_12 pc_reg(.d(pc_in), .clk(clock), .clrn(~reset), .prn(1'b1), .ena(1'b1), .q(pc_out));
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// Fetch stage
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	//f_fetch my_fetch(.clock(clock), .pc(f_pc), .inst_out(f_inst))
	//wire [11:0] pc_out_shifted;
	assign f_inst = q_imem;
	//assign pc_out_shifted = pc_out >> 2;
	assign address_imem = pc_out;
	
	// Add 1 to PC unless stalled
	wire [11:0] f_pc_inc;
	
	z_adder_select_4x8 pc_adder(.a(pc_out), .b(32'd0), .c_in(~(d_stall || x_stall)), .sum(f_pc_inc), .c_out());
	assign f_pc = f_pc_inc;
	
	// Decide whether to jump
	wire [11:0] f_ja, pc_in_a;
	wire f_do_j;
	assign f_do_j = d_do_j || x_do_j;
	assign f_ja = x_do_j ? x_pc_out : d_pc_out;
	assign pc_in = f_do_j ? f_ja : f_pc_inc;
	//assign pc_in = reset ? 12'b0 : pc_in_a;
	
	
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// F/D Latch
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	// Logic for flushing: flush when any jump occurs
	wire [31:0] fd_inst_in;
	wire fd_flush;
	assign fd_flush = f_do_j || reset;
	assign fd_inst_in = fd_flush ? 32'b0 : f_inst;
	
	//fd_latch my_fd_latch(.clock(clock), .pc_in(f_pc), .inst_in(f_inst), .pc_out(d_pc) .inst_out(d_inst));
	z_reg_12 fd_pc_reg(.d(f_pc), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(~(d_stall || x_stall)), .q(d_pc));
	z_reg_32 fd_inst_reg(.d(fd_inst_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(~(d_stall || x_stall)), .q(d_inst));
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// Decode stage
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	// Bypass logic
	wire [31:0] d_bp;
	// If sel0, out=in1... if sel1 or sel0&sel1, out=in2... else out=in0
	z_pmux_3 d_mux(.sel0(bp_wd_ctrl), .sel1(bp_md_ctrl), .in0(data_readRegB), .in1(data_writeReg), .in2(xm_o_out), .out(d_b_out));
	
	// Decode the instruction into a 32-bit 1-hot wire and a control wire
	z_decoder_32 d_op_decode(.select(d_inst[31:27]), .out(d_op));
	assign d_ctrl = d_inst[26:0];
	
	// Logic to choose whether to read rt or rd (use rd whenever it is on right side of op equation, use rt with R-types)
	wire d_use_rt;
	wire[4:0] d_readRegB;
	assign d_use_rt = d_op[0];
	assign d_readRegB = d_use_rt ? d_ctrl[16:12] : d_ctrl[26:22];
	
	
	// Process a bex instruction (22).
	wire d_sr_neq_0;
	z_neq0_32 neq(.in(d_b_out), .out(d_sr_neq_0));
	
	// $rs = a, $rt/$rd = b
	assign ctrl_readRegA = d_ctrl[21:17];
	assign ctrl_readRegB = d_readRegB;
	assign d_a_out = data_readRegA;
	//assign d_b_out = data_readRegB;
	
	
	// Jump if operation is j, jal, jr, bex
	wire [11:0] d_pc_out;
	wire d_do_j;
	assign d_pc_out = d_op[4] ? d_b_out[11:0] : d_ctrl[11:0];
	assign d_do_j = d_op[4] || d_op[3] || d_op[1] || (d_op[22] && d_sr_neq_0);
	
	// Branch prediction logic
	/*wire d_do_branch;
	z_branch_predictor(.branch_taken(x_do_j), .take_branch(d_do_branch), .branch_op(x_op[2] || x_op[6]));
	wire [31:0] d_im, d_pc_out_pre;
	z_sign_extend_17_32 dim_SE(.in(d_ctrl[16:0]), .out(d_im));
	z_adder_select_4x8 add_im_pc(.a(d_pc), .b(d_im), .c_in(1'b0), .sum(d_pc_out_pre), .c_out());*/
	
	// connect decode to D/X Latch
	assign dx_a_in = d_a_out;
	assign dx_b_in = d_b_out;
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// D/X Latch
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	// Logic for inserting no-op: flush only with a jump in execute or a stall
	wire [31:0] dx_op_in;
	wire [26:0] dx_ctrl_in;
	wire [11:0] x_pc_hold;
	wire dx_flush;
	assign dx_flush = x_do_j || d_stall || reset;
	assign dx_op_in = dx_flush ? 32'b1 : d_op;
	assign dx_ctrl_in = dx_flush ? 27'b0 : d_ctrl;
	
	//dx_latch my_dx_latch(.clock(clock), .pc_in(d_pc), .ctrl_in(d_ctrl), .op_in(d_op), .a_in(dx_a_in), .b_in(dx_b_in), .pc_out(x_pc), 
	//	.ctrl_out(x_ctrl), .op_out(x_op)), .a_out(dx_a_out), .b_out(dx_b_out);
	z_reg_12 dx_pc_reg(.d(d_pc), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(~x_stall), .q(x_pc));
	z_reg_12 dx_pc_hold(.d(x_pc), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(x_pc_hold));
	z_reg_32 dx_op_reg(.d(dx_op_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(~x_stall), .q(x_op));
	z_reg_27 dx_ctrl_reg(.d(dx_ctrl_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(~x_stall), .q(x_ctrl));
	z_reg_32 dx_a_reg(.d(dx_a_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(~x_stall), .q(dx_a_out));
	z_reg_32 dx_b_reg(.d(dx_b_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(~x_stall), .q(dx_b_out));
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// Execute stage
	//--------------------------------------------------------------------------------------------------------------------------------------
	//x_execute my_execute(.clock(clock), .op_in(x_op), .ctrl_in(x_ctrl), .a_in(x_a_in), .b_in(x_b_in), .o_out(x_o_out));
	
	// Bypass logic
	
	wire [31:0] x_bp_b, x_bp_a;
	// If sel0, out=in1... if sel1 or sel0&sel1, out=in2... else out=in0
	z_pmux_3 x_a_mux(.sel0(bp_wx_a_ctrl), .sel1(bp_mx_a_ctrl), .in0(dx_a_out), .in1(data_writeReg), .in2(xm_o_out), .out(x_bp_a));
	z_pmux_3 x_b_mux(.sel0(bp_wx_b_ctrl), .sel1(bp_mx_b_ctrl), .in0(dx_b_out), .in1(data_writeReg), .in2(xm_o_out), .out(x_bp_b));
	
	
	
	assign x_a_in = x_bp_a;
	
	// Logic to sign extend immediate and choose x_b_in depending on addi, lw, sw, and setx instruction (x_op[5], [7], [8], [21])
	wire x_use_im;
	assign x_use_im = x_op[5] || x_op[7] || x_op[8] || x_op[21];
	wire [31:0] x_b_im;
	z_sign_extend_17_32 im_SE(.in(x_ctrl[16:0]), .out(x_b_im));
	assign x_b_in = x_use_im ? x_b_im : x_bp_b;
	
	
	// ALU to compute output
	wire x_ne, x_lt, x_of, x_alu_of;
	wire [4:0] x_alu_opcode;
	wire [31:0] x_alu_result;
	//assign x_alu_opcode = x_use_im ? 5'b0 : x_ctrl[6:2];
	z_pmux_3 x_alu_mux(.sel0(x_use_im), .sel1(x_op[6]), .in0(x_ctrl[6:2]), .in1(5'b0), .in2(5'b1), .out(x_alu_opcode));
	
	x_alu my_alu(.data_operandA(x_a_in), .data_operandB(x_b_in), .ctrl_ALUopcode(x_alu_opcode), .ctrl_shiftamt(x_ctrl[11:7]), 
		.data_result(x_alu_result), .isNotEqual(x_ne), .isLessThan(x_lt), .overflow(x_alu_of));
	wire alu_resultRDY;
	assign alu_resultRDY = x_alu_opcode[4] || x_alu_opcode[3] || ~x_alu_opcode[2] || ~x_alu_opcode[1];
		
		
	// Multiplication logic
	wire mult_overflow, mult_resultRDY, ctrl_MULT, x_mult_op;
	assign ctrl_MULT = (x_pc != x_pc_hold) && x_mult_op;
	wire [31:0] A_hold, B_hold, mult_result, mult_a_in, mult_b_in;
	assign mult_a_in = ctrl_MULT ? x_a_in : A_hold;
	assign mult_b_in = ctrl_MULT ? x_b_in : B_hold;
	assign x_mult_op = ~x_alu_opcode[4] && ~x_alu_opcode[3] && x_alu_opcode[2] && x_alu_opcode[1] && ~x_alu_opcode[0];
	z_reg_32 op_A_hold(.d(x_a_in), .clk(~clock), .clrn(1'b1), .prn(1'b1), .ena(ctrl_MULT), .q(A_hold));
	z_reg_32 op_B_hold(.d(x_b_in), .clk(~clock), .clrn(1'b1), .prn(1'b1), .ena(ctrl_MULT), .q(B_hold));
	x_mult my_mult(.a(A_hold), .b(B_hold), .result(mult_result), .data_exception(mult_overflow));
	x_mult_shiftreg mdelay(.d(ctrl_MULT), .clk(~clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(mult_resultRDY));
	
	
	// Division logic
	wire [31:0] div_out, sdiv_out, div_result, pos_out;
	wire negAnswer, hold_negAnswer, div_by_0, div_by_0_hold, udiv_done, x_div_op;
	wire div_resultRDY, ctrl_DIV;
	
	assign ctrl_DIV = (x_pc != x_pc_hold) && x_div_op;
	assign x_div_op = ~x_alu_opcode[4] && ~x_alu_opcode[3] && x_alu_opcode[2] && x_alu_opcode[1] && x_alu_opcode[0];
	//z_dflipflop d_assert_reg(.d(1'b1), .q(div_resultRDY), .clk(clock), .ena(1'b1), .clrn(1'b1), .prn(1'b1));
	x_div my_div(.dividend(x_a_in), .divisor_in(x_b_in), .clock(clock), .div_asserted(ctrl_DIV), .result(div_out), .error(div_by_0));
	z_shiftreg_32 ddelay(.d(ctrl_DIV), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(udiv_done));
	
	z_dflipflop shiftreg_1(.d(udiv_done), .q(div_resultRDY), .clk(clock), .ena(1'b1), .clrn(1'b1), .prn(1'b1));
	z_reg_32 div_res(.d(div_out), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(udiv_done), .q(sdiv_out));
	
	xor myXor(negAnswer, x_a_in[31], x_b_in[31]);
	z_dflipflop dffe(.d(negAnswer), .q(hold_negAnswer), .clk(clock), .ena(ctrl_DIV), .clrn(1'b1), .prn(1'b1));
	z_dflipflop div_error(.d(div_by_0), .q(div_by_0_hold), .clk(clock), .ena(ctrl_DIV), .clrn(1'b1), .prn(1'b1));
	
	x_negator n2(.in(sdiv_out), .out(pos_out));
	assign div_result = hold_negAnswer ? pos_out : sdiv_out;
	
	// Logic to choose between ALU, mult, and div for execute output	
	wire [31:0] x_multdiv_result;
	
	//assign data_exception = div_resultRDY ? div_by_0_hold : mult_overflow;
	assign x_multdiv_result = div_resultRDY ? div_result : mult_result;
	assign x_o_out = (div_resultRDY || mult_resultRDY) ? x_multdiv_result : x_alu_result;
	
	// Logic to compute whether to jump
	wire [11:0] x_pc_out;
	wire x_do_j;
	assign x_do_j = (x_op[2] && x_ne) || (x_op[6] && x_lt); //ops for bne, blt	
	
	// Logic to compute jump address
	z_adder_select_4x8 z_add_im_pc(.a(x_pc), .b(x_b_im), .c_in(1'b0), .sum(x_pc_out), .c_out());
	
	// Insert $rd = 30 and error value into control and data signals if overflow (exception) occurs.
	wire [26:0] x_ctrl_out;
	wire [31:0] x_o_out_ex;
	wire x_add_op, x_addi_op, x_sub_op;
	
	assign x_of = (x_alu_of && ~x_mult_op && ~x_div_op) || (mult_overflow && x_mult_op) || (div_by_0_hold && x_div_op);
	
	assign x_add_op = ~x_alu_opcode[4] && ~x_alu_opcode[3] && ~x_alu_opcode[2] && ~x_alu_opcode[1] && ~x_alu_opcode[0] && x_op[0];
	assign x_addi_op = ~x_alu_opcode[4] && ~x_alu_opcode[3] && ~x_alu_opcode[2] && ~x_alu_opcode[1] && ~x_alu_opcode[0] && x_op[5];
	assign x_sub_op = ~x_alu_opcode[4] && ~x_alu_opcode[3] && ~x_alu_opcode[2] && ~x_alu_opcode[1] && x_alu_opcode[0] && x_op[0];
	
	assign x_o_out_ex = x_add_op ? 32'd1 : 32'bz;
	assign x_o_out_ex = x_addi_op ? 32'd2 : 32'bz;
	assign x_o_out_ex = x_sub_op ? 32'd3 : 32'bz;
	assign x_o_out_ex = x_mult_op ? 32'd4 : 32'bz;
	assign x_o_out_ex = x_div_op ? 32'd5 : 32'bz;
	
	assign x_ctrl_out[21:0] = x_ctrl[21:0];
	assign x_ctrl_out[26:22] = x_of ? 5'b11110 : x_ctrl[26:22];
	
	// Assign outputs to latch inputs
	assign xm_o_in =  x_of ? x_o_out_ex : x_o_out;
	assign xm_b_in = x_bp_b;
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// X/M Latch
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	wire [31:0] xm_op_in;
	wire [26:0] xm_ctrl_in;
	assign xm_op_in = (x_stall || reset) ? 32'b1 : x_op;
	assign xm_ctrl_in = (x_stall || reset) ? 27'b0 : x_ctrl_out;
	
	
	
	z_reg_12 xm_pc_reg(.d(x_pc), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(m_pc));
	z_reg_32 xm_op_reg(.d(xm_op_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(m_op));
	z_reg_27 xm_ctrl_reg(.d(xm_ctrl_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(m_ctrl));
	z_reg_32 xm_o_reg(.d(xm_o_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(xm_o_out));
	z_reg_32 xm_b_reg(.d(xm_b_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(xm_b_out));
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// Memory stage
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	//m_memory my_memory(.clock(clock), .op_in(m_op), .ctrl_in(m_ctrl), .address(m_ad_in), .data_in(m_dt_in), .data_out(m_dt_out));
	
	// Bypass logic
	wire [31:0] m_bp_dt;
	assign m_bp_dt = bp_wm_dt_ctrl ? data_writeReg : xm_b_out;
	
	
	// Connect X/M latch to Memory stage
	assign m_ad_in = xm_o_out;
	assign m_dt_in = m_bp_dt;
	
	assign address_dmem = m_ad_in[11:0];
   assign data = m_dt_in;
   assign wren = m_op[7]; //SW operation
   assign m_dt_out = q_dmem;
	
	// Connect Memory stage to 
	assign mw_o_in = xm_o_out;
	assign mw_dt_in = m_dt_out;
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// M/W Latch
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	wire [31:0] mw_op_in;
	wire [26:0] mw_ctrl_in;
	assign mw_op_in = reset ? 32'b1 : m_op;
	assign mw_ctrl_in = reset ? 27'b0 : m_ctrl;
	
	z_reg_12 mw_pc_reg(.d(m_pc), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(w_pc));
	z_reg_32 mw_op_reg(.d(mw_op_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(w_op));
	z_reg_27 mw_ctrl_reg(.d(mw_ctrl_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(w_ctrl));
	z_reg_32 mw_o_reg(.d(mw_o_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(mw_o_out));
	z_reg_32 mw_dt_reg(.d(mw_dt_in), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(mw_dt_out));
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	// Write-back stage
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	assign w_o_in = mw_o_out;
	assign w_dt_in = mw_dt_out;
	
	
	wire w_do_write;
	// ALU op, addi, lw, jal(but to $31 only)
	assign w_do_write = w_op[0] || w_op[5] || w_op[8] || w_op[3];
	assign ctrl_writeEnable = w_do_write;
	// TODO: mux to choose between w_ctrl[26:22]/$31 = 5'b11111 and $30 = 5'b11110 depending on w_op[21] (setx)
	
	// D-W bypassing for jal
	wire [31:0] w_pc_in, w_j_or_o;
	assign w_pc_in[11:0] = w_pc;
	
	// If sel0, out=in1... if sel1 or sel0&sel1, out=in2... else out=in0
	z_pmux_3 w_mux(.sel0(w_op[3]), .sel1(w_op[21]), .in0(w_ctrl[26:22]), .in1(5'b11111), .in2(5'b11110), .out(ctrl_writeReg));
	//assign ctrl_writeReg = w_op[3] ? 5'b11111 : w_ctrl[26:22];
	
	assign w_j_or_o = w_op[3] ? w_pc : w_o_in;
	
	// LW operation
	assign data_writeReg = w_op[8] ? w_dt_in : w_j_or_o;
	

endmodule