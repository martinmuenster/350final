module regfile (clock,ctrl_writeEnable, ctrl_reset, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg,data_readRegA, data_readRegB);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

	
   /* YOUR CODE HERE */

	
	
	// Initialize wires:
	wire [31:0] decode_ctrl_writeReg, and_decodewR_wE, decoder_ctrl_readRegA, decoder_ctrl_readRegB;
	wire [31:0] out_rs_reg0,  out_rs_reg1,  out_rs_reg2,  out_rs_reg3,  out_rs_reg4,  out_rs_reg5,  out_rs_reg6,  out_rs_reg7,  out_rs_reg8,  out_rs_reg9,  out_rs_reg10,  out_rs_reg11,  out_rs_reg12,  out_rs_reg13,  out_rs_reg14,  out_rs_reg15,  out_rs_reg16,  out_rs_reg17,  out_rs_reg18,  out_rs_reg19,  out_rs_reg20,  out_rs_reg21,  out_rs_reg22,  out_rs_reg23,  out_rs_reg24,  out_rs_reg25,  out_rs_reg26,  out_rs_reg27,  out_rs_reg28,  out_rs_reg29,  out_rs_reg30,  out_rs_reg31;
	
	
	
	// Decoder anded with write enable
		decoder_5_32 decoder_of_writeReg(.out(decode_ctrl_writeReg), .in(ctrl_writeReg));
	
		and and_decode_we_0(and_decodewR_wE[0], ctrl_writeEnable, decode_ctrl_writeReg[0]);
		and and_decode_we_1(and_decodewR_wE[1], ctrl_writeEnable, decode_ctrl_writeReg[1]);
		and and_decode_we_2(and_decodewR_wE[2], ctrl_writeEnable, decode_ctrl_writeReg[2]);
		and and_decode_we_3(and_decodewR_wE[3], ctrl_writeEnable, decode_ctrl_writeReg[3]);
		and and_decode_we_4(and_decodewR_wE[4], ctrl_writeEnable, decode_ctrl_writeReg[4]);
		and and_decode_we_5(and_decodewR_wE[5], ctrl_writeEnable, decode_ctrl_writeReg[5]);
		and and_decode_we_6(and_decodewR_wE[6], ctrl_writeEnable, decode_ctrl_writeReg[6]);
		and and_decode_we_7(and_decodewR_wE[7], ctrl_writeEnable, decode_ctrl_writeReg[7]);
		and and_decode_we_8(and_decodewR_wE[8], ctrl_writeEnable, decode_ctrl_writeReg[8]);
		and and_decode_we_9(and_decodewR_wE[9], ctrl_writeEnable, decode_ctrl_writeReg[9]);
		and and_decode_we_10(and_decodewR_wE[10], ctrl_writeEnable, decode_ctrl_writeReg[10]);
		and and_decode_we_11(and_decodewR_wE[11], ctrl_writeEnable, decode_ctrl_writeReg[11]);
		and and_decode_we_12(and_decodewR_wE[12], ctrl_writeEnable, decode_ctrl_writeReg[12]);
		and and_decode_we_13(and_decodewR_wE[13], ctrl_writeEnable, decode_ctrl_writeReg[13]);
		and and_decode_we_14(and_decodewR_wE[14], ctrl_writeEnable, decode_ctrl_writeReg[14]);
		and and_decode_we_15(and_decodewR_wE[15], ctrl_writeEnable, decode_ctrl_writeReg[15]);
		and and_decode_we_16(and_decodewR_wE[16], ctrl_writeEnable, decode_ctrl_writeReg[16]);
		and and_decode_we_17(and_decodewR_wE[17], ctrl_writeEnable, decode_ctrl_writeReg[17]);
		and and_decode_we_18(and_decodewR_wE[18], ctrl_writeEnable, decode_ctrl_writeReg[18]);
		and and_decode_we_19(and_decodewR_wE[19], ctrl_writeEnable, decode_ctrl_writeReg[19]);
		and and_decode_we_20(and_decodewR_wE[20], ctrl_writeEnable, decode_ctrl_writeReg[20]);
		and and_decode_we_21(and_decodewR_wE[21], ctrl_writeEnable, decode_ctrl_writeReg[21]);
		and and_decode_we_22(and_decodewR_wE[22], ctrl_writeEnable, decode_ctrl_writeReg[22]);
		and and_decode_we_23(and_decodewR_wE[23], ctrl_writeEnable, decode_ctrl_writeReg[23]);
		and and_decode_we_24(and_decodewR_wE[24], ctrl_writeEnable, decode_ctrl_writeReg[24]);
		and and_decode_we_25(and_decodewR_wE[25], ctrl_writeEnable, decode_ctrl_writeReg[25]);
		and and_decode_we_26(and_decodewR_wE[26], ctrl_writeEnable, decode_ctrl_writeReg[26]);
		and and_decode_we_27(and_decodewR_wE[27], ctrl_writeEnable, decode_ctrl_writeReg[27]);
		and and_decode_we_28(and_decodewR_wE[28], ctrl_writeEnable, decode_ctrl_writeReg[28]);
		and and_decode_we_29(and_decodewR_wE[29], ctrl_writeEnable, decode_ctrl_writeReg[29]);
		and and_decode_we_30(and_decodewR_wE[30], ctrl_writeEnable, decode_ctrl_writeReg[30]);
		and and_decode_we_31(and_decodewR_wE[31], ctrl_writeEnable, decode_ctrl_writeReg[31]);

	
	// Construct Registers
	
	
	reg32_rf create_reg_0(.in(32'b0), .out(out_rs_reg0), .in_enable(1'b1), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_1(.in(data_writeReg), .out(out_rs_reg1), .in_enable(and_decodewR_wE[1]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_2(.in(data_writeReg), .out(out_rs_reg2), .in_enable(and_decodewR_wE[2]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_3(.in(data_writeReg), .out(out_rs_reg3), .in_enable(and_decodewR_wE[3]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_4(.in(data_writeReg), .out(out_rs_reg4), .in_enable(and_decodewR_wE[4]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_5(.in(data_writeReg), .out(out_rs_reg5), .in_enable(and_decodewR_wE[5]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_6(.in(data_writeReg), .out(out_rs_reg6), .in_enable(and_decodewR_wE[6]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_7(.in(data_writeReg), .out(out_rs_reg7), .in_enable(and_decodewR_wE[7]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_8(.in(data_writeReg), .out(out_rs_reg8), .in_enable(and_decodewR_wE[8]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_9(.in(data_writeReg), .out(out_rs_reg9), .in_enable(and_decodewR_wE[9]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_10(.in(data_writeReg), .out(out_rs_reg10), .in_enable(and_decodewR_wE[10]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_11(.in(data_writeReg), .out(out_rs_reg11), .in_enable(and_decodewR_wE[11]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_12(.in(data_writeReg), .out(out_rs_reg12), .in_enable(and_decodewR_wE[12]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_13(.in(data_writeReg), .out(out_rs_reg13), .in_enable(and_decodewR_wE[13]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_14(.in(data_writeReg), .out(out_rs_reg14), .in_enable(and_decodewR_wE[14]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_15(.in(data_writeReg), .out(out_rs_reg15), .in_enable(and_decodewR_wE[15]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_16(.in(data_writeReg), .out(out_rs_reg16), .in_enable(and_decodewR_wE[16]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_17(.in(data_writeReg), .out(out_rs_reg17), .in_enable(and_decodewR_wE[17]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_18(.in(data_writeReg), .out(out_rs_reg18), .in_enable(and_decodewR_wE[18]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_19(.in(data_writeReg), .out(out_rs_reg19), .in_enable(and_decodewR_wE[19]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_20(.in(data_writeReg), .out(out_rs_reg20), .in_enable(and_decodewR_wE[20]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_21(.in(data_writeReg), .out(out_rs_reg21), .in_enable(and_decodewR_wE[21]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_22(.in(data_writeReg), .out(out_rs_reg22), .in_enable(and_decodewR_wE[22]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_23(.in(data_writeReg), .out(out_rs_reg23), .in_enable(and_decodewR_wE[23]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_24(.in(data_writeReg), .out(out_rs_reg24), .in_enable(and_decodewR_wE[24]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_25(.in(data_writeReg), .out(out_rs_reg25), .in_enable(and_decodewR_wE[25]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_26(.in(data_writeReg), .out(out_rs_reg26), .in_enable(and_decodewR_wE[26]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_27(.in(data_writeReg), .out(out_rs_reg27), .in_enable(and_decodewR_wE[27]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_28(.in(data_writeReg), .out(out_rs_reg28), .in_enable(and_decodewR_wE[28]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_29(.in(data_writeReg), .out(out_rs_reg29), .in_enable(and_decodewR_wE[29]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_30(.in(data_writeReg), .out(out_rs_reg30), .in_enable(and_decodewR_wE[30]), .clock(clock), .clr(ctrl_reset));
	reg32_rf create_reg_31(.in(data_writeReg), .out(out_rs_reg31), .in_enable(and_decodewR_wE[31]), .clock(clock), .clr(ctrl_reset));

	

	// Decode rsval1
		decoder_5_32 decoder_of_RegA(.out(decoder_ctrl_readRegA), .in(ctrl_readRegA));
		
		tristate_buffer_32 tsb_A_0(.in(out_rs_reg0), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[0]));
		tristate_buffer_32 tsb_A_1(.in(out_rs_reg1), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[1]));
		tristate_buffer_32 tsb_A_2(.in(out_rs_reg2), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[2]));
		tristate_buffer_32 tsb_A_3(.in(out_rs_reg3), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[3]));
		tristate_buffer_32 tsb_A_4(.in(out_rs_reg4), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[4]));
		tristate_buffer_32 tsb_A_5(.in(out_rs_reg5), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[5]));
		tristate_buffer_32 tsb_A_6(.in(out_rs_reg6), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[6]));
		tristate_buffer_32 tsb_A_7(.in(out_rs_reg7), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[7]));
		tristate_buffer_32 tsb_A_8(.in(out_rs_reg8), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[8]));
		tristate_buffer_32 tsb_A_9(.in(out_rs_reg9), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[9]));
		tristate_buffer_32 tsb_A_10(.in(out_rs_reg10), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[10]));
		tristate_buffer_32 tsb_A_11(.in(out_rs_reg11), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[11]));
		tristate_buffer_32 tsb_A_12(.in(out_rs_reg12), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[12]));
		tristate_buffer_32 tsb_A_13(.in(out_rs_reg13), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[13]));
		tristate_buffer_32 tsb_A_14(.in(out_rs_reg14), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[14]));
		tristate_buffer_32 tsb_A_15(.in(out_rs_reg15), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[15]));
		tristate_buffer_32 tsb_A_16(.in(out_rs_reg16), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[16]));
		tristate_buffer_32 tsb_A_17(.in(out_rs_reg17), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[17]));
		tristate_buffer_32 tsb_A_18(.in(out_rs_reg18), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[18]));
		tristate_buffer_32 tsb_A_19(.in(out_rs_reg19), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[19]));
		tristate_buffer_32 tsb_A_20(.in(out_rs_reg20), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[20]));
		tristate_buffer_32 tsb_A_21(.in(out_rs_reg21), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[21]));
		tristate_buffer_32 tsb_A_22(.in(out_rs_reg22), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[22]));
		tristate_buffer_32 tsb_A_23(.in(out_rs_reg23), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[23]));
		tristate_buffer_32 tsb_A_24(.in(out_rs_reg24), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[24]));
		tristate_buffer_32 tsb_A_25(.in(out_rs_reg25), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[25]));
		tristate_buffer_32 tsb_A_26(.in(out_rs_reg26), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[26]));
		tristate_buffer_32 tsb_A_27(.in(out_rs_reg27), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[27]));
		tristate_buffer_32 tsb_A_28(.in(out_rs_reg28), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[28]));
		tristate_buffer_32 tsb_A_29(.in(out_rs_reg29), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[29]));
		tristate_buffer_32 tsb_A_30(.in(out_rs_reg30), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[30]));
		tristate_buffer_32 tsb_A_31(.in(out_rs_reg31), .out(data_readRegA), .ctrl(decoder_ctrl_readRegA[31]));


	
	
	// Decode rsval2
		decoder_5_32 decoder_of_RegB(.out(decoder_ctrl_readRegB), .in(ctrl_readRegB));
		tristate_buffer_32 tsb_B_0(.in(out_rs_reg0), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[0]));
		tristate_buffer_32 tsb_B_1(.in(out_rs_reg1), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[1]));
		tristate_buffer_32 tsb_B_2(.in(out_rs_reg2), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[2]));
		tristate_buffer_32 tsb_B_3(.in(out_rs_reg3), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[3]));
		tristate_buffer_32 tsb_B_4(.in(out_rs_reg4), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[4]));
		tristate_buffer_32 tsb_B_5(.in(out_rs_reg5), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[5]));
		tristate_buffer_32 tsb_B_6(.in(out_rs_reg6), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[6]));
		tristate_buffer_32 tsb_B_7(.in(out_rs_reg7), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[7]));
		tristate_buffer_32 tsb_B_8(.in(out_rs_reg8), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[8]));
		tristate_buffer_32 tsb_B_9(.in(out_rs_reg9), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[9]));
		tristate_buffer_32 tsb_B_10(.in(out_rs_reg10), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[10]));
		tristate_buffer_32 tsb_B_11(.in(out_rs_reg11), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[11]));
		tristate_buffer_32 tsb_B_12(.in(out_rs_reg12), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[12]));
		tristate_buffer_32 tsb_B_13(.in(out_rs_reg13), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[13]));
		tristate_buffer_32 tsb_B_14(.in(out_rs_reg14), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[14]));
		tristate_buffer_32 tsb_B_15(.in(out_rs_reg15), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[15]));
		tristate_buffer_32 tsb_B_16(.in(out_rs_reg16), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[16]));
		tristate_buffer_32 tsb_B_17(.in(out_rs_reg17), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[17]));
		tristate_buffer_32 tsb_B_18(.in(out_rs_reg18), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[18]));
		tristate_buffer_32 tsb_B_19(.in(out_rs_reg19), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[19]));
		tristate_buffer_32 tsb_B_20(.in(out_rs_reg20), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[20]));
		tristate_buffer_32 tsb_B_21(.in(out_rs_reg21), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[21]));
		tristate_buffer_32 tsb_B_22(.in(out_rs_reg22), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[22]));
		tristate_buffer_32 tsb_B_23(.in(out_rs_reg23), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[23]));
		tristate_buffer_32 tsb_B_24(.in(out_rs_reg24), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[24]));
		tristate_buffer_32 tsb_B_25(.in(out_rs_reg25), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[25]));
		tristate_buffer_32 tsb_B_26(.in(out_rs_reg26), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[26]));
		tristate_buffer_32 tsb_B_27(.in(out_rs_reg27), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[27]));
		tristate_buffer_32 tsb_B_28(.in(out_rs_reg28), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[28]));
		tristate_buffer_32 tsb_B_29(.in(out_rs_reg29), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[29]));
		tristate_buffer_32 tsb_B_30(.in(out_rs_reg30), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[30]));
		tristate_buffer_32 tsb_B_31(.in(out_rs_reg31), .out(data_readRegB), .ctrl(decoder_ctrl_readRegB[31]));
endmodule

module reg32_rf(in, out, in_enable, clock, clr);

	input [31:0] in;
	input in_enable, clock, clr;

	output [31:0] out;
	
	// MOVE FROM TEMP TO OUT IF NEED  BE!
	
	dffe_ref dffe0(.q(out[0]), .d(in[0]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe1(.q(out[1]), .d(in[1]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe2(.q(out[2]), .d(in[2]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe3(.q(out[3]), .d(in[3]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe4(.q(out[4]), .d(in[4]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe5(.q(out[5]), .d(in[5]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe6(.q(out[6]), .d(in[6]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe7(.q(out[7]), .d(in[7]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe8(.q(out[8]), .d(in[8]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe9(.q(out[9]), .d(in[9]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe10(.q(out[10]), .d(in[10]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe11(.q(out[11]), .d(in[11]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe12(.q(out[12]), .d(in[12]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe13(.q(out[13]), .d(in[13]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe14(.q(out[14]), .d(in[14]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe15(.q(out[15]), .d(in[15]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe16(.q(out[16]), .d(in[16]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe17(.q(out[17]), .d(in[17]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe18(.q(out[18]), .d(in[18]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe19(.q(out[19]), .d(in[19]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe20(.q(out[20]), .d(in[20]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe21(.q(out[21]), .d(in[21]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe22(.q(out[22]), .d(in[22]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe23(.q(out[23]), .d(in[23]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe24(.q(out[24]), .d(in[24]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe25(.q(out[25]), .d(in[25]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe26(.q(out[26]), .d(in[26]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe27(.q(out[27]), .d(in[27]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe28(.q(out[28]), .d(in[28]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe29(.q(out[29]), .d(in[29]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe30(.q(out[30]), .d(in[30]), .clk(clock), .en(in_enable), .clr(clr));
	dffe_ref dffe31(.q(out[31]), .d(in[31]), .clk(clock), .en(in_enable), .clr(clr));
endmodule