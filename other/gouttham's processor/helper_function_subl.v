// Stall Code
module stall_logic(fd_instr, dx_instr, isStall);
    input [31:0] fd_instr, dx_instr;
    output isStall;

    wire [4:0] dx_rd, fd_opcode, fd_rd, fd_rs, fd_rt, dx_opcode;
    // Decode latch instructions
    decode_general_instr dgi_mw1(.instr(dx_instr), .rd(dx_rd), .opcode(dx_opcode));
    decode_general_instr dgi_fd2(.instr(fd_instr), .opcode(fd_opcode), .rd(fd_rd), .rs(fd_rs), .rt(fd_rt));

    // Decode opcode (Requirement: decode_general_instr)
    wire fd_neq, fd_lt, fd_is_alu_op_excluding_addi, fd_is_addi, fd_is_sw, fd_is_lw, fd_is_j, fd_is_bne, fd_is_jal, fd_is_jr, fd_is_blt, fd_is_bex_wo_rstatus, fd_is_setx;
    assign fd_neq = 1'b1; // Before computing neq in alu. checking if opcodes match
    assign fd_lt = 1'b1; // Before computing lt in alu. checking if opcodes match
    decode_opcode doc1(.opcode(fd_opcode), .neq(fd_neq), .lt(fd_lt), .is_alu_op_excluding_addi(fd_is_alu_op_excluding_addi), .is_addi(fd_is_addi), .is_sw(fd_is_sw), .is_lw(fd_is_lw), .is_j(fd_is_j), .is_bne(fd_is_bne), .is_jal(fd_is_jal), .is_jr(fd_is_jr), .is_blt(fd_is_blt), .is_bex_wo_rstatus(fd_is_bex_wo_rstatus), .is_setx(fd_is_setx));

    // Decode opcode (Requirement: decode_general_instr)
    wire dx_is_lw;
    decode_opcode doc2(.opcode(dx_opcode), .neq(1'b0), .lt(1'b0), .is_lw(dx_is_lw));


    // Check if the same register number is accessed in 2 different locations of the pipeline.  
    wire fdrs_equal_dxrd, fdrd_equal_dxrd, fdrt_equal_dxrd;
    equal5 fdrs_equal_dxrd1(fd_rs, dx_rd, fdrs_equal_dxrd);
    equal5 fdrd_equal_dxrd2(fd_rd, dx_rd, fdrd_equal_dxrd);
    equal5 fdrt_equal_dxrd3(fd_rt, dx_rd, fdrt_equal_dxrd);

    wire writing_dx_into_reg0;
    equal5 dx_instr_rd0(dx_rd, 5'b0, writing_dx_into_reg0);

    wire rtype_stall, itype_stall;
    assign rtype_stall = (fd_is_alu_op_excluding_addi) & (fdrs_equal_dxrd || fdrt_equal_dxrd) & dx_is_lw & ~writing_dx_into_reg0;
    assign itype_stall = (fd_is_bne | fd_is_blt | fd_is_jr | fd_is_lw | fd_is_sw | fd_is_addi) & (fdrs_equal_dxrd || fdrd_equal_dxrd) & dx_is_lw & ~writing_dx_into_reg0;

    assign isStall = itype_stall | rtype_stall;
endmodule

// Bypass Code
module bypass_WD_regA(fd_instr, mw_instr, is_bypass_WD_regA);
    input [31:0] fd_instr, mw_instr;
    output is_bypass_WD_regA;

    wire mw_instr_we, writing_mw_into_reg0, fdrs_equal_mwrd, fdrd_equal_mwrd;
    wire [4:0] mw_rd, fd_opcode, fd_rd, fd_rs, fd_rt;

    // Decode latch instructions
    decode_general_instr dgi_mw1(.instr(mw_instr), .rd(mw_rd));
    decode_general_instr dgi_mw2(.instr(fd_instr), .opcode(fd_opcode), .rd(fd_rd), .rs(fd_rs), .rt(fd_rt));


    // Instructions that writeback to register
    get_ctrl_writeEnable we_mw1(mw_instr, mw_instr_we);
    equal5 mw_instr_rd0(mw_rd, 5'b0, writing_mw_into_reg0);

    equal5 fdrs_equal_mwrd1(fd_rs, mw_rd, fdrs_equal_mwrd);
    equal5 fdrd_equal_mwrd2(fd_rd, mw_rd, fdrd_equal_mwrd);


    // Decode opcode (Requirement: decode_general_instr)
    wire fd_neq, fd_lt, fd_is_alu_op_excluding_addi, fd_is_addi, fd_is_sw, fd_is_lw, fd_is_j, fd_is_bne, fd_is_jal, fd_is_jr, fd_is_blt, fd_is_bex_wo_rstatus, fd_is_setx;
    assign fd_neq = 1'b1; // Before computing neq in alu. checking if opcodes match
    assign fd_lt = 1'b1; // Before computing lt in alu. checking if opcodes match
    decode_opcode doc(.opcode(fd_opcode), .neq(fd_neq), .lt(fd_lt), .is_alu_op_excluding_addi(fd_is_alu_op_excluding_addi), .is_addi(fd_is_addi), .is_sw(fd_is_sw), .is_lw(fd_is_lw), .is_j(fd_is_j), .is_bne(fd_is_bne), .is_jal(fd_is_jal), .is_jr(fd_is_jr), .is_blt(fd_is_blt), .is_bex_wo_rstatus(fd_is_bex_wo_rstatus), .is_setx(fd_is_setx));

     wire bypass_fdrs_equal_mwrd, bypass_fdrd_equal_mwrd;
    assign bypass_fdrs_equal_mwrd = (fd_is_alu_op_excluding_addi | fd_is_lw | fd_is_sw | fd_is_addi) & fdrs_equal_mwrd;
    assign bypass_fdrd_equal_mwrd = (fd_is_blt | fd_is_jr | fd_is_bne) & fdrd_equal_mwrd;

    assign is_bypass_WD_regA = mw_instr_we & ~writing_mw_into_reg0 & (bypass_fdrd_equal_mwrd | bypass_fdrs_equal_mwrd);
endmodule

module bypass_WD_regB(fd_instr, mw_instr, is_bypass_WD_regB);
    input [31:0] fd_instr, mw_instr;
    output is_bypass_WD_regB;

    wire mw_instr_we, writing_mw_into_reg0, fdrs_equal_mwrd, fdrd_equal_mwrd;
    wire [4:0] mw_rd, fd_opcode, fd_rd, fd_rs, fd_rt;

    // Decode latch instructions
    decode_general_instr dgi_mw1(.instr(mw_instr), .rd(mw_rd));
    decode_general_instr dgi_fd2(.instr(fd_instr), .opcode(fd_opcode), .rd(fd_rd), .rs(fd_rs), .rt(fd_rt));


    // Instructions that writeback to register
    get_ctrl_writeEnable we_mw1(mw_instr, mw_instr_we);

    // Check if the same register number is accessed in 2 different locations of the pipeline. 
     wire fdrt_equal_mwrd;
    equal5 fdrs_equal_mwrd1(fd_rs, mw_rd, fdrs_equal_mwrd);
    equal5 fdrd_equal_mwrd2(fd_rd, mw_rd, fdrd_equal_mwrd);
    equal5 fdrd_equal_mwrd3(fd_rt, mw_rd, fdrt_equal_mwrd);

    // Check if writeback is writing into $0.
    equal5 mw_instr_rd0(mw_rd, 5'b0, writing_mw_into_reg0);

    // Decode opcode (Requirement: decode_general_instr)
    wire fd_neq, fd_lt, fd_is_alu_op_excluding_addi, fd_is_addi, fd_is_sw, fd_is_lw, fd_is_j, fd_is_bne, fd_is_jal, fd_is_jr, fd_is_blt, fd_is_bex_wo_rstatus, fd_is_setx;
    assign fd_neq = 1'b1; // Before computing neq in alu. checking if opcodes match
    assign fd_lt = 1'b1; // Before computing lt in alu. checking if opcodes match
    decode_opcode doc1(.opcode(fd_opcode), .neq(fd_neq), .lt(fd_lt), .is_alu_op_excluding_addi(fd_is_alu_op_excluding_addi), .is_addi(fd_is_addi), .is_sw(fd_is_sw), .is_lw(fd_is_lw), .is_j(fd_is_j), .is_bne(fd_is_bne), .is_jal(fd_is_jal), .is_jr(fd_is_jr), .is_blt(fd_is_blt), .is_bex_wo_rstatus(fd_is_bex_wo_rstatus), .is_setx(fd_is_setx));

     wire bypass_fdrd_equal_mwrd, bypass_fdrs_equal_mwrd, bypass_fdrt_equal_mwrd;
    assign bypass_fdrd_equal_mwrd = (fd_is_lw | fd_is_sw) & fdrd_equal_mwrd;
    assign bypass_fdrs_equal_mwrd = (fd_is_blt | fd_is_jr | fd_is_bne) & fdrs_equal_mwrd;
    assign bypass_fdrt_equal_mwrd = (fd_is_alu_op_excluding_addi) & fdrt_equal_mwrd;

    assign is_bypass_WD_regB = mw_instr_we & ~writing_mw_into_reg0 & (bypass_fdrd_equal_mwrd | bypass_fdrs_equal_mwrd | bypass_fdrt_equal_mwrd);
endmodule

module bypass_WX_regA(dx_instr, xm_instr, mw_instr, is_bypass_WX_regA);
    input [31:0] dx_instr, xm_instr, mw_instr;
    output is_bypass_WX_regA;

    wire [4:0] dx_opcode, dx_rd, dx_rs, dx_rt, xm_rd, mw_rd;
    wire mw_instr_we, dxrs_equal_mwrd, dxrd_equal_mwrd, dxrt_equal_mwrd, dxrs_equal_xmrd, dxrd_equal_xmrd, dxrt_equal_xmrd, writing_mw_into_reg0;
    // Decode latch instructions
    decode_general_instr dgi_dx1(.instr(dx_instr), .opcode(dx_opcode), .rd(dx_rd), .rs(dx_rs), .rt(dx_rt));  
    decode_general_instr dgi_xm2(.instr(xm_instr), .rd(xm_rd));  
    decode_general_instr dgi_mw3(.instr(mw_instr), .rd(mw_rd));


    // Calculate WE
    get_ctrl_writeEnable we_mw1(mw_instr, mw_instr_we);


    // Check if the same register number is accessed in 2 different locations of the pipeline.  
    equal5 fdrs_equal_mwrd1(dx_rs, mw_rd, dxrs_equal_mwrd);
    equal5 fdrd_equal_mwrd2(dx_rd, mw_rd, dxrd_equal_mwrd);
    equal5 fdrt_equal_mwrd3(dx_rt, mw_rd, dxrt_equal_mwrd);

    equal5 fdrs_equal_xmrd1(dx_rs, xm_rd, dxrs_equal_xmrd);
    equal5 fdrd_equal_xmrd2(dx_rd, xm_rd, dxrd_equal_xmrd);
    equal5 fdrt_equal_xmrd3(dx_rt, xm_rd, dxrt_equal_xmrd);

    // Check if writeback is writing into $0.
    equal5 mw_instr_rd0(mw_rd, 5'b0, writing_mw_into_reg0);

    // Decode opcode (Requirement: decode_general_instr)
    wire dx_neq, dx_lt, dx_is_alu_op_excluding_addi, dx_is_addi, dx_is_sw, dx_is_lw, dx_is_j, dx_is_bne, dx_is_jal, dx_is_jr, dx_is_blt, dx_is_bex_wo_rstatus, dx_is_setx;
    assign dx_neq = 1'b1; // Before computing neq in alu. checking if opcodes match
    assign dx_lt = 1'b1; // Before computing lt in alu. checking if opcodes match
    decode_opcode doc2(.opcode(dx_opcode), .neq(dx_neq), .lt(dx_lt), .is_alu_op_excluding_addi(dx_is_alu_op_excluding_addi), .is_addi(dx_is_addi), .is_sw(dx_is_sw), .is_lw(dx_is_lw), .is_j(dx_is_j), .is_bne(dx_is_bne), .is_jal(dx_is_jal), .is_jr(dx_is_jr), .is_blt(dx_is_blt), .is_bex_wo_rstatus(dx_is_bex_wo_rstatus), .is_setx(dx_is_setx));


    // Map rd,rt,rs to rd
    wire bypass_fdrd_equal_mwrd, bypass_fdrs_equal_mwrd;
    assign bypass_fdrs_equal_mwrd = (dx_is_alu_op_excluding_addi | dx_is_addi | dx_is_lw | dx_is_sw) & ~dxrs_equal_xmrd & dxrs_equal_mwrd;
    assign bypass_fdrd_equal_mwrd = (dx_is_bne | dx_is_blt | dx_is_jr) & ~dxrd_equal_xmrd & dxrd_equal_mwrd;
    
    assign is_bypass_WX_regA = mw_instr_we & ~writing_mw_into_reg0 & (bypass_fdrd_equal_mwrd || bypass_fdrs_equal_mwrd);
endmodule

module bypass_MX_regA(dx_instr, xm_instr, mw_instr, is_bypass_MX_regA);
    input [31:0] dx_instr, xm_instr, mw_instr;
    output is_bypass_MX_regA;

    wire [4:0] dx_opcode, dx_rd, dx_rs, dx_rt, xm_rd, mw_rd;
    wire xm_instr_we, dxrs_equal_mwrd, dxrd_equal_mwrd, dxrt_equal_mwrd, dxrs_equal_xmrd, dxrd_equal_xmrd, dxrt_equal_xmrd, writing_xm_into_reg0;
    // Decode latch instructions
    decode_general_instr dgi_dx1(.instr(dx_instr), .opcode(dx_opcode), .rd(dx_rd), .rs(dx_rs), .rt(dx_rt));  
    decode_general_instr dgi_xm2(.instr(xm_instr), .rd(xm_rd));  
    decode_general_instr dgi_mw3(.instr(mw_instr), .rd(mw_rd));


    // Calculate WE
    get_ctrl_writeEnable we_xm1(xm_instr, xm_instr_we);


    // Check if the same register number is accessed in 2 different locations of the pipeline.  
    equal5 fdrs_equal_mwrd1(dx_rs, mw_rd, dxrs_equal_mwrd);
    equal5 fdrd_equal_mwrd2(dx_rd, mw_rd, dxrd_equal_mwrd);
    equal5 fdrt_equal_mwrd3(dx_rt, mw_rd, dxrt_equal_mwrd);

    equal5 fdrs_equal_xmrd1(dx_rs, xm_rd, dxrs_equal_xmrd);
    equal5 fdrd_equal_xmrd2(dx_rd, xm_rd, dxrd_equal_xmrd);
    equal5 fdrt_equal_xmrd3(dx_rt, xm_rd, dxrt_equal_xmrd);

    // Check if writeback is writing into $0.
    equal5 mw_instr_rd0(xm_rd, 5'b0, writing_xm_into_reg0);

    // Decode opcode (Requirement: decode_general_instr)
    wire dx_neq, dx_lt, dx_is_alu_op_excluding_addi, dx_is_addi, dx_is_sw, dx_is_lw, dx_is_j, dx_is_bne, dx_is_jal, dx_is_jr, dx_is_blt, dx_is_bex_wo_rstatus, dx_is_setx;
    assign dx_neq = 1'b1; // Before computing neq in alu. checking if opcodes match
    assign dx_lt = 1'b1; // Before computing lt in alu. checking if opcodes match
    decode_opcode doc2(.opcode(dx_opcode), .neq(dx_neq), .lt(dx_lt), .is_alu_op_excluding_addi(dx_is_alu_op_excluding_addi), .is_addi(dx_is_addi), .is_sw(dx_is_sw), .is_lw(dx_is_lw), .is_j(dx_is_j), .is_bne(dx_is_bne), .is_jal(dx_is_jal), .is_jr(dx_is_jr), .is_blt(dx_is_blt), .is_bex_wo_rstatus(dx_is_bex_wo_rstatus), .is_setx(dx_is_setx));

    // Map rd,rt,rs to rd
    wire bypass_dxrd_equal_xmrd, bypass_dxrs_equal_xmrd;
    assign bypass_dxrs_equal_xmrd = (dx_is_alu_op_excluding_addi | dx_is_addi | dx_is_sw | dx_is_lw) & dxrs_equal_xmrd;
    assign bypass_dxrd_equal_xmrd = (dx_is_bne | dx_is_blt | dx_is_jr) & dxrd_equal_xmrd;
    
    assign is_bypass_MX_regA = xm_instr_we & ~writing_xm_into_reg0 & (bypass_dxrd_equal_xmrd | bypass_dxrs_equal_xmrd);
endmodule

module bypass_WX_regB(dx_instr, xm_instr, mw_instr, is_bypass_WX_regB);
    input [31:0] dx_instr, xm_instr, mw_instr;
    output is_bypass_WX_regB;

    wire [4:0] dx_opcode, dx_rd, dx_rs, dx_rt, xm_rd, mw_rd;
    wire xm_instr_we, dxrs_equal_mwrd, dxrd_equal_mwrd, dxrt_equal_mwrd, dxrs_equal_xmrd, dxrd_equal_xmrd, dxrt_equal_xmrd, writing_mw_into_reg0;
    // Decode latch instructions
    decode_general_instr dgi_dx1(.instr(dx_instr), .opcode(dx_opcode), .rd(dx_rd), .rs(dx_rs), .rt(dx_rt));  
    decode_general_instr dgi_xm2(.instr(xm_instr), .rd(xm_rd));  
    decode_general_instr dgi_mw3(.instr(mw_instr), .rd(mw_rd));


    // Calculate WE
	 wire mw_instr_we;
    get_ctrl_writeEnable we_xm1(mw_instr, mw_instr_we);


    // Check if the same register number is accessed in 2 different locations of the pipeline.  
    equal5 fdrs_equal_mwrd1(dx_rs, mw_rd, dxrs_equal_mwrd);
    equal5 fdrd_equal_mwrd2(dx_rd, mw_rd, dxrd_equal_mwrd);
    equal5 fdrt_equal_mwrd3(dx_rt, mw_rd, dxrt_equal_mwrd);

    equal5 fdrs_equal_xmrd1(dx_rs, xm_rd, dxrs_equal_xmrd);
    equal5 fdrd_equal_xmrd2(dx_rd, xm_rd, dxrd_equal_xmrd);
    equal5 fdrt_equal_xmrd3(dx_rt, xm_rd, dxrt_equal_xmrd);

    // Check if writeback is writing into $0.
    equal5 mw_instr_rd1(mw_rd, 5'b0, writing_mw_into_reg0);

    // Decode opcode (Requirement: decode_general_instr)
    wire dx_neq, dx_lt, dx_is_alu_op_excluding_addi, dx_is_addi, dx_is_sw, dx_is_lw, dx_is_j, dx_is_bne, dx_is_jal, dx_is_jr, dx_is_blt, dx_is_bex_wo_rstatus, dx_is_setx;
    assign dx_neq = 1'b1; // Before computing neq in alu. checking if opcodes match
    assign dx_lt = 1'b1; // Before computing lt in alu. checking if opcodes match
    decode_opcode doc1(.opcode(dx_opcode), .neq(dx_neq), .lt(dx_lt), .is_alu_op_excluding_addi(dx_is_alu_op_excluding_addi), .is_addi(dx_is_addi), .is_sw(dx_is_sw), .is_lw(dx_is_lw), .is_j(dx_is_j), .is_bne(dx_is_bne), .is_jal(dx_is_jal), .is_jr(dx_is_jr), .is_blt(dx_is_blt), .is_bex_wo_rstatus(dx_is_bex_wo_rstatus), .is_setx(dx_is_setx));

    // Map rd,rt,rs to rd
    wire bypass_dxrs_equal_mwrd, bypass_dxrd_equal_mwrd, bypass_dxrt_equal_mwrd;
    assign bypass_dxrs_equal_mwrd =  (dx_is_bne | dx_is_blt | dx_is_jr) & ~dxrs_equal_xmrd & dxrs_equal_mwrd;
    assign bypass_dxrd_equal_mwrd =  (dx_is_sw | dx_is_lw) & ~dxrd_equal_xmrd & dxrd_equal_mwrd;
    assign bypass_dxrt_equal_mwrd = (dx_is_alu_op_excluding_addi | dx_is_addi)  & ~dxrt_equal_xmrd & dxrt_equal_mwrd;
    
    assign is_bypass_WX_regB = mw_instr_we & ~writing_mw_into_reg0 & (bypass_dxrd_equal_mwrd | bypass_dxrs_equal_mwrd | bypass_dxrt_equal_mwrd);
endmodule

module bypass_MX_regB(dx_instr, xm_instr, mw_instr, is_bypass_MX_regB,
    xm_instr_we, writing_xm_into_reg0, bypass_dxrd_equal_xmrd, bypass_dxrs_equal_xmrd, bypass_dxrt_equal_xmrd);
    input [31:0] dx_instr, xm_instr, mw_instr;
    output is_bypass_MX_regB;

    wire [4:0] dx_opcode, dx_rd, dx_rs, dx_rt, xm_rd, mw_rd;
    wire xm_instr_we, dxrs_equal_mwrd, dxrd_equal_mwrd, dxrt_equal_mwrd, dxrs_equal_xmrd, dxrd_equal_xmrd, dxrt_equal_xmrd, writing_xm_into_reg0;
    output xm_instr_we, writing_xm_into_reg0, bypass_dxrd_equal_xmrd, bypass_dxrs_equal_xmrd, bypass_dxrt_equal_xmrd;
    // Decode latch instructions
    decode_general_instr dgi_dx1(.instr(dx_instr), .opcode(dx_opcode), .rd(dx_rd), .rs(dx_rs), .rt(dx_rt));  
    decode_general_instr dgi_xm2(.instr(xm_instr), .rd(xm_rd));  
    decode_general_instr dgi_mw3(.instr(mw_instr), .rd(mw_rd));

    // Calculate WE
    get_ctrl_writeEnable we_xm1(xm_instr, xm_instr_we);

    // Check if the same register number is accessed in 2 different locations of the pipeline. 
    equal5 fdrs_equal_xmrd1(dx_rs, xm_rd, dxrs_equal_xmrd);
    equal5 fdrd_equal_xmrd2(dx_rd, xm_rd, dxrd_equal_xmrd);
    equal5 fdrt_equal_xmrd3(dx_rt, xm_rd, dxrt_equal_xmrd);

    // Check if writeback is writing into $0.
	 wire writing_mw_into_reg0;
    equal5 mw_instr_rd0(xm_rd, 5'b0, writing_xm_into_reg0);

    // Decode opcode (Requirement: decode_general_instr)
    wire dx_neq, dx_lt, dx_is_alu_op_excluding_addi, dx_is_addi, dx_is_sw, dx_is_lw, dx_is_j, dx_is_bne, dx_is_jal, dx_is_jr, dx_is_blt, dx_is_bex_wo_rstatus, dx_is_setx;
    assign dx_neq = 1'b1; // Before computing neq in alu. checking if opcodes match
    assign dx_lt = 1'b1; // Before computing lt in alu. checking if opcodes match
    decode_opcode doc2(.opcode(dx_opcode), .neq(dx_neq), .lt(dx_lt), .is_alu_op_excluding_addi(dx_is_alu_op_excluding_addi), .is_addi(dx_is_addi), .is_sw(dx_is_sw), .is_lw(dx_is_lw), .is_j(dx_is_j), .is_bne(dx_is_bne), .is_jal(dx_is_jal), .is_jr(dx_is_jr), .is_blt(dx_is_blt), .is_bex_wo_rstatus(dx_is_bex_wo_rstatus), .is_setx(dx_is_setx));

    // Map rd,rt,rs to rd
    wire bypass_dxrs_equal_xmrd, bypass_dxrd_equal_xmrd, bypass_dxrt_equal_xmrd;
    assign bypass_dxrs_equal_xmrd =  (dx_is_bne | dx_is_blt | dx_is_jr) & dxrs_equal_xmrd;
    assign bypass_dxrd_equal_xmrd =  (dx_is_sw | dx_is_lw) & dxrd_equal_xmrd;
    assign bypass_dxrt_equal_xmrd = (dx_is_alu_op_excluding_addi | dx_is_addi) & dxrt_equal_xmrd;
    
    assign is_bypass_MX_regB = xm_instr_we & ~writing_xm_into_reg0 & (bypass_dxrd_equal_xmrd | bypass_dxrs_equal_xmrd | bypass_dxrt_equal_xmrd);
endmodule

module bypass_WM(xm_instr, mw_instr, is_bypass_WM);
    input [31:0] mw_instr, xm_instr;
    output is_bypass_WM;

    wire [4:0] xm_rd, mw_rd;
    wire writing_mw_into_reg0, xmrd_equal_mwrd, mw_instr_we;

    // Decode instruction rd. 
        decode_general_instr dgi_xm1(.instr(xm_instr), .rd(xm_rd));
        decode_general_instr dgi_mw1(.instr(mw_instr), .rd(mw_rd));

    // is mw_rd = xm_rd. rd register is target register for instructions specified in we. 
    equal5 xmrd_equal_mwrd1(mw_rd, xm_rd, xmrd_equal_mwrd);

    // Any nonzero value written into reg0 will be 0. This edge case needs to be taken into consideration. 
    equal5 mw_instr_rd0(mw_rd, 5'b0, writing_mw_into_reg0);

    // Get write_enable for mw instruction. 
    get_ctrl_writeEnable we_mw1(mw_instr, mw_instr_we);

    assign is_bypass_WM = mw_instr_we && xmrd_equal_mwrd && ~writing_mw_into_reg0;
endmodule


// Decode Helper Functions
    module find_ctrl_readRegA(instr, ctrl_readRegA);
        input [31:0] instr;
        output [4:0] ctrl_readRegA;

        // Decode General Instruction Calling 
            wire [4:0] opcode, rd, rs, rt, shamt, aluop;
            wire [26:0] T;
            wire [16:0] N;
            decode_general_instr dgi(.instr(instr), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
        // Decode opcode (Requirement: decode_general_instr)
            wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
            assign neq = 1'b0; // Dummy value
            assign lt = 1'b0; // Dummy value
            decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));

        assign ctrl_readRegA = (is_alu_op_excluding_addi | is_addi | is_sw | is_lw) ? rs : rd;
    endmodule

    module find_ctrl_readRegB(instr, ctrl_readRegB);
        input [31:0] instr;
        output [4:0] ctrl_readRegB;
        wire [4:0] pre_ctrl_readRegB;

        // Decode General Instruction Calling 
            wire [4:0] opcode, rd, rs, rt, shamt, aluop;
            wire [26:0] T;
            wire [16:0] N;
            decode_general_instr dgi(.instr(instr), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
        // Decode opcode (Requirement: decode_general_instr)
            wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
            assign neq = 1'b0; // Dummy value
            assign lt = 1'b0; // Dummy value
            decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));

        assign pre_ctrl_readRegB = is_alu_op_excluding_addi ? rt : rs;
        assign ctrl_readRegB = is_sw ? rd : pre_ctrl_readRegB;
    endmodule

    module is_multdiv_d_op(instr, is_multdiv);
        input [31:0] instr;
        output is_multdiv;


        // Decode General Instruction Calling 
            wire [4:0] opcode, rd, rs, rt, shamt, aluop;
            wire [26:0] T;
            wire [16:0] N;
            decode_general_instr dgi(.instr(instr), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));

        wire is_mult_opcode, is_mult_aluop, is_mult, is_div_opcode, is_div_aluop, is_div, is_multdiv;
        assign is_mult_opcode = ~opcode[4] | ~opcode[3] | ~opcode[2] | ~opcode[1] | ~opcode[0];
        assign is_mult_aluop = ~aluop[4] | ~aluop[3] | aluop[2] | aluop[1] | ~aluop[0];
        assign is_mult = is_mult_opcode & is_mult_aluop;

        assign is_div_opcode = ~opcode[4] | ~opcode[3] | ~opcode[2] | ~opcode[1] | ~opcode[0];
        assign is_div_aluop = ~aluop[4] | ~aluop[3] | aluop[2] | aluop[1] | aluop[0];
        assign is_div = is_div_opcode & is_div_aluop;

        assign is_multdiv = is_div & is_mult;
    endmodule

// Execute Helper Functions 
    // Done except bypass logic. Will fail if filler function isn't implemented. 
    module  get_alu_inputs(dx_instr_out, post_bypass_regA, post_bypass_regB, alu_data_operandA, alu_data_operandB, alu_ctrl_ALUopcode, alu_ctrl_shiftamt);
        input [31:0] dx_instr_out, post_bypass_regA, post_bypass_regB;
        output [31:0] alu_data_operandA, alu_data_operandB;
        output [4:0] alu_ctrl_ALUopcode, alu_ctrl_shiftamt;
        // Decode General Instruction Calling 
            wire [4:0] rd, rs, rt, shamt, aluop, pre_alu_ctrl_ALUopcode;
            wire [4:0] opcode;
            wire [26:0] T;
            wire [16:0] N;
            decode_general_instr dgi_alu_inps(.instr(dx_instr_out), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
        // Decode opcode (Requirement: decode_general_instr)
            wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
            assign neq = 1'b1; // Check if branch should be taken. is opcode bne's?
            assign lt = 1'b1; // Check if branch should be taken. is opcode blt's?
            decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));
        // Decode type
            wire is_itype, is_rtype, is_jitype, is_jiitype;
            decode_type decode_type1(.opcode(opcode),.neq(neq), .lt(lt), .is_itype(is_itype), .is_rtype(is_rtype), .is_jitype(is_jitype), .is_jiitype(is_jiitype));

        wire [31:0] N_extend;
        calc_N_arithmetic_extend extend_N(.N(N), .N_extend(N_extend));

        // Post instruction specification
        assign alu_data_operandA = post_bypass_regA;
        assign alu_data_operandB = (is_addi | is_lw | is_sw) ? N_extend : post_bypass_regB;

        // Assign other alu inputs
        wire [4:0] t0_alu_ctrl_ALUopcode, t1_alu_ctrl_ALUopcode, t2_alu_ctrl_ALUopcode;

        // Every case explicitly written out. 
        assign t0_alu_ctrl_ALUopcode = 5'b0;                                   // Default
        assign t1_alu_ctrl_ALUopcode = (is_addi | is_lw | is_sw) ? 5'b0 : t0_alu_ctrl_ALUopcode;      // If add_i instruction. 
        assign t2_alu_ctrl_ALUopcode = (is_blt | is_bne) ? 5'b00001 : t1_alu_ctrl_ALUopcode;   // If branch instruction -- not sure if necessary.
        assign alu_ctrl_ALUopcode = is_alu_op_excluding_addi ? aluop : t2_alu_ctrl_ALUopcode;       // If rtype instruction. alu is specified in aluop.

        // Shamt calculation. 
        assign alu_ctrl_shiftamt = shamt;
    endmodule

    // Done 
    module execute_branch_logic(dx_instr_out, dx_pc_out, neq, lt, alu_data_operandA, rstatus, pc_after_branching, isBranchJumpJal);
        input [31:0] dx_instr_out, rstatus, alu_data_operandA, dx_pc_out;
         input neq, lt;
        output [31:0] pc_after_branching;
        output isBranchJumpJal;

        wire rstatus_all_zeros, isTarget_branch, isNoffset_branch, isRegister_branch, dummy_cout_Noff;
        wire [31:0] temp_pc_1, temp_pc_2,target_pc, Noffset_branch_pc, N_extend, T_extend;
        // Decode General Instruction Calling 
            wire [4:0] opcode, rd, rs, rt, shamt, aluop;
            wire [26:0] T;
            wire [16:0] N;
            decode_general_instr dgi(.instr(dx_instr_out), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
        // Decode opcode (Requirement: decode_general_instr)
            wire is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
            decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));
        calc_N_arithmetic_extend pc_offset(.N(N), .N_extend(N_extend));
        calc_T_logical_extend pc_target(.T(T), .T_extend(T_extend));

        // Branching Logic
        assign rstatus_all_zeros = ~rstatus[0] & ~rstatus[1] & ~rstatus[2] & ~rstatus[3] & ~rstatus[4] & ~rstatus[5] & ~rstatus[6] & ~rstatus[7] & ~rstatus[8] & ~rstatus[9] & ~rstatus[10] & ~rstatus[11] & ~rstatus[12] & ~rstatus[13] & ~rstatus[14] & ~rstatus[15] & ~rstatus[16] & ~rstatus[17] & ~rstatus[18] & ~rstatus[19] & ~rstatus[20] & ~rstatus[21] & ~rstatus[22] & ~rstatus[23] & ~rstatus[24] & ~rstatus[25] & ~rstatus[26] & ~rstatus[27] & ~rstatus[28] & ~rstatus[29] & ~rstatus[30] & ~rstatus[31];

        assign isTarget_branch = is_j | is_jal | (is_bex_wo_rstatus & ~rstatus_all_zeros);
        assign isNoffset_branch = is_bne | is_blt;
        assign isRegister_branch = is_jr;

        assign isBranchJumpJal = isTarget_branch | isNoffset_branch | isRegister_branch;

        // PC for each type of Branch
        assign target_pc = T_extend;
        cselect_adder_32 pc_increment(.in1(dx_pc_out), .in2(N_extend), .cin(1'b0), .s(Noffset_branch_pc), .cout(dummy_cout_Noff));

        // Calculate final program counter after branch/jump instruction/no branching occurs
        assign temp_pc_1 = isTarget_branch ? target_pc : dx_instr_out;
        assign temp_pc_2 = isNoffset_branch ? Noffset_branch_pc : temp_pc_1;
        assign pc_after_branching = isRegister_branch ? alu_data_operandA : temp_pc_2;
    endmodule

module get_next_rstatus(dx_instr_out, alu_overflow, pseudo_setx_instr, use_pseudo_setx_instr, next_rstatus, execute_is_setx);
    input [31:0] dx_instr_out;
	input alu_overflow;
    output [31:0] pseudo_setx_instr, next_rstatus; 
    output use_pseudo_setx_instr;
	 output execute_is_setx;
    
    // Decode General Instruction Calling 
        wire [4:0] opcode, rd, rs, rt, shamt, aluop;
        wire [26:0] T;
        wire [16:0] N;
        decode_general_instr dgi(.instr(dx_instr_out), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
    // Decode opcode (Requirement: decode_general_instr)
        wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
        assign neq = 1'b0; // Dummy value
        assign lt = 1'b0; // Dummy value
        decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));
    wire isAdd, isAddi, isSub, isMult, isDiv;
    assign isAdd = is_alu_op_excluding_addi & (~aluop[4] & ~aluop[3] & ~aluop[2] & ~aluop[1] & ~aluop[0]);
    assign isAddi = is_addi;
    assign isSub = is_alu_op_excluding_addi & (~aluop[4] & ~aluop[3] & ~aluop[2] & ~aluop[1] & aluop[0]);
    assign isMult = is_alu_op_excluding_addi & (~aluop[4] & ~aluop[3] & aluop[2] & aluop[1] & ~aluop[0]);
    assign isDiv = is_alu_op_excluding_addi & (~aluop[4] & ~aluop[3] & aluop[2] & aluop[1] & aluop[0]);

    wire [26:0] no_psetx_instr, t1_psetx, t2_psetx, t3_psetx, t4_psetx, t5_psetx, t6_psetx;
    assign no_psetx_instr =     27'b000000000000000000000000000;
    assign t1_psetx = isAdd ?   27'b000000000000000000000000001 : no_psetx_instr;
    assign t2_psetx = isAddi ?  27'b000000000000000000000000010 : t1_psetx;
    assign t3_psetx = isSub ?   27'b000000000000000000000000011 : t2_psetx;
    assign t4_psetx = isMult ?  27'b000000000000000000000000100 : t3_psetx;
    assign t5_psetx = isDiv ?   27'b000000000000000000000000101 : t4_psetx;
    assign t6_psetx = is_setx ? dx_instr_out[26:0] : t5_psetx;

    assign execute_is_setx = is_setx;

    assign  pseudo_setx_instr[26:0] = t6_psetx;
    assign  pseudo_setx_instr[31:27] = 5'b10101;

    assign  next_rstatus[26:0] = t6_psetx;
    assign  next_rstatus[31:27] = 5'b00000;

    assign use_pseudo_setx_instr = alu_overflow & (is_alu_op_excluding_addi | is_addi);

endmodule




module check_we_instr(instr, is_we);
    input [31:0] instr;
    output is_we;
	 
	 wire instr_noop;
	 allzero32 az32(instr, instr_noop);

    // Decode General Instruction Calling 
        wire [4:0] opcode, rd, rs, rt, shamt, aluop;
        wire [26:0] T;
        wire [16:0] N;
        decode_general_instr dgi(.instr(instr), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
    // Decode opcode (Requirement: decode_general_instr)
        wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
        assign neq = 1'b0; // Dummy value
        assign lt = 1'b0; // Dummy value
        decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));
    assign is_we = (is_alu_op_excluding_addi | is_lw | is_jal | is_addi) & !instr_noop;
endmodule


// ------------------------------Logic Correct------------------------------------------
// Done 
module decode_R_Itype(instr, opcode, rd, rs, rt, ctrl_shiftamt, aluop, zeroes);
    input [31:0] instr;
    output [4:0] opcode, rd, rs, rt, ctrl_shiftamt, aluop;
    output [1:0] zeroes;
    assign zeroes = instr[1:0];
    assign aluop = instr[6:2];
    assign ctrl_shiftamt = instr[11:7];
    assign rt = instr[16:12];
    assign rs = instr[21:17];
    assign rd = instr[26:22];
    assign opcode = instr[31:27];
endmodule

// Done 
module decode_I_Itype(instr, opcode, rd, rs, immediate);
    input [31:0] instr;
    output [4:0] opcode, rd, rs;
    output [16:0] immediate;
    assign immediate = instr[16:0];
    assign rs = instr[21:17];
    assign rd = instr[26:22];
    assign opcode = instr[31:27];
endmodule

// Done 
module decode_JI_Itype(instr, opcode, target);
    input [31:0] instr;
    output [4:0] opcode;
    output [26:0] target;
    assign target = instr[26:0];
    assign opcode = instr[31:27];
endmodule

// Done 
module decode_JII_Itype(instr, opcode, rd, target);
    input [31:0] instr;
    output [4:0] opcode, rd;
    output [21:0] target;
    assign target = instr[21:0];
    assign rd = instr[26:22];
    assign opcode = instr[31:27];
endmodule

// Done 
module decode_general_instr(instr, opcode, rd, rs, rt, shamt, aluop, N, T);
    input [31:0] instr;
    output [4:0] opcode, rd, rs, rt, shamt, aluop;
    output [26:0] T;
    output [16:0] N;

    assign opcode = instr[31:27];
    assign rd = instr[26:22];
    assign rs = instr[21:17];
    assign rt = instr[16:12];
    assign shamt = instr[11:7];
    assign aluop = instr[6:2];
    assign T = instr[26:0];
    assign N = instr[16:0];
endmodule

// Done
module decode_opcode(opcode, neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx);
    input [4:0] opcode;
    input neq, lt;
    output is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;

    // is_alu_op_excluding_addi : 00000
    and and1(is_alu_op_excluding_addi, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], ~opcode[0]);
    // addi                     : 00101
    and and2(is_addi, ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], opcode[0]);
    // sw                       : 00111
    and and3(is_sw, ~opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]);
    // lw                       : 01000
    and and4(is_lw, ~opcode[4], opcode[3], ~opcode[2], ~opcode[1], ~opcode[0]);
    // j                        : 00001
    and and5(is_j, ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], opcode[0]);
    // bne                      : 00010
    and and6(is_bne, ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], ~opcode[0], neq);
    // jal                      : 00011
    and and7(is_jal, ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);
    // jr                       : 00100
    and and8(is_jr, ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], ~opcode[0]);
    // blt                      : 00110
    and and9(is_blt, ~opcode[4], ~opcode[3], opcode[2], opcode[1], ~opcode[0], lt);
    // bex                      : 10110
    and and10(is_bex_wo_rstatus, opcode[4], ~opcode[3], opcode[2], opcode[1], ~opcode[0]);
    // setx                     : 10101
    and and11(is_setx, opcode[4], ~opcode[3], opcode[2], ~opcode[1], opcode[0]);
endmodule

// Done
module get_data_writeReg(instr, mw_alu_res_out, mw_dmem_out, mw_pc_out, data_writeReg);
    input [31:0] instr, mw_alu_res_out, mw_dmem_out, mw_pc_out;
    output [31:0] data_writeReg;

    wire [31:0] temp1, temp2; 

    // Decode General Instruction Calling 
        wire [4:0] opcode, rd, rs, rt, shamt, aluop;
        wire [26:0] T;
        wire [16:0] N;
        decode_general_instr dgi(.instr(instr), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
    // Decode opcode (Requirement: decode_general_instr)
        wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
        assign neq = 1'b0; // Dummy value
        assign lt = 1'b0; // Dummy value
        decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));
	 wire [31:0] T_extend;
	 calc_T_logical_extend cle(T, T_extend);
    assign temp1 = is_jal ? mw_pc_out : mw_alu_res_out;
    assign temp2 = is_setx ? T_extend : temp1;
    assign data_writeReg = is_lw ? mw_dmem_out : temp2;
endmodule

// Done
module get_ctrl_writeEnable(instr, ctrl_writeEnable);
    input [31:0] instr;
    output ctrl_writeEnable;
    wire is_noop, we_opcodes_valid;


    // Decode General Instruction Calling 
        wire [4:0] opcode, rd, rs, rt, shamt, aluop;
        wire [26:0] T;
        wire [16:0] N;
        decode_general_instr dgi(.instr(instr), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
    // Decode opcode (Requirement: decode_general_instr)
        wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
        assign neq = 1'b0; // Dummy value
        assign lt = 1'b0; // Dummy value
        decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));
    
    assign is_noop = ~instr[0] & ~instr[1] & ~instr[2] & ~instr[3] & ~instr[4] & ~instr[5] & ~instr[6] & ~instr[7] & ~instr[8] & ~instr[9] & ~instr[10] & ~instr[11] & ~instr[12] & ~instr[13] & ~instr[14] & ~instr[15] & ~instr[16] & ~instr[17] & ~instr[18] & ~instr[19] & ~instr[20] & ~instr[21] & ~instr[22] & ~instr[23] & ~instr[24] & ~instr[25] & ~instr[26] & ~instr[27] & ~instr[28] & ~instr[29] & ~instr[30] & ~instr[31];
    assign we_opcodes_valid = (is_alu_op_excluding_addi | is_addi | is_lw | is_jal);
    assign ctrl_writeEnable = we_opcodes_valid & (~is_noop);
endmodule

// Done
module get_ctrl_writeReg(instr, is_alu_except, ctrl_writeReg);
    input [31:0] instr; 
    input is_alu_except;
    output [4:0] ctrl_writeReg;
    // Decode General Instruction Calling 
        wire [4:0] opcode, rd, rs, rt, shamt, aluop;
        wire [26:0] T;
        wire [16:0] N;
        decode_general_instr dgi(.instr(instr), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
    // Decode opcode (Requirement: decode_general_instr)
        wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
        assign neq = 1'b0; // Dummy value
        assign lt = 1'b0; // Dummy value
        decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));
    wire [4:0] temp1_wR;
    assign temp1_wR = is_setx ? 5'b11110 : rd;
    assign ctrl_writeReg = is_jal ? 5'b11111 : temp1_wR;
endmodule

// Done
module decode_type(opcode, neq,lt ,is_itype, is_rtype, is_jitype, is_jiitype);
    input opcode, neq, lt;
    output is_itype, is_rtype, is_jitype, is_jiitype;
    // Decode opcode (Requirement: decode_general_instr)
        wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
        decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));

    assign is_itype = is_addi | is_sw | is_lw | is_bne | is_blt;
    assign is_rtype = is_alu_op_excluding_addi;
    assign is_jitype = is_j | is_jal | is_setx;
    assign is_jiitype = is_jr;
endmodule

// Done
module is_sw_m(xm_instr_out, is_sw_m);
    input [31:0] xm_instr_out;
    output is_sw_m;

    // Decode General Instruction Calling 
        wire [4:0] opcode, rd, rs, rt, shamt, aluop;
        wire [26:0] T;
        wire [16:0] N;
        decode_general_instr dgi(.instr(xm_instr_out), .opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .aluop(aluop), .N(N), .T(T));
    // Decode opcode (Requirement: decode_general_instr)
        wire neq, lt, is_alu_op_excluding_addi, is_addi, is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex_wo_rstatus, is_setx;
        assign neq = 1'b0; // Dummy value
        assign lt = 1'b0; // Dummy value
        decode_opcode doc(.opcode(opcode), .neq(neq), .lt(lt), .is_alu_op_excluding_addi(is_alu_op_excluding_addi), .is_addi(is_addi), .is_sw(is_sw), .is_lw(is_lw), .is_j(is_j), .is_bne(is_bne), .is_jal(is_jal), .is_jr(is_jr), .is_blt(is_blt), .is_bex_wo_rstatus(is_bex_wo_rstatus), .is_setx(is_setx));

    assign is_sw_m = is_sw;
endmodule

// Done
module calc_N_arithmetic_extend(N, N_extend);
    input [16:0] N;
    output [31:0] N_extend;
    assign N_extend[16:0] = N;
    assign N_extend[17] = N[16];
    assign N_extend[18] = N[16];
    assign N_extend[19] = N[16];
    assign N_extend[20] = N[16];
    assign N_extend[21] = N[16];
    assign N_extend[22] = N[16];
    assign N_extend[23] = N[16];
    assign N_extend[24] = N[16];
    assign N_extend[25] = N[16];
    assign N_extend[26] = N[16];
    assign N_extend[27] = N[16];
    assign N_extend[28] = N[16];
    assign N_extend[29] = N[16];
    assign N_extend[30] = N[16];
    assign N_extend[31] = N[16];
endmodule

// Done
module calc_T_logical_extend(T, T_extend);
    input [26:0] T;
    output [31:0] T_extend;

    assign T_extend[26:0] = T[26:0];
    assign T_extend[31:27] = 5'b00000;
endmodule


module allzero32(a, all_zeros);
    input [31:0] a;
    output all_zeros;
    assign all_zeros = ~a[0] & ~a[1] & ~a[2] & ~a[3] & ~a[4] & ~a[5] & ~a[6] & ~a[7] & ~a[8] & ~a[9] & ~a[10] & ~a[11] & ~a[12] & ~a[13] & ~a[14] & ~a[15] & ~a[16] & ~a[17] & ~a[18] & ~a[19] & ~a[20] & ~a[21] & ~a[22] & ~a[23] & ~a[24] & ~a[25] & ~a[26] & ~a[27] & ~a[28] & ~a[29] & ~a[30] & ~a[31];
endmodule


module equal5(a, b, is_equal);
    input [4:0] a, b;
    output is_equal;
     wire isequal0, isequal1, isequal2, isequal3, isequal4;
    equal1 eq0(.a(a[0]), .b(b[0]), .is_equal(isequal0));
    equal1 eq1(.a(a[1]), .b(b[1]), .is_equal(isequal1));
    equal1 eq2(.a(a[2]), .b(b[2]), .is_equal(isequal2));
    equal1 eq3(.a(a[3]), .b(b[3]), .is_equal(isequal3));
    equal1 eq4(.a(a[4]), .b(b[4]), .is_equal(isequal4));
    assign is_equal = isequal0 & isequal1 & isequal2 & isequal3 & isequal4;
endmodule


module equal1(a, b, is_equal);
    input a, b;
    output is_equal;
    assign is_equal = (a & b) | (~a & ~b);
endmodule
