module skeleton(
	VGA_CLK,   														//	VGA Clock
	VGA_HS,															//	VGA H_SYNC
	VGA_VS,															//	VGA V_SYNC
	VGA_BLANK,														//	VGA BLANK
	VGA_SYNC,														//	VGA SYNC
	VGA_R,   														//	VGA Red[9:0]
	VGA_G,	 														//	VGA Green[9:0]
	VGA_B,															//	VGA Blue[9:0]resetn,
	CLOCK_50,                                                       // 50 MHz clock
	clock,
	ball,
	ball_x_pos,
	ball_y_pos,
	moveleft, moveright, moveup, movedown,
	address_imem, ctrl_writeEnable, ctrl_writeReg, data_writeReg,
	p1b1, p1b2, p1b3, p1ls, p2b1, p2b2, p2b3, p2ls, notes1, notes2, in_out);  													

	output [10:0] ball_x_pos, ball_y_pos;
	assign ball_x_pos = ball[31:21];
	assign ball_y_pos = ball[20:10];
	




	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, ps2_out, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	/* ############################################################################################
									LCD and Seven Segment Display 
	// ############################################################################################ */	
	output clock;
	//wire clock_invert;
	// clock divider 
	//clock_divider clock_divider_500000(.clock_in(CLOCK_50), .clock_out(clock_invert));
	assign clock = CLOCK_50;
	//assign clock = ~clock_invert;

	/* ############################################################################################
									 		VGA
	// ############################################################################################ */	
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
	input				CLOCK_50;
	input moveleft, moveright, moveup, movedown;
	
	input p1b1, p1b2, p1b3, p1ls, p2b1, p2b2, p2b3, p2ls;
	wire [5:0] guitar_in;
	//assign guitar_in[5] = ~p2b3 && p2ls; //add && p1ls when set up
	//assign guitar_in[4] = ~p2b2 && p2ls;
	//assign guitar_in[3] = ~p2b1 && p2ls;
	//assign guitar_in[2] = ~p1b3 && p1ls;
	//assign guitar_in[1] = ~p1b2 && p1ls;
	//assign guitar_in[0] = ~p1b1 && p1ls;
	assign guitar_in[5] = moveleft;
	assign guitar_in[4] = moveleft;
	assign guitar_in[3] = moveleft;
	assign guitar_in[2] = moveleft;
	assign guitar_in[1] = moveleft;
	assign guitar_in[0] = moveleft;
	
	
	wire [31:0] external_inputs;
	assign external_inputs [5:0] = guitar_in;
	assign external_inputs [31:6] = 26'b0;
	
	
	output [31:0] ball;
	wire [31:0] left_paddle, right_paddle;
	wire [31:0] notes3;
	output [31:0] notes1, notes2, in_out;
	
	Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST));
	VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
	vga_controller vga_ins( .iRST_n(DLY_RST),
							.iVGA_CLK(VGA_CLK),
						    .oBLANK_n(VGA_BLANK),
							.oHS(VGA_HS),
							.oVS(VGA_VS),
							.b_data(VGA_B),
							.g_data(VGA_G),
							.r_data(VGA_R), 
                            .pR_moveup(moveleft), .pR_movedown(moveright), .pL_moveup(moveup), .pL_movedown(movedown), 
                            // GuitarPong Objects
                            .ball(ball), .guitar_in(guitar_in), .left_paddle(left_paddle),  .right_paddle(right_paddle), .notes1(notes1), .notes2(notes2), .notes3(notes3));


	/* ############################################################################################
											 PROCESSOR SKELETON. 
	// ############################################################################################ */
    output [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            	// address of data
		.clken(1'b1),
        .clock      (~clock),                  	// you may need to invert the clock
        .q          (q_imem)		  			// the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (~clock),             // may need to invert the clock
        .data	    (data),               // data you want to write
        .wren	    (wren),               // write enable
        .q          (q_dmem)              // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    output ctrl_writeEnable;
	output [4:0] ctrl_writeReg;
    wire [4:0] ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
	wire reset;
	assign reset = 1'b0;
	
    regfile my_regfile(
        .clock(clock),
        .ctrl_writeEnable(ctrl_writeEnable),
        .ctrl_reset(reset),
        .ctrl_writeReg(ctrl_writeReg),
        .ctrl_readRegA(ctrl_readRegA),
        .ctrl_readRegB(ctrl_readRegB),
        .data_writeReg(data_writeReg),
        .data_readRegA(data_readRegA),
        .data_readRegB(data_readRegB),
			.ball(ball), .left_paddle(left_paddle), .right_paddle(right_paddle), .note_reg1(notes1), .note_reg2(notes2), .note_reg3(notes3), .external_inputs(external_inputs), .in_out(in_out)
    );
	 
	 wire [11:0] pc;

    /** PROCESSOR **/
    processor_processor my_processor(
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
		  pc
    );
	// ###############################################################################################################################################
	
endmodule


// fpga4student.com: FPGA projects, VHDL projects, Verilog projects
// Verilog project: Verilog code for clock divider on FPGA
// Top level Verilog code for clock divider on FPGA
module clock_divider(clock_in,clock_out);
input clock_in; // input clock on FPGA
output clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd2;
// The frequency of the output clk_out
//  = The frequency of the input clk_in divided by DIVISOR
// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
// You will modify the DIVISOR parameter value to 28'd50.000.000
// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
end
assign clock_out = (counter<DIVISOR/2)?1'b0:1'b1;
endmodule