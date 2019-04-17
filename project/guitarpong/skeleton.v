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
	leds,

	moveleft, moveright, moveup, movedown);  													







	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, ps2_out, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	/* ############################################################################################
									LCD and Seven Segment Display 
	// ############################################################################################ */	
	output [7:0] leds;
	output clock;
	// clock divider (by 5, i.e., 10 MHz)
	pll div(CLOCK_50,clock);
	assign leds[7:0] = 8'b00001111;

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
                            .ball(ball));


	/* ############################################################################################
											 PROCESSOR SKELETON. 
	// ############################################################################################ */
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    processor_imem my_imem(
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
    wire ctrl_writeEnable;
	wire [4:0] ctrl_writeReg;
    wire [4:0] ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
	wire [31:0] data_reg10;
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
		.ball(ball),
    );

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
