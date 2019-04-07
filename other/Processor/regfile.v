module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	
	
	wire nclock;
	assign nclock = ~clock;
	wire [31:0] write, we, read1, read2;
	
	z_decoder_32 decoder0(.select(ctrl_writeReg), .out(write));
	z_decoder_32 decoder1(.select(ctrl_readRegA), .out(read1));
	z_decoder_32 decoder2(.select(ctrl_readRegB), .out(read2));
	
	assign we = ctrl_writeEnable ? write : 32'b0;
	
	wire [31:0] w [31:0];
	
	genvar i;
	generate
		for (i=1; i<32; i=i+1) begin: loop1
			d_reg_32 myReg(.d(data_writeReg), .q(w[i]), .clk(nclock), .en(we[i]), .clr(ctrl_reset));
			assign data_readRegA = read1[i] ? w[i] : 32'bz;
			assign data_readRegB = read2[i] ? w[i] : 32'bz;
		end
	endgenerate
   
	d_reg_32 register0(.d(32'b0), .q(w[0]), .clk(nclock), .en(1'b0), .clr(ctrl_reset));
	assign data_readRegA = read1[0] ? w[0] : 32'bz;
	assign data_readRegB = read2[0] ? w[0] : 32'bz;
	
	
	/*
	wire [31:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31;reg_32 register1(.d(data_writeReg), .q(w1), .clk(clock), .en(we[1]), .clr(ctrl_reset));
	reg_32 register2(.d(data_writeReg), .q(w2), .clk(clock), .en(we[2]), .clr(ctrl_reset));
	reg_32 register3(.d(data_writeReg), .q(w3), .clk(clock), .en(we[3]), .clr(ctrl_reset));
	reg_32 register4(.d(data_writeReg), .q(w4), .clk(clock), .en(we[4]), .clr(ctrl_reset));
	reg_32 register5(.d(data_writeReg), .q(w5), .clk(clock), .en(we[5]), .clr(ctrl_reset));
	reg_32 register6(.d(data_writeReg), .q(w6), .clk(clock), .en(we[6]), .clr(ctrl_reset));
	reg_32 register7(.d(data_writeReg), .q(w7), .clk(clock), .en(we[7]), .clr(ctrl_reset));
	reg_32 register8(.d(data_writeReg), .q(w8), .clk(clock), .en(we[8]), .clr(ctrl_reset));
	reg_32 register9(.d(data_writeReg), .q(w9), .clk(clock), .en(we[9]), .clr(ctrl_reset));
	reg_32 register10(.d(data_writeReg), .q(w10), .clk(clock), .en(we[10]), .clr(ctrl_reset));
	reg_32 register11(.d(data_writeReg), .q(w11), .clk(clock), .en(we[11]), .clr(ctrl_reset));
	reg_32 register12(.d(data_writeReg), .q(w12), .clk(clock), .en(we[12]), .clr(ctrl_reset));
	reg_32 register13(.d(data_writeReg), .q(w13), .clk(clock), .en(we[13]), .clr(ctrl_reset));
	reg_32 register14(.d(data_writeReg), .q(w14), .clk(clock), .en(we[14]), .clr(ctrl_reset));
	reg_32 register15(.d(data_writeReg), .q(w15), .clk(clock), .en(we[15]), .clr(ctrl_reset));
	reg_32 register16(.d(data_writeReg), .q(w16), .clk(clock), .en(we[16]), .clr(ctrl_reset));
	reg_32 register17(.d(data_writeReg), .q(w17), .clk(clock), .en(we[17]), .clr(ctrl_reset));
	reg_32 register18(.d(data_writeReg), .q(w18), .clk(clock), .en(we[18]), .clr(ctrl_reset));
	reg_32 register19(.d(data_writeReg), .q(w19), .clk(clock), .en(we[19]), .clr(ctrl_reset));
	reg_32 register20(.d(data_writeReg), .q(w20), .clk(clock), .en(we[20]), .clr(ctrl_reset));
	reg_32 register21(.d(data_writeReg), .q(w21), .clk(clock), .en(we[21]), .clr(ctrl_reset));
	reg_32 register22(.d(data_writeReg), .q(w22), .clk(clock), .en(we[22]), .clr(ctrl_reset));
	reg_32 register23(.d(data_writeReg), .q(w23), .clk(clock), .en(we[23]), .clr(ctrl_reset));
	reg_32 register24(.d(data_writeReg), .q(w24), .clk(clock), .en(we[24]), .clr(ctrl_reset));
	reg_32 register25(.d(data_writeReg), .q(w25), .clk(clock), .en(we[25]), .clr(ctrl_reset));
	reg_32 register26(.d(data_writeReg), .q(w26), .clk(clock), .en(we[26]), .clr(ctrl_reset));
	reg_32 register27(.d(data_writeReg), .q(w27), .clk(clock), .en(we[27]), .clr(ctrl_reset));
	reg_32 register28(.d(data_writeReg), .q(w28), .clk(clock), .en(we[28]), .clr(ctrl_reset));
	reg_32 register29(.d(data_writeReg), .q(w29), .clk(clock), .en(we[29]), .clr(ctrl_reset));
	reg_32 register30(.d(data_writeReg), .q(w30), .clk(clock), .en(we[30]), .clr(ctrl_reset));
	reg_32 register31(.d(data_writeReg), .q(w31), .clk(clock), .en(we[31]), .clr(ctrl_reset));*/
	
	//mux_32 readA(ctrl_readRegA, w[0], w[1], w[2], w[3], w[4], w[5], w[6], w[7], w[8], w[9], w[10], w[11], w[12], w[13], w[14], w[15], w[16], w[17], w[18], w[19], w[20], w[21], w[22], w[23], w[24], w[25], w[26], w[27], w[28], w[29], w[30], w[31], data_readRegA);
	//mux_32 readB(ctrl_readRegB, w[0], w[1], w[2], w[3], w[4], w[5], w[6], w[7], w[8], w[9], w[10], w[11], w[12], w[13], w[14], w[15], w[16], w[17], w[18], w[19], w[20], w[21], w[22], w[23], w[24], w[25], w[26], w[27], w[28], w[29], w[30], w[31], data_readRegB);

endmodule