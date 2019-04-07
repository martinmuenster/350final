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
module processor(clock, reset, address_imem, q_imem, address_dmem,data,wren,q_dmem, ctrl_writeEnable, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg,data_readRegA, data_readRegB,
    dx_pc_out, dx_instr_out, dx_regA_out, dx_regB_out,
    alu_data_operandA, alu_data_operandB, alu_dataResult, alu_ctrl_ALUopcode,
    xm_alu_res_out, 
    is_bypass_MX_regB, xm_instr_we, writing_xm_into_reg0, bypass_dxrd_equal_xmrd, bypass_dxrs_equal_xmrd, bypass_dxrt_equal_xmrd
    );
    // Control signals
    input clock; // I: The master clock
    input reset; // I: A reset signals

    // Imem
    output [11:0] address_imem; // O: The address of the data to get from imem
    input [31:0] q_imem; // I: The data from imem

    // Dmem
    output [11:0] address_dmem; // O: The address of the data to get or put from/to dmem
    output [31:0] data; // O: The data to write to dmem
    output wren; // O: Write enable for dmem
    input [31:0] q_dmem; // I: The data from dmem

    // Regfile
    output ctrl_writeEnable;  // O: Register to write to in regfile
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB; // O: Register to read from port A of regfile, // O: Register to read from port B of regfile
    output [31:0] data_writeReg; // O: Data to write to for regfile
    input [31:0] data_readRegA, data_readRegB; // I: Data from port A of regfile  // I: Data from port B of regfile





    /* YOUR CODE STARTS HERE */
     /* ####################################################################################################
                                            Define global wires
        #################################################################################################### */
        wire [31:0] no_op;
        wire is_multdiv_d, is_not_stalled_and_not_multdiv, isMultdiv_stall;

        // Pipeline wires
        wire [31:0] fd_pc_in, fd_instr_in, fd_pc_out, fd_instr_out;
        wire [31:0] dx_pc_in, dx_instr_in, dx_regA_input, dx_regB_input, dx_regB_out;
        wire [31:0] xm_pc_in, xm_instr_in, xm_alu_res_in, xm_regB_in, xm_pc_out, xm_instr_out, xm_B_out;
        wire [31:0] mw_pc_in, mw_instr_in, mw_alu_res_in, mw_pc_out, mw_instr_out, mw_dmem_out, mw_alu_res_out;

        // Testing outputs
        output [31:0] dx_pc_out, dx_instr_out, dx_regA_out, dx_regB_out;
        output [31:0] alu_data_operandA, alu_data_operandB, alu_dataResult;
        output [4:0] alu_ctrl_ALUopcode;
        output [31:0] xm_alu_res_out;

        // Bypass/Stall wires
        wire isStall, is_bypass_WD_regA, is_bypass_WD_regB, is_bypass_WX_regA, is_bypass_MX_regA, is_bypass_WX_regB, is_bypass_MX_regB, is_bypass_WM;
        output is_bypass_MX_regB, xm_instr_we, writing_xm_into_reg0, bypass_dxrd_equal_xmrd, bypass_dxrs_equal_xmrd, bypass_dxrt_equal_xmrd;
        // assign isStall = 1'b0;
        // assign is_bypass_WD_regA = 1'b0;
        // assign is_bypass_WD_regB = 1'b0;
        // assign is_bypass_WX_regA = 1'b0;
        // assign is_bypass_MX_regA = 1'b0;
        // assign is_bypass_WX_regB = 1'b0;
        // assign is_bypass_MX_regB = 1'b0;
        // assign is_bypass_WM = 1'b0;

    /* ####################################################################################################
                                    Bypassing and Stalling Functions
       #################################################################################################### */ 
        /* STALL FETCH STAGE */
            // Stall Logic (only occurs on lw followed by certain instructions. 
            stall_logic sl1(.fd_instr(fd_instr_out), .dx_instr(dx_instr_out), .isStall(isStall));
        /* BYPASS TO DECODE STAGE */
            // Bypass Writeback data to regA in Decode Stage
            bypass_WD_regA bWDA(.fd_instr(fd_instr_out), .mw_instr(mw_instr_out), .is_bypass_WD_regA(is_bypass_WD_regA));
            // Bypass Writeback data to regB in Decode Stage
            bypass_WD_regB bWDB(.fd_instr(fd_instr_out), .mw_instr(mw_instr_out), .is_bypass_WD_regB(is_bypass_WD_regB));
        /* BYPASS TO EXECUTE STAGE */
            // Bypass Writeback data to input of Execute (regA) -- Mutually exclusive to is_bypass_MX_regA
            bypass_WX_regA bWXA(.dx_instr(dx_instr_out), .xm_instr(xm_instr_out), .mw_instr(mw_instr_out), .is_bypass_WX_regA(is_bypass_WX_regA));
            // Bypass Memory to input of Execute (regA) -- Mutually exclusive to is_bypass_WX_regA
            bypass_MX_regA bMXA(.dx_instr(dx_instr_out), .xm_instr(xm_instr_out), .mw_instr(mw_instr_out), .is_bypass_MX_regA(is_bypass_MX_regA));
            // Bypass Writeback data to input of Execute (reg B) -- Mutually exclusive to is_bypass_MX_regB
            bypass_WX_regB bWXB(.dx_instr(dx_instr_out), .xm_instr(xm_instr_out), .mw_instr(mw_instr_out), .is_bypass_WX_regB(is_bypass_WX_regB));
            // Bypass Memory to input of Execute (regA) -- Mutually exclusive to is_bypass_WX_regA
            bypass_MX_regB bMXB(.dx_instr(dx_instr_out), .xm_instr(xm_instr_out), .mw_instr(mw_instr_out), .is_bypass_MX_regB(is_bypass_MX_regB));      
        /* BYPASS TO MEMORY STAGE */
            // Bypass Writeback data to input of dmem.
            bypass_WM bM(.xm_instr(xm_instr_out), .mw_instr(mw_instr_out), .is_bypass_WM(is_bypass_WM));
     /* ####################################################################################################
                                                    Global Variables
        #################################################################################################### */
            assign no_op = 32'b0;
            assign is_not_stalled_and_not_multdiv = ~(isStall | isMultdiv_stall);
            assign isMultdiv_stall = 1'b0;
	 /*	####################################################################################################
												    Fetch
		#################################################################################################### */
        // Wires 
            wire isBranchJumpJal, branchjumpjalled, stalled, dummy_cout;
            wire [31:0] pc_next, pc;
			wire [31:0] pc_increment, pc_after_branching, fetch_prev_instr, instr, pre_decode_instr_in;
            wire [31:0] f_temp1_instr, f_temp2_instr;
        // Logic
            // Memory about whether branch or stalled occured in previous instructions.
            // fetch pc logic
            reg_32 pc1(.in(pc_next), .clk(~clock), .clrn(~reset), .enable(~isStall), .out(pc));
            cselect_adder_32 pc_increment1(.in1(pc), .in2(32'b0), .cin(1'b1), .s(pc_increment), .cout(dummy_cout));
            assign pc_next = isBranchJumpJal ? pc_after_branching : pc_increment;
            // fetch instruction logic
            assign f_temp1_instr = isStall ? fd_instr_out : instr;
            assign f_temp2_instr = isBranchJumpJal ? no_op : f_temp1_instr;
        // FD Pipeline Registers
            assign fd_pc_in = pc;
            assign fd_instr_in = f_temp2_instr;

            reg_32 fetch_to_decode_pc1(.in(fd_pc_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(fd_pc_out));
            reg_32 fetch_to_decode_instr2(.in(fd_instr_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(fd_instr_out));


     /* ####################################################################################################
                                                    Decode
        #################################################################################################### */
        // Logic
            find_ctrl_readRegA ctrl_reg_a1(.instr(dx_instr_in), .ctrl_readRegA(ctrl_readRegA));
            find_ctrl_readRegB ctrl_reg_b1(.instr(dx_instr_in), .ctrl_readRegB(ctrl_readRegB));
            is_multdiv_d_op is_multdiv_d1(.instr(dx_instr_in), .is_multdiv(is_multdiv_d));

        // DX Pipeline Register
            assign dx_pc_in = fd_pc_out;
            assign dx_instr_in = (isBranchJumpJal | isStall) ? no_op : fd_instr_out;
            assign dx_regA_input = is_bypass_WD_regA ? data_writeReg : data_readRegA;
            assign dx_regB_input = is_bypass_WD_regB ? data_writeReg : data_readRegB;
            reg_32 decode_to_execute_pc1(.in(dx_pc_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(dx_pc_out));
            reg_32 decode_to_execute_instr1(.in(dx_instr_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(dx_instr_out));
            reg_32 decode_to_execute_regA1(.in(dx_regA_input), .clk(clock), .clrn(~reset), .enable(1'b1), .out(dx_regA_out));
            reg_32 decode_to_execute_regB1(.in(dx_regB_input), .clk(clock), .clrn(~reset), .enable(1'b1), .out(dx_regB_out));

     /* ####################################################################################################
                                                    Execute
        #################################################################################################### */
        // Wires
            wire[31:0] rstatus, next_rstatus, xm_pc_branch_out;
            wire [4:0] alu_ctrl_shiftamt;
            wire[1:0] ctrl_bypassA, ctrl_bypassB;
            wire alu_isNotEqual, alu_isLessThan, alu_overflow, alu_isMultDiv;
            wire [31:0] no_bypass_regA, post_check1_regA, post_bypass_regA;
            wire [31:0] no_bypass_regB, post_check1_regB, post_bypass_regB;
            wire use_pseudo_setx_instr, execute_is_setx; 
            wire [31:0] pseudo_setx_instr;
        // Execute Bypass Implement

            assign no_bypass_regA = dx_regA_out;
            assign post_check1_regA = is_bypass_MX_regA ? xm_alu_res_out : no_bypass_regA;
            assign post_bypass_regA = is_bypass_WX_regA ? data_writeReg : post_check1_regA;

            assign no_bypass_regB =  dx_regB_out;
            assign post_check1_regB = is_bypass_MX_regB ? xm_alu_res_out : no_bypass_regB;
            assign post_bypass_regB = is_bypass_WX_regB ? data_writeReg : post_check1_regB;

        // Logic
            /* TODO: add logic to check if multdiv is currently in process. -- lots of work */

            // Alu Logic
            get_alu_inputs get_alu_inputs1(.dx_instr_out(dx_instr_out),  .post_bypass_regA(post_bypass_regA), .post_bypass_regB(post_bypass_regB), .alu_data_operandA(alu_data_operandA), .alu_data_operandB(alu_data_operandB), .alu_ctrl_ALUopcode(alu_ctrl_ALUopcode), .alu_ctrl_shiftamt(alu_ctrl_shiftamt));
            alu pipeline_alu1(.data_operandA(alu_data_operandA), .data_operandB(alu_data_operandB), .ctrl_ALUopcode(alu_ctrl_ALUopcode), .ctrl_shiftamt(alu_ctrl_shiftamt), .data_result(alu_dataResult), .isNotEqual(alu_isNotEqual), .isLessThan(alu_isLessThan), .overflow(alu_overflow)); 
            /* TODO: Implement, alu_isMultDiv(alu_isMultDiv) */

            // Branch Instruction Logic

            execute_branch_logic execute_branch_logic1(.dx_instr_out(dx_instr_out), .dx_pc_out(dx_pc_out), .neq(alu_isNotEqual), .lt(alu_isLessThan), .alu_data_operandA(alu_data_operandA), .pc_after_branching(pc_after_branching), .isBranchJumpJal(isBranchJumpJal), .rstatus(rstatus));
			
            // Rstatus Logic (TODO)

            get_next_rstatus get_next_rstatus1(.dx_instr_out(dx_instr_out), .alu_overflow(alu_overflow), .pseudo_setx_instr(pseudo_setx_instr), .use_pseudo_setx_instr(use_pseudo_setx_instr), .next_rstatus(next_rstatus), .execute_is_setx(execute_is_setx));
            reg_32 rstatus_reg(.in(next_rstatus), .clk(clock), .clrn(~reset), .enable(use_pseudo_setx_instr | execute_is_setx), .out(rstatus));
            
        // XM Pipeline Registers
            assign xm_pc_in = dx_pc_out;
            assign xm_instr_in = use_pseudo_setx_instr ? pseudo_setx_instr : dx_instr_out; // rstatus logic.
            assign xm_alu_res_in = alu_dataResult;
            assign xm_regB_in = dx_regB_out;
            reg_32 execute_to_memory_pc1(.in(xm_pc_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(xm_pc_out));
            reg_32 execute_to_memory_instr1(.in(xm_instr_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(xm_instr_out));
            reg_32 execute_to_memory_alu_output1(.in(xm_alu_res_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(xm_alu_res_out));
            reg_32 execute_to_memory_regB1(.in(xm_regB_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(xm_B_out));
     /* ####################################################################################################
                                                    Memory
        #################################################################################################### */
        // Wires
            wire [31:0] xm_data_operandB_dmem_inp;
            wire is_sw_m; 
        // Logic
            is_sw_m is_sw_logic1(.xm_instr_out(xm_instr_out), .is_sw_m(is_sw_m));
        // Bypass Logic
            assign xm_data_operandB_dmem_inp = is_bypass_WM ? data_writeReg : xm_B_out;
        // MW pipeline Registers
            assign mw_pc_in = xm_pc_out;
            assign mw_instr_in = xm_instr_out;
            assign mw_alu_res_in = xm_alu_res_out;
            // README mw_dmem_out --- output of dmem. --- important for lw instruction
            reg_32 memory_to_writeback_pc1(.in(mw_pc_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(mw_pc_out));
            reg_32 memory_to_writeback_instr1(.in(mw_instr_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(mw_instr_out));
            reg_32 memory_to_writeback_alu_output1(.in(mw_alu_res_in), .clk(clock), .clrn(~reset), .enable(1'b1), .out(mw_alu_res_out));

     /* ####################################################################################################
                                                    Writeback
        #################################################################################################### */

        get_ctrl_writeReg get_ctrl_writeReg1(.instr(mw_instr_out), .ctrl_writeReg(ctrl_writeReg));
        get_data_writeReg get_data_writeReg1(.instr(mw_instr_out), .mw_alu_res_out(mw_alu_res_out), .mw_dmem_out(mw_dmem_out), .mw_pc_out(mw_pc_out), .data_writeReg(data_writeReg));
        get_ctrl_writeEnable get_we1(.instr(mw_instr_out), .ctrl_writeEnable(ctrl_writeEnable));

     /* ####################################################################################################
                                            Memory Instructions
        #################################################################################################### */
		  // Dmem:
			  // Outputs
			  assign wren = is_sw_m;
			  assign data = xm_data_operandB_dmem_inp;  // In ctrl_reg_B, I store the sw into data_readRegB.
			  assign address_dmem = xm_alu_res_out[11:0];
			  // Inputs
			  assign mw_dmem_out = q_dmem;
		  // Imem:
			  // Outputs
			  assign address_imem = pc[11:0];
			  // Input
		  	  assign instr = q_imem;
endmodule