module vga_controller(iRST_n, iVGA_CLK,oBLANK_n,oHS,oVS, b_data, g_data, r_data, 
						// Custom Additions. 
                      pR_moveup, pR_movedown, pL_moveup, pL_movedown, ball, guitar_in, left_paddle, right_paddle,
							 notes1, notes2, notes3, game_info, player_info);
	// Prewritten VGA Controller Input/Output.
		input iRST_n; 				// N/A
		input iVGA_CLK; 			// VGA clock.
		output reg oBLANK_n; 		// N/A 
		output reg oHS; 			// N/A
		output reg oVS; 			// N/A
		output [7:0] b_data; 		// Blue color data for vga
		output [7:0] g_data; 		// Green color data for vga
		output [7:0] r_data; 		// Red color_index data for vga 

	// Prewritten VGA Controller  Wires/Registers
		reg [23:0] bgr_data;		// 
		reg [18:0] ADDR, ADDR_yelnote;			// Address of the current pixel. (encodes x & y pixel location). 

		wire [7:0] backgroud_index;			// Background color_index background_index at ADDR. 
		wire [23:0] bgr_data_raw, yelnote;	// 
		wire [7:0] color_index, yelnote_index;			// Color
		wire cBLANK_n,cHS,cVS;
		input [31:0] ball;
		
	// hit notes
		input [5:0] guitar_in;

	// Custom Code. Game Logic.
		input pR_moveup, pR_movedown, pL_moveup, pL_movedown; 
		
		input [31:0] left_paddle, right_paddle, notes1, notes2, notes3, game_info, player_info;

		// Screen Objects
			// Ball Properties
			wire [10:0] b_width, b_height;
			reg [10:0] b_xpos;
			reg [10:0] b_ypos;
			// TODO: possibly read this constant from processor. 
			assign b_width = 11'd20;
			assign b_height = 11'd20;
			
			// Paddles
			wire [11:0] pR_width, pR_height;
			reg [10:0] pR_xpos;
			reg [10:0] pR_ypos;
			reg [10:0] pL_xpos;
			reg [10:0] pL_ypos;
			// TODO: possibly read this constant from processor. 
			assign pR_width = 11'd20;
			assign pR_height = 11'd100;
			
			
			

		// Update Position on every clock cycle. 
			always@(posedge slowclock)
			begin
				b_xpos = ball[31:21];
				b_ypos = ball[20:10];
				pL_xpos = left_paddle[31:21];
				pL_ypos = left_paddle[20:10];
				pR_xpos = right_paddle[31:21];
				pR_ypos = right_paddle[20:10];
				
			end
			
			
			// =======================================================================================================================
			// -----------------------------LOGIC TO CACLULATE NOTE POSITION AND COLOR------------------------------------------------
			// =======================================================================================================================
			
			wire [10:0] p1note1_x, p1note2_x, p1note3_x, p1note4_x, p1note5_x, p1note6_x, p2note1_x, p2note2_x, p2note3_x, p2note4_x, p2note5_x, p2note6_x;
			wire [10:0] p1note1_y, p1note2_y, p1note3_y, p1note4_y, p1note5_y, p1note6_y, p2note1_y, p2note2_y, p2note3_y, p2note4_y, p2note5_y, p2note6_y;
			wire [7:0] p1note1_c, p1note2_c, p1note3_c, p1note4_c, p1note5_c, p1note6_c, p2note1_c, p2note2_c, p2note3_c, p2note4_c, p2note5_c, p2note6_c;
			assign p1note1_x = -notes1[31:21] + 11'd310; // 310 = 640/2 - 20/2
			assign p1note2_x = -notes1[15:5]  + 11'd310;
			assign p1note3_x = -notes2[31:21] + 11'd310;
			assign p1note4_x = -notes2[15:5]  + 11'd310;
			assign p1note5_x = -notes3[31:21] + 11'd310;
			assign p1note6_x = -notes3[15:5]  + 11'd310;
			assign p2note1_x = notes1[31:21]  + 11'd310;
			assign p2note2_x = notes1[15:5]   + 11'd310;
			assign p2note3_x = notes2[31:21]  + 11'd310;
			assign p2note4_x = notes2[15:5]   + 11'd310;
			assign p2note5_x = notes3[31:21]  + 11'd310;
			assign p2note6_x = notes3[15:5]   + 11'd310;
			
			z_pmux_3_12 n1y(.sel0(notes1[20]), .sel1(notes1[19]), .in0(12'd27), .in1(12'd77), .in2(12'd52), .out(p1note1_y));
			z_pmux_3_12 n2y(.sel0(notes1[4]),  .sel1(notes1[3]),  .in0(12'd27), .in1(12'd77), .in2(12'd52), .out(p1note2_y));
			z_pmux_3_12 n3y(.sel0(notes2[20]), .sel1(notes2[19]), .in0(12'd27), .in1(12'd77), .in2(12'd52), .out(p1note3_y));
			z_pmux_3_12 n4y(.sel0(notes2[4]),  .sel1(notes2[3]),  .in0(12'd27), .in1(12'd77), .in2(12'd52), .out(p1note4_y));
			z_pmux_3_12 n5y(.sel0(notes3[20]), .sel1(notes3[19]), .in0(12'd27), .in1(12'd77), .in2(12'd52), .out(p1note5_y));
			z_pmux_3_12 n6y(.sel0(notes3[4]),  .sel1(notes3[3]),  .in0(12'd27), .in1(12'd77), .in2(12'd52), .out(p1note6_y));
			assign p2note1_y = p1note1_y;
			assign p2note2_y = p1note2_y;
			assign p2note3_y = p1note3_y;
			assign p2note4_y = p1note4_y;
			assign p2note5_y = p1note5_y;
			assign p2note6_y = p1note6_y;
			
			z_pmux_3_8 n1c(.sel0(notes1[20]), .sel1(notes1[19]), .in0(8'h000003), .in1(8'h000005), .in2(8'h000004), .out(p1note1_c));
			z_pmux_3_8 n2c(.sel0(notes1[4]),  .sel1(notes1[3]),  .in0(8'h000003), .in1(8'h000005), .in2(8'h000004), .out(p1note2_c));
			z_pmux_3_8 n3c(.sel0(notes2[20]), .sel1(notes2[19]), .in0(8'h000003), .in1(8'h000005), .in2(8'h000004), .out(p1note3_c));
			z_pmux_3_8 n4c(.sel0(notes2[4]),  .sel1(notes2[3]),  .in0(8'h000003), .in1(8'h000005), .in2(8'h000004), .out(p1note4_c));
			z_pmux_3_8 n5c(.sel0(notes3[20]), .sel1(notes3[19]), .in0(8'h000003), .in1(8'h000005), .in2(8'h000004), .out(p1note5_c));
			z_pmux_3_8 n6c(.sel0(notes3[4]),  .sel1(notes3[3]),  .in0(8'h000003), .in1(8'h000005), .in2(8'h000004), .out(p1note6_c));
			assign p2note1_c = p1note1_c;
			assign p2note2_c = p1note2_c;
			assign p2note3_c = p1note3_c;
			assign p2note4_c = p1note4_c;
			assign p2note5_c = p1note5_c;
			assign p2note6_c = p1note6_c;
			
			// =======================================================================================================================
			// -----------------------------INITIALIZE COLORS & IMAGES------------------------------------------------
			// =======================================================================================================================

			 wire [11:0] x_ADDR, y_ADDR, y_ADDR_yelnote, x_ADDR_yelnote;  // Address of the x and y pixel that is currently being edited.
			 calcCord trs(ADDR, x_ADDR, y_ADDR);
			 
			 assign x_ADDR_yelnote = ADDR_yelnote%29;
			 assign y_ADDR_yelnote = ADDR_yelnote/29;
	 
			 wire inboundsx, inboundsy;
			 wire color_pL, color_pR, color_b, color_p1y, color_p1r, color_p1g, color_p2y, color_p2r, color_p2g, 
			 
				
				color_string1, color_string2, color_string3, color_p1note1, color_p1note2, color_p1note3, color_p1note4, color_p1note5, color_p1note6, 
				color_p2note1, color_p2note2, color_p2note3, color_p2note4, color_p2note5, color_p2note6,
				color_menu, color_end,
				color_p1l1, color_p1l2, color_p1l3, color_p2l1, color_p2l2, color_p2l3;
				
				
				// SPLASH SCREEN
				color_object color_start(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd120), .obj_ypos(12'd120), .obj_width(12'd100), .obj_length(12'd100), .color_obj(color_menu));
				color_object color_finish(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd220), .obj_ypos(12'd120), .obj_width(12'd100), .obj_length(12'd100), .color_obj(color_end));
				
				// HUD SHIT
				color_object color_p1l1o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd20), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p1l1));
				color_object color_p1l2o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd40), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p1l2));
				color_object color_p1l3o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd60), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p1l3));
				color_object color_p2l1o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd600), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p2l1));
				color_object color_p2l2o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd580), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p2l2));
				color_object color_p2l3o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd560), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p2l3));
			 
				// PADDLE + BALL
			 	color_object color_paddleL(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(pL_xpos), .obj_ypos(left_paddle[20:10]), .obj_width(12'd20), .obj_length(12'd100), .color_obj(color_pL));
			 	color_object color_paddleR(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(pR_xpos), .obj_ypos(pR_ypos), .obj_width(12'd20), .obj_length(12'd100), .color_obj(color_pR));
			 	color_object color_ball(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(b_xpos), .obj_ypos(b_ypos), .obj_width(12'd20), .obj_length(12'd20), .color_obj(color_b));
				
				// NOTES
				color_object color_p1n1(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note1_x), .obj_ypos(p1note1_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note1));
				color_object color_p1n2(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note2_x), .obj_ypos(p1note2_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note2));
				color_object color_p1n3(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note3_x), .obj_ypos(p1note3_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note3));
				color_object color_p1n4(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note4_x), .obj_ypos(p1note4_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note4));
				color_object color_p1n5(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note5_x), .obj_ypos(p1note5_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note5));
				color_object color_p1n6(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note6_x), .obj_ypos(p1note6_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note6));
				color_object color_p2n1(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note1_x), .obj_ypos(p2note1_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note1));
				color_object color_p2n2(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note2_x), .obj_ypos(p2note2_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note2));
				color_object color_p2n3(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note3_x), .obj_ypos(p2note3_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note3));
				color_object color_p2n4(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note4_x), .obj_ypos(p2note4_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note4));
				color_object color_p2n5(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note5_x), .obj_ypos(p2note5_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note5));
				color_object color_p2n6(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note6_x), .obj_ypos(p2note6_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note6));
				
				// STRUM EFFECTS
				color_object color_p1r_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd50), .obj_ypos(12'd25), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p1r));
				color_object color_p1g_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd50), .obj_ypos(12'd50), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p1g));
				color_object color_p1y_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd50), .obj_ypos(12'd75), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p1y));
				color_object color_p2r_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd585), .obj_ypos(12'd25), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p2r));
				color_object color_p2g_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd585), .obj_ypos(12'd50), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p2g));
				color_object color_p2y_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd585), .obj_ypos(12'd75), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p2y));
				
				// STRINGS
				color_object color_str1(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd0), .obj_ypos(12'd37), .obj_width(12'd640), .obj_length(12'd3), .color_obj(color_string1));
				color_object color_str2(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd0), .obj_ypos(12'd62), .obj_width(12'd640), .obj_length(12'd3), .color_obj(color_string2));
				color_object color_str3(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd0), .obj_ypos(12'd87), .obj_width(12'd640), .obj_length(12'd3), .color_obj(color_string3));
				
				//wire c_yel;
				//color_object img_note(.x_ADDR(x_ADDR_yelnote), .y_ADDR(y_ADDR_yelnote), .obj_xpos(12'd0), .obj_ypos(12'd0), .obj_width(12'd29), .obj_length(12'd29), .color_obj(c_yel));
			 	
				// =======================================================================================================================
				// -----------------------------PUT THINGS ON THE SCREEN------------------------------------------------
				// =======================================================================================================================
				
				wire [7:0] paddle_ball, strings, strums, notes, states, lives;
				
			 	wire [7:0] post_paddle1_index, post_paddle2_index, post_ball_index, 
					str1, str2, str3, 
					p1r, p1g, p1y, p2r, p2g, p2y, 
					p1n1, p1n2, p1n3, p1n4, p1n5, p1n6, p2n1, p2n2, p2n3, p2n4, p2n5, p2n6,
					menu, game_over, sp, mp,
					p1l1, p1l2, p1l3, p2l1, p2l2, p2l3, yelnotetest;
					
				// Paddle + Ball	
				assign post_paddle1_index = color_pL ? 8'h000002 : background_index;
			 	assign post_paddle2_index = color_pR ? 8'h000002 : post_paddle1_index;
				assign post_ball_index = color_b ? 8'h000002 : post_paddle2_index;
				assign paddle_ball = post_ball_index;
				
				assign str1 = color_string1 ? 8'h000006 : paddle_ball;
				assign str2 = color_string2 ? 8'h000006 : str1;
				assign str3 = color_string3 ? 8'h000006 : str2;
				assign strings = str3;
				
				assign p1n1 = (color_p1note1 && (notes1[20] || notes1[19] || notes1[18]) && ~notes1[17])  ? p1note1_c : strings;
				assign p1n2 = (color_p1note2 && (notes1[4]  || notes1[3]  || notes1[2])  && ~notes1[1] )  ? p1note2_c : p1n1;
				assign p1n3 = (color_p1note3 && (notes2[20] || notes2[19] || notes2[18]) && ~notes2[17])  ? p1note3_c : p1n2;
				assign p1n4 = (color_p1note4 && (notes2[4]  || notes2[3]  || notes2[2])  && ~notes2[1] )  ? p1note4_c : p1n3;
				assign p1n5 = (color_p1note5 && (notes3[20] || notes3[19] || notes3[18]) && ~notes3[17])  ? p1note5_c : p1n4;
				assign p1n6 = (color_p1note6 && (notes3[4]  || notes3[3]  || notes3[2])  && ~notes3[1] )  ? p1note6_c : p1n5;
				assign p2n1 = (color_p2note1 && (notes1[20] || notes1[19] || notes1[18]) && ~notes1[16])  ? p2note1_c : p1n6;
				assign p2n2 = (color_p2note2 && (notes1[4]  || notes1[3]  || notes1[2])  && ~notes1[0] )  ? p2note2_c : p2n1;
				assign p2n3 = (color_p2note3 && (notes2[20] || notes2[19] || notes2[18]) && ~notes2[16])  ? p2note3_c : p2n2;
				assign p2n4 = (color_p2note4 && (notes2[4]  || notes2[3]  || notes2[2])  && ~notes2[0] )  ? p2note4_c : p2n3;
				assign p2n5 = (color_p2note5 && (notes3[20] || notes3[19] || notes3[18]) && ~notes3[16])  ? p2note5_c : p2n4;
				assign p2n6 = (color_p2note6 && (notes3[4]  || notes3[3]  || notes3[2])  && ~notes3[0] )  ? p2note6_c : p2n5;
				assign notes = p2n6;
				
				
				assign p1r = (color_p1r && guitar_in[0]) ? 8'h000003 : notes;
				assign p1g = (color_p1g && guitar_in[1]) ? 8'h000004 : p1r;
				assign p1y = (color_p1y && guitar_in[2]) ? 8'h000005 : p1g;
				assign p2r = (color_p2r && guitar_in[3]) ? 8'h000003 : p1y;
				assign p2g = (color_p2g && guitar_in[4]) ? 8'h000004 : p2r;
				assign p2y = (color_p2y && guitar_in[5]) ? 8'h000005 : p2g;
				assign strums = p2y;
				
				assign menu = (color_menu && (game_info[1:0] == 2'b00)) ? 8'h000005 : strums; //yellow
				assign sp = (color_menu && (game_info[1:0] == 2'b01)) ? 8'h000003 : menu;  	//red
				assign mp = (color_menu && (game_info[1:0] == 2'b10)) ? 8'h000006 : sp;			//black
				assign game_over = (color_end && (game_info[1:0] == 2'b11)) ? 8'h000004 : mp;	//green
				assign states = game_over;
				
				assign p1l1 = (color_p1l1 && (player_info[9:5] > 5'd0)) ? 8'h000003 : states;
				assign p1l2 = (color_p1l2 && (player_info[9:5] > 5'd1)) ? 8'h000003 : p1l1;
				assign p1l3 = (color_p1l3 && (player_info[9:5] > 5'd2)) ? 8'h000003 : p1l2;
				assign p2l1 = (color_p2l1 && (player_info[4:0] > 5'd0)) ? 8'h000003 : p1l3;
				assign p2l2 = (color_p2l2 && (player_info[4:0] > 5'd1)) ? 8'h000003 : p2l1;
				assign p2l3 = (color_p2l3 && (player_info[4:0] > 5'd2)) ? 8'h000003 : p2l2;
				
				//assign yelnotetest = c_yel ? yelnote_index : p2l3;
				
				
				assign color_index = p2l3;
				
				
				
				

	// Handle ADDR Manipulation. 
		always@(posedge iVGA_CLK,negedge iRST_n)
		begin
		  if (!iRST_n)
		  begin
		     ADDR<=19'd0;
			  //ADDR_yelnote<=19'd0;
			  end
		  else if (cHS==1'b0 && cVS==1'b0)
		  begin
		     ADDR<=19'd0;
			  //ADDR_yelnote<=19'd0;
			  end
		  else if (cBLANK_n==1'b1)
		  begin
		     ADDR<=ADDR+1;
			  //ADDR_yelnote<=ADDR_yelnote+1;
			  end
			  
		end

	// Video Sync Generator Helper Function
		video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
		                              .reset(~iRST_n),
		                              .blank_n(cBLANK_n),
		                              .HS(cHS),
		                              .VS(cVS));

	// Clock Divider Code
		/*	################################################################
		 					Clock Divider Helper 
			################################################################  */
		reg [20:0] counter = 20'b0;
		reg slowclock = 20'b0;
		always@(posedge iVGA_CLK)
		begin
			if (counter == 20'd1000000)
			begin
				slowclock = !slowclock;
				counter = 20'b0;
			end
			else
				counter = counter+20'b1;
		end

	// Manages VGA Color Indexing and updating.
		img_data	img_data_inst (
			.address (ADDR),
			.clock (~VGA_CLK_n),
			.q (background_index)
			);
		
		img_index	img_index_inst (
			.address (color_index),
			.clock (iVGA_CLK),
			.q (bgr_data_raw)
			);
			
		yelnote_data	yel_d (
			.address ((ADDR-12'd640*12'd40+12'd40) - (12'd640-12'd29)*(ADDR/12'd640-12'd40)),
			.clock (~VGA_CLK_n),
			.q (yelnote_index)
			);
		
		yelnote_index	yel_i (
			.address (yelnote_index),
			.clock (iVGA_CLK),
			.q (yelnote)
			);

		// Latch valid color_index data at falling of the VGA clock.
		//always@(posedge ~iVGA_CLK) begin
		always@(ADDR) begin
			if (x_ADDR < 12'd69 && y_ADDR < 12'd69 && x_ADDR > 12'd40 && y_ADDR > 12'd40 && (yelnote != 24'hff00ff))
				bgr_data <= yelnote;
			else 
				bgr_data <= bgr_data_raw;
		end
		assign r_data = bgr_data[23:16];
		assign g_data = bgr_data[15:8];
		assign b_data = bgr_data[7:0]; 
		//////Delay the iHD, iVD,iDEN for one clock cycle;
		always@(negedge iVGA_CLK)
		begin
		  oHS<=cHS;
		  oVS<=cVS;
		  oBLANK_n<=cBLANK_n;
		end
endmodule


 	
module color_object(x_ADDR, y_ADDR, obj_xpos, obj_ypos, obj_width, obj_length, color_obj);
	input [11:0] x_ADDR, y_ADDR, obj_xpos, obj_ypos, obj_width, obj_length;
	output color_obj;

	wire inboundsX, inboundsY; 
	assign inboundsX = ((x_ADDR - obj_xpos) < obj_width && (x_ADDR - obj_xpos) > 12'd0);
	assign inboundsY = ((y_ADDR - obj_ypos) < obj_length && (y_ADDR - obj_ypos) > 12'd0);

	assign color_obj = inboundsX & inboundsY;
endmodule

module img_object(x_ADDR, y_ADDR, obj_xpos, obj_ypos, obj_width, obj_length, img_obj);
	input [11:0] x_ADDR, y_ADDR, obj_xpos, obj_ypos, obj_width, obj_length;
	output img_obj;

	wire inboundsX, inboundsY; 
	assign inboundsX = ((x_ADDR - obj_xpos) < obj_width && (x_ADDR - obj_xpos) > 12'd0);
	assign inboundsY = ((y_ADDR - obj_ypos) < obj_length && (y_ADDR - obj_ypos) > 12'd0);

	assign color_obj = inboundsX & inboundsY;
endmodule

module calcCord(address, hor, ver);
	input [18:0] address;
	output [11:0] hor, ver;
	assign hor = address%640;
	assign ver = address/640;
endmodule