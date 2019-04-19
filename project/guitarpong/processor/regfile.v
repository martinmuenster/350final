module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB,
	ball, left_paddle, right_paddle, note_reg1, note_reg2, note_reg3, external_inputs, in_out
);

   	input clock, ctrl_writeEnable, ctrl_reset;
   	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   	input [31:0] data_writeReg;
		
		input [31:0] external_inputs;

   	output [31:0] data_readRegA, data_readRegB;
	output [31:0] ball, left_paddle, right_paddle;
	output [31:0] note_reg1, note_reg2, note_reg3, in_out;
	assign in_out = w[29];
	
	assign ball = w[10];
	assign left_paddle = w[11];
	assign right_paddle = w[12];
	assign note_reg1 = w[20];
	assign note_reg2 = w[21];
	assign note_reg3 = w[22];
	//assign w[29] = external_inputs;
	
	wire nclock;
	assign nclock = ~clock;
	wire [31:0] write, we, read1, read2;
	
	z_decoder_32 decoder0(.select(ctrl_writeReg), .out(write));
	z_decoder_32 decoder1(.select(ctrl_readRegA), .out(read1));
	z_decoder_32 decoder2(.select(ctrl_readRegB), .out(read2));
	
	assign we = ctrl_writeEnable ? write : 32'b0;
	
	wire [31:0] w [31:0];
	
	d_reg_32 myReg(.d(external_inputs), .q(w[29]), .clk(nclock), .en(1'b1), .clr(ctrl_reset));
	assign data_readRegA = read1[29] ? w[29] : 32'bz;
	assign data_readRegB = read2[29] ? w[29] : 32'bz;
	
	genvar i;
	generate
		for (i=1; i<29; i=i+1) begin: loop1
			d_reg_32 myReg(.d(data_writeReg), .q(w[i]), .clk(nclock), .en(we[i]), .clr(ctrl_reset));
			assign data_readRegA = read1[i] ? w[i] : 32'bz;
			assign data_readRegB = read2[i] ? w[i] : 32'bz;
		end
	endgenerate
	generate
		for (i=30; i<32; i=i+1) begin: loop2
			d_reg_32 myReg(.d(data_writeReg), .q(w[i]), .clk(nclock), .en(we[i]), .clr(ctrl_reset));
			assign data_readRegA = read1[i] ? w[i] : 32'bz;
			assign data_readRegB = read2[i] ? w[i] : 32'bz;
		end
	endgenerate
   
	d_reg_32 register0(.d(32'b0), .q(w[0]), .clk(nclock), .en(1'b0), .clr(ctrl_reset));
	assign data_readRegA = read1[0] ? w[0] : 32'bz;
	assign data_readRegB = read2[0] ? w[0] : 32'bz;
endmodule
