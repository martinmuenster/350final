/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when. 
 */

module skeleton(
    clock, reset, q_imem, address_imem, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB, // Main
    dx_pc_out, dx_instr_out, // Execute Testing
    dx_regA_out, dx_regB_out,
    xm_alu_res_out,
    alu_data_operandA, alu_data_operandB, alu_dataResult, ctrl_writeEnable, alu_ctrl_ALUopcode,
    address_dmem, data, wren, q_dmem,
    is_bypass_MX_regB, xm_instr_we, writing_xm_into_reg0, bypass_dxrd_equal_xmrd, bypass_dxrs_equal_xmrd, bypass_dxrt_equal_xmrd
    );
    input clock, reset;

    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    output [11:0] address_imem;
    output [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    output [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),           // address of data
        .clock      (clock),                  // may need to invert the clock
        .data	    (data),                   // data you want to write
        .wren	    (wren),                   // write enable
        .q          (q_dmem)                  // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    output [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );

    /** PROCESSOR **/
    output [31:0] dx_pc_out, dx_instr_out;
    output [31:0] dx_regA_out, dx_regB_out;
    output [31:0] xm_alu_res_out;
    output [31:0] alu_data_operandA, alu_data_operandB, alu_dataResult;
    output [4:0] alu_ctrl_ALUopcode;
    output is_bypass_MX_regB,xm_instr_we, writing_xm_into_reg0, bypass_dxrd_equal_xmrd, bypass_dxrs_equal_xmrd, bypass_dxrt_equal_xmrd;
    processor my_processor(
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
        data_readRegB,                   // I: Data from port B of regfile
        
        dx_pc_out, dx_instr_out, // Execute Testing
        dx_regA_out, dx_regB_out, // More Execute Testing
        alu_data_operandA, alu_data_operandB, alu_dataResult, alu_ctrl_ALUopcode,
        xm_alu_res_out, // MW Logic
        is_bypass_MX_regB,xm_instr_we, writing_xm_into_reg0, bypass_dxrd_equal_xmrd, bypass_dxrs_equal_xmrd, bypass_dxrt_equal_xmrd
        
    );

endmodule
