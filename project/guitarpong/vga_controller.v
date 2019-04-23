module vga_controller(iRST_n, iVGA_CLK,oBLANK_n,oHS,oVS, b_data, g_data, r_data, 
						// Custom Additions. 
                      pR_moveup, pR_movedown, pL_moveup, pL_movedown, ball, guitar_in, left_paddle, right_paddle,
							 notes1, notes2, notes3, notes4, game_info, player_info);
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
		reg [18:0] ADDR;			// Address of the current pixel. (encodes x & y pixel location). 

		wire [7:0] backgroud_index;			// Background color_index background_index at ADDR. 
		wire [23:0] bgr_data_raw, note_img, string_img, paddle_img, ball_img, flame_img, logo_img, welcome_img, over_img, one_img, inst_img, hit_img, life_img;
		wire [7:0] color_index, str_index, paddle_index, ball_index, flame_index, logo_index, welcome_index, over_index, one_index, inst_index, hit_index, life_index;
		wire [2:0] note_index;			// Color
		wire cBLANK_n,cHS,cVS;
		input [31:0] ball;
		
	// hit notes
		input [5:0] guitar_in;

	// Custom Code. Game Logic.
		input pR_moveup, pR_movedown, pL_moveup, pL_movedown; 
		
		input [31:0] left_paddle, right_paddle, notes1, notes2, notes3, notes4, game_info, player_info;

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
			
			wire [10:0] p1note1_x, p1note2_x, p1note3_x, p1note4_x, p1note5_x, p1note6_x, p1note7_x, p1note8_x, p2note1_x, p2note2_x, p2note3_x, p2note4_x, p2note5_x, p2note6_x, p2note7_x, p2note8_x;
			wire [10:0] p1note1_xi, p1note2_xi, p1note3_xi, p1note4_xi, p1note5_xi, p1note6_xi, p1note7_xi, p1note8_xi, p2note1_xi, p2note2_xi, p2note3_xi, p2note4_xi, p2note5_xi, p2note6_xi, p2note7_xi, p2note8_xi;
			wire [10:0] p1note1_y, p1note2_y, p1note3_y, p1note4_y, p1note5_y, p1note6_y, p1note7_y, p1note8_y, p2note1_y, p2note2_y, p2note3_y, p2note4_y, p2note5_y, p2note6_y, p2note7_y, p2note8_y;
			wire [7:0]  p1note1_c, p1note2_c, p1note3_c, p1note4_c, p1note5_c, p1note6_c, p1note7_c, p1note8_c, p2note1_c, p2note2_c, p2note3_c, p2note4_c, p2note5_c, p2note6_c, p2note7_c, p2note8_c, note_color;
			
			
			
			assign p1note1_x[10:0] = -notes1[31:21] + 10'd310;
			assign p1note2_x[10:0] = -notes1[15:5]  + 10'd310;
			assign p1note3_x[10:0] = -notes2[31:21] + 10'd310;
			assign p1note4_x[10:0] = -notes2[15:5]  + 10'd310;
			assign p1note5_x[10:0] = -notes3[31:21] + 10'd310;
			assign p1note6_x[10:0] = -notes3[15:5]  + 10'd310;
			assign p1note7_x[10:0] = -notes4[31:21] + 10'd310;
			assign p1note8_x[10:0] = -notes4[15:5]  + 10'd310;
			assign p2note1_x[10:0] = notes1[31:21]  + 10'd310;
			assign p2note2_x[10:0] = notes1[15:5]   + 10'd310;
			assign p2note3_x[10:0] = notes2[31:21]  + 10'd310;
			assign p2note4_x[10:0] = notes2[15:5]   + 10'd310;
			assign p2note5_x[10:0] = notes3[31:21]  + 10'd310;
			assign p2note6_x[10:0] = notes3[15:5]   + 10'd310;
			assign p2note7_x[10:0] = notes4[31:21]  + 10'd310;
			assign p2note8_x[10:0] = notes4[15:5]   + 10'd310;
			
			

			
			//assign p1note1_xi[8:0] = notes1[31:23];// 310 = 640/2 - 20/2
			//assign p1note2_xi[8:0] = notes1[15:7] ;
			//assign p1note3_xi[8:0] = notes2[31:23];
			//assign p1note4_xi[8:0] = notes2[15:7] ;
			//assign p1note5_xi[8:0] = notes3[31:23];
			//assign p1note6_xi[8:0] = notes3[15:7] ;
			//assign p1note7_xi[8:0] = notes4[31:23];
			//assign p1note8_xi[8:0] = notes4[15:7] ;
			//assign p2note1_xi[8:0] = notes1[31:23];
			//assign p2note2_xi[8:0] = notes1[15:7] ;
			//assign p2note3_xi[8:0] = notes2[31:23];
			//assign p2note4_xi[8:0] = notes2[15:7] ;
			//assign p2note5_xi[8:0] = notes3[31:23];
			//assign p2note6_xi[8:0] = notes3[15:7] ;
			//assign p2note7_xi[8:0] = notes4[31:23];
			//assign p2note8_xi[8:0] = notes4[15:7] ;
			//assign p1note1_xi[10:9]= 2'b0;
			//assign p1note2_xi[10:9]= 2'b0;
			//assign p1note3_xi[10:9]= 2'b0;
			//assign p1note4_xi[10:9]= 2'b0;
			//assign p1note5_xi[10:9]= 2'b0;
			//assign p1note6_xi[10:9]= 2'b0;
			//assign p1note7_xi[10:9]= 2'b0;
			//assign p1note8_xi[10:9]= 2'b0;
			//assign p2note1_xi[10:9]= 2'b0;
			//assign p2note2_xi[10:9]= 2'b0;
			//assign p2note3_xi[10:9]= 2'b0;
			//assign p2note4_xi[10:9]= 2'b0;
			//assign p2note5_xi[10:9]= 2'b0;
			//assign p2note6_xi[10:9]= 2'b0;
			//assign p2note7_xi[10:9]= 2'b0;
			//assign p2note8_xi[10:9]= 2'b0;
			//assign p1note1_x = -p1note1_xi + 10'd310;
			//assign p1note2_x = -p1note2_xi + 10'd310;
			//assign p1note3_x = -p1note3_xi + 10'd310;
			//assign p1note4_x = -p1note4_xi + 10'd310;
			//assign p1note5_x = -p1note5_xi + 10'd310;
			//assign p1note6_x = -p1note6_xi + 10'd310;
			//assign p1note7_x = -p1note7_xi + 10'd310;
			//assign p1note8_x = -p1note8_xi + 10'd310;
			//assign p2note1_x =  p2note1_xi + 10'd310;
			//assign p2note2_x =  p2note2_xi + 10'd310;
			//assign p2note3_x =  p2note3_xi + 10'd310;
			//assign p2note4_x =  p2note4_xi + 10'd310;
			//assign p2note5_x =  p2note5_xi + 10'd310;
			//assign p2note6_x =  p2note6_xi + 10'd310;
			//assign p2note7_x =  p2note7_xi + 10'd310;
			//assign p2note8_x =  p2note8_xi + 10'd310;
			
			
			z_pmux_3_12 n1y(.sel0(notes1[18]), .sel1(notes1[19]), .in0(12'd76), .in1(12'd7), .in2(12'd41), .out(p1note1_y));
			z_pmux_3_12 n2y(.sel0(notes1[2]),  .sel1(notes1[3]),  .in0(12'd76), .in1(12'd7), .in2(12'd41), .out(p1note2_y));
			z_pmux_3_12 n3y(.sel0(notes2[18]), .sel1(notes2[19]), .in0(12'd76), .in1(12'd7), .in2(12'd41), .out(p1note3_y));
			z_pmux_3_12 n4y(.sel0(notes2[2]),  .sel1(notes2[3]),  .in0(12'd76), .in1(12'd7), .in2(12'd41), .out(p1note4_y));
			z_pmux_3_12 n5y(.sel0(notes3[18]), .sel1(notes3[19]), .in0(12'd76), .in1(12'd7), .in2(12'd41), .out(p1note5_y));
			z_pmux_3_12 n6y(.sel0(notes3[2]),  .sel1(notes3[3]),  .in0(12'd76), .in1(12'd7), .in2(12'd41), .out(p1note6_y));
			z_pmux_3_12 n7y(.sel0(notes4[18]), .sel1(notes4[19]), .in0(12'd76), .in1(12'd7), .in2(12'd41), .out(p1note7_y));
			z_pmux_3_12 n8y(.sel0(notes4[2]),  .sel1(notes4[3]),  .in0(12'd76), .in1(12'd7), .in2(12'd41), .out(p1note8_y));
			assign p2note1_y = p1note1_y;
			assign p2note2_y = p1note2_y;
			assign p2note3_y = p1note3_y;
			assign p2note4_y = p1note4_y;
			assign p2note5_y = p1note5_y;
			assign p2note6_y = p1note6_y;
			assign p2note7_y = p1note7_y;
			assign p2note8_y = p1note8_y;
			
			z_pmux_3_8 n1c(.sel0(notes1[18]), .sel1(notes1[19]), .in0(8'h000005), .in1(8'h000006), .in2(8'h000004), .out(p1note1_c));
			z_pmux_3_8 n2c(.sel0(notes1[2]),  .sel1(notes1[3]),  .in0(8'h000005), .in1(8'h000006), .in2(8'h000004), .out(p1note2_c));
			z_pmux_3_8 n3c(.sel0(notes2[18]), .sel1(notes2[19]), .in0(8'h000005), .in1(8'h000006), .in2(8'h000004), .out(p1note3_c));
			z_pmux_3_8 n4c(.sel0(notes2[2]),  .sel1(notes2[3]),  .in0(8'h000005), .in1(8'h000006), .in2(8'h000004), .out(p1note4_c));
			z_pmux_3_8 n5c(.sel0(notes3[18]), .sel1(notes3[19]), .in0(8'h000005), .in1(8'h000006), .in2(8'h000004), .out(p1note5_c));
			z_pmux_3_8 n6c(.sel0(notes3[2]),  .sel1(notes3[3]),  .in0(8'h000005), .in1(8'h000006), .in2(8'h000004), .out(p1note6_c));
			z_pmux_3_8 n7c(.sel0(notes4[18]), .sel1(notes4[19]), .in0(8'h000005), .in1(8'h000006), .in2(8'h000004), .out(p1note7_c));
			z_pmux_3_8 n8c(.sel0(notes4[2]),  .sel1(notes4[3]),  .in0(8'h000005), .in1(8'h000006), .in2(8'h000004), .out(p1note8_c));
			assign p2note1_c = p1note1_c;
			assign p2note2_c = p1note2_c;
			assign p2note3_c = p1note3_c;
			assign p2note4_c = p1note4_c;
			assign p2note5_c = p1note5_c;
			assign p2note6_c = p1note6_c;
			assign p2note7_c = p1note7_c;
			assign p2note8_c = p1note8_c;
			
			mux_16 choose_color(.c(c), 
			.in0( p1note1_c), 
			.in1( p1note2_c), 
			.in2( p1note3_c), 
			.in3( p1note4_c), 
			.in4( p1note5_c), 
			.in5( p1note6_c), 
			.in6( p1note7_c), 
			.in7( p1note8_c), 
			.in8( p2note1_c), 
			.in9( p2note2_c), 
			.in10(p2note3_c), 
			.in11(p2note4_c), 
			.in12(p2note5_c),
			.in13(p2note6_c),
			.in14(p2note7_c),
			.in15(p2note8_c),
			.out(note_color));
			

			// =======================================================================================================================
			// -----------------------------INITIALIZE COLORS & IMAGES------------------------------------------------
			// =======================================================================================================================

			 wire [11:0] x_ADDR, y_ADDR; // Address of the x and y pixel that is currently being edited.
			 calcCord trs(ADDR, x_ADDR, y_ADDR);

	 
			 wire inboundsx, inboundsy;
			 wire color_pL, color_pR, color_b, color_p1hit1, color_p1hit2, color_p1hit3, color_p2hit1, color_p2hit2, color_p2hit3, 
			 
				
				color_p1note1, color_p1note2, color_p1note3, color_p1note4, color_p1note5, color_p1note6, color_p1note7, color_p1note8,
				color_p2note1, color_p2note2, color_p2note3, color_p2note4, color_p2note5, color_p2note6, color_p2note7, color_p2note8,
				color_menu, color_end,
				color_p1l1, color_p1l2, color_p1l3, color_p2l1, color_p2l2, color_p2l3, color_life,
				color_p1p1, color_p2p1, color_power,
				//color_p1l1, color_p1l2, color_p1l3, color_p2l1, color_p2l2, color_p2l3, color_life,
				color_str, color_logo, color_over, color_one, color_inst, color_welcome, 
				color_p1perf1, color_p1perf2, color_p1perf3, color_p1perf4, color_p1perf5, color_p1perf6, color_p1perf7, color_p1perf8, 
				color_p2perf1, color_p2perf2, color_p2perf3, color_p2perf4, color_p2perf5, color_p2perf6, color_p2perf7, color_p2perf8, color_flame;
				
				
				
				
				
				// SPLASH SCREEN/BACKGROUNd
				//color_object color_start(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd120), .obj_ypos(12'd120), .obj_width(12'd100), .obj_length(12'd100), .color_obj(color_menu));
				//color_object color_finish(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd220), .obj_ypos(12'd120), .obj_width(12'd100), .obj_length(12'd100), .color_obj(color_end));
				color_object color_header(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd0), .obj_ypos(12'd0), .obj_width(12'd640), .obj_length(12'd113), .color_obj(color_str));
				color_object color_log(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd153), .obj_ypos(12'd184), .obj_width(12'd334), .obj_length(12'd225), .color_obj(color_logo));
				color_object color_enp(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd153), .obj_ypos(12'd184), .obj_width(12'd334), .obj_length(12'd225), .color_obj(color_over));
				color_object color_ins(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd220), .obj_ypos(12'd420), .obj_width(12'd200), .obj_length(12'd50), .color_obj(color_inst));
				color_object color_wel(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd220), .obj_ypos(12'd127), .obj_width(12'd200), .obj_length(12'd40), .color_obj(color_welcome));
				color_object color_onp(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd317), .obj_ypos(12'd273), .obj_width(12'd24), .obj_length(12'd52), .color_obj(color_one));
				
				
				
				// HUD SHIT
				color_object color_p1l1o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd20), .obj_ypos(12'd460), .obj_width(12'd10),  .obj_length(12'd10), .color_obj(color_p1l1));
				color_object color_p1l2o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd40), .obj_ypos(12'd460), .obj_width(12'd10),  .obj_length(12'd10), .color_obj(color_p1l2));
				color_object color_p1l3o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd60), .obj_ypos(12'd460), .obj_width(12'd10),  .obj_length(12'd10), .color_obj(color_p1l3));
				color_object color_p2l1o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd600), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p2l1));
				color_object color_p2l2o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd580), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p2l2));
				color_object color_p2l3o(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd560), .obj_ypos(12'd460), .obj_width(12'd10), .obj_length(12'd10), .color_obj(color_p2l3));
				assign color_life = color_p1l1 || color_p1l2 || color_p1l3 || color_p2l1 || color_p2l2 || color_p2l3;
				
				
				color_object color_p1p2a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd100), .obj_ypos(12'd460), .obj_width(12'd10),  .obj_length(12'd10), .color_obj(color_p1p1));
				color_object color_p2p2a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd520), .obj_ypos(12'd460), .obj_width(12'd10),  .obj_length(12'd10), .color_obj(color_p2p1));
				assign color_power = color_p1p1 || color_p2p1;
			 
				// PADDLE + BALL
			 	//color_object color_paddleL(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(pL_xpos), .obj_ypos(left_paddle[20:10]), .obj_width(12'd20), .obj_length(12'd100), .color_obj(color_pL));
			 	//color_object color_paddleR(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(pR_xpos), .obj_ypos(pR_ypos), .obj_width(12'd20), .obj_length(12'd100), .color_obj(color_pR));
				color_object color_paddleL(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(pL_xpos), .obj_ypos(left_paddle[20:10]), .obj_width(12'd11), .obj_length(12'd100), .color_obj(color_pL));
			 	color_object color_paddleR(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(pR_xpos), .obj_ypos(right_paddle[20:10]), .obj_width(12'd11), .obj_length(12'd100), .color_obj(color_pR));
			 	//color_object color_ball(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(b_xpos), .obj_ypos(b_ypos), .obj_width(12'd20), .obj_length(12'd20), .color_obj(color_b));
				color_object color_ball(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(b_xpos), .obj_ypos(b_ypos), .obj_width(12'd26), .obj_length(12'd26), .color_obj(color_b));
				
				// NOTES
				//color_object color_p1n1(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note1_x), .obj_ypos(p1note1_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note1));
				//color_object color_p1n2(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note2_x), .obj_ypos(p1note2_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note2));
				//color_object color_p1n3(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note3_x), .obj_ypos(p1note3_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note3));
				//color_object color_p1n4(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note4_x), .obj_ypos(p1note4_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note4));
				//color_object color_p1n5(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note5_x), .obj_ypos(p1note5_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note5));
				//color_object color_p1n6(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note6_x), .obj_ypos(p1note6_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p1note6));
				//color_object color_p2n1(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note1_x), .obj_ypos(p2note1_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note1));
				//color_object color_p2n2(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note2_x), .obj_ypos(p2note2_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note2));
				//color_object color_p2n3(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note3_x), .obj_ypos(p2note3_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note3));
				//color_object color_p2n4(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note4_x), .obj_ypos(p2note4_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note4));
				//color_object color_p2n5(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note5_x), .obj_ypos(p2note5_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note5));
				//color_object color_p2n6(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note6_x), .obj_ypos(p2note6_y), .obj_width(12'd21), .obj_length(12'd21), .color_obj(color_p2note6));
				
				color_object color_p1n1(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note1_x), .obj_ypos(p1note1_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p1note1));
				color_object color_p1n2(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note2_x), .obj_ypos(p1note2_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p1note2));
				color_object color_p1n3(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note3_x), .obj_ypos(p1note3_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p1note3));
				color_object color_p1n4(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note4_x), .obj_ypos(p1note4_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p1note4));
				color_object color_p1n5(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note5_x), .obj_ypos(p1note5_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p1note5));
				color_object color_p1n6(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note6_x), .obj_ypos(p1note6_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p1note6));
				color_object color_p1n7(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note7_x), .obj_ypos(p1note7_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p1note7));
				color_object color_p1n8(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note8_x), .obj_ypos(p1note8_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p1note8));
				color_object color_p2n1(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note1_x), .obj_ypos(p2note1_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p2note1));
				color_object color_p2n2(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note2_x), .obj_ypos(p2note2_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p2note2));
				color_object color_p2n3(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note3_x), .obj_ypos(p2note3_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p2note3));
				color_object color_p2n4(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note4_x), .obj_ypos(p2note4_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p2note4));
				color_object color_p2n5(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note5_x), .obj_ypos(p2note5_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p2note5));
				color_object color_p2n6(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note6_x), .obj_ypos(p2note6_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p2note6));
				color_object color_p2n7(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note7_x), .obj_ypos(p2note7_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p2note7));
				color_object color_p2n8(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note8_x), .obj_ypos(p2note8_y), .obj_width(12'd29), .obj_length(12'd29), .color_obj(color_p2note8));
				
				// STRUM EFFECTS
				//color_object color_p1r_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd50),  .obj_ypos(12'd25), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p1r));
				//color_object color_p1g_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd50),  .obj_ypos(12'd50), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p1g));
				//color_object color_p1y_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd50),  .obj_ypos(12'd75), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p1y));
				//color_object color_p2r_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd585), .obj_ypos(12'd25), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p2r));
				//color_object color_p2g_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd585), .obj_ypos(12'd50), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p2g));
				//color_object color_p2y_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd585), .obj_ypos(12'd75), .obj_width(12'd5), .obj_length(12'd25), .color_obj(color_p2y));
				
				color_object color_p1r_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd43 ), .obj_ypos(12'd5 ), .obj_width(12'd34), .obj_length(12'd33), .color_obj(color_p1hit1));
				color_object color_p1g_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd43 ), .obj_ypos(12'd39), .obj_width(12'd34), .obj_length(12'd33), .color_obj(color_p1hit2));
				color_object color_p1y_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd43 ), .obj_ypos(12'd73), .obj_width(12'd34), .obj_length(12'd33), .color_obj(color_p1hit3));
				color_object color_p2r_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd563), .obj_ypos(12'd5 ), .obj_width(12'd34), .obj_length(12'd33), .color_obj(color_p2hit1));
				color_object color_p2g_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd563), .obj_ypos(12'd39), .obj_width(12'd34), .obj_length(12'd33), .color_obj(color_p2hit2));
				color_object color_p2y_hit(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd563), .obj_ypos(12'd73), .obj_width(12'd34), .obj_length(12'd33), .color_obj(color_p2hit3));
				
				// FLAMES
				//color_object color_p1r_perf(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd41 ), .obj_ypos(12'd3 ), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf1));
				//color_object color_p1g_perf(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd41 ), .obj_ypos(12'd37), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf2));
				//color_object color_p1y_perf(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd41 ), .obj_ypos(12'd71), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf3));
				//color_object color_p2r_perf(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd561), .obj_ypos(12'd3 ), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf1));
				//color_object color_p2g_perf(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd561), .obj_ypos(12'd37), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf2));
				//color_object color_p2y_perf(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(12'd561), .obj_ypos(12'd71), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf3));
				
				color_object color_p1perf1a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note1_x-5), .obj_ypos(p1note1_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf1));
				color_object color_p1perf2a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note2_x-5), .obj_ypos(p1note2_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf2));
				color_object color_p1perf3a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note3_x-5), .obj_ypos(p1note3_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf3));
				color_object color_p1perf4a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note4_x-5), .obj_ypos(p1note4_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf4));
				color_object color_p1perf5a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note5_x-5), .obj_ypos(p1note5_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf5));
				color_object color_p1perf6a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note6_x-5), .obj_ypos(p1note6_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf6));
				color_object color_p1perf7a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note7_x-5), .obj_ypos(p1note7_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf7));
				color_object color_p1perf8a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p1note8_x-5), .obj_ypos(p1note8_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p1perf8));
				color_object color_p2perf1a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note1_x-5), .obj_ypos(p2note1_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf1));
				color_object color_p2perf2a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note2_x-5), .obj_ypos(p2note2_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf2));
				color_object color_p2perf3a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note3_x-5), .obj_ypos(p2note3_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf3));
				color_object color_p2perf4a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note4_x-5), .obj_ypos(p2note4_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf4));
				color_object color_p2perf5a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note5_x-5), .obj_ypos(p2note5_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf5));
				color_object color_p2perf6a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note6_x-5), .obj_ypos(p2note6_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf6));
				color_object color_p2perf7a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note7_x-5), .obj_ypos(p2note7_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf7));
				color_object color_p2perf8a(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(p2note8_x-5), .obj_ypos(p2note8_y-5), .obj_width(12'd39), .obj_length(12'd39), .color_obj(color_p2perf8));
				assign color_flame = color_p1perf1 || color_p1perf2 || color_p1perf3 || color_p1perf4 || color_p1perf5 || color_p1perf6 || color_p1perf7 || color_p1perf8 ||
											color_p2perf1 || color_p2perf2 || color_p2perf3 || color_p2perf4 || color_p2perf5 || color_p2perf6 || color_p2perf7 || color_p2perf8;
				
				// =======================================================================================================================
				// -----------------------------CALCULATE ADDRESS OFFSETS------------------------------------------------
				// =======================================================================================================================
				wire [18:0] addr_paddle, addr_pr, addr_pl;
				assign addr_paddle = color_pL ? addr_pl : addr_pr;
				address_offset off_pl(.addr_in(ADDR), .x_pos(pL_xpos), .y_pos(left_paddle[20:10]), .w(12'd11), .addr_out(addr_pl));
				address_offset off_pr(.addr_in(ADDR), .x_pos(pR_xpos), .y_pos(right_paddle[20:10]), .w(12'd11), .addr_out(addr_pr));
				
				wire [18:0] addr_ball;
				address_offset off_ball(.addr_in(ADDR), .x_pos(b_xpos), .y_pos(b_ypos), .w(12'd26), .addr_out(addr_ball));
				
				
				wire [15:0] c;
				assign c[0]   = color_p1note1; 
				assign c[1]   = color_p1note2; 
				assign c[2]   = color_p1note3;
				assign c[3]   = color_p1note4;
				assign c[4]   = color_p1note5;
				assign c[5]   = color_p1note6;
				assign c[6]   = color_p1note7;
				assign c[7]   = color_p1note8;
				assign c[8]   = color_p2note1;
				assign c[9]   = color_p2note2;
				assign c[10]  = color_p2note3;
				assign c[11]  = color_p2note4;
				assign c[12]  = color_p2note5;
				assign c[13]  = color_p2note6;
				assign c[14]  = color_p2note7;
				assign c[15]  = color_p2note8;
				
				wire in_note = color_p1note1 || color_p1note2 || color_p1note3 || color_p1note4 || color_p1note5 || color_p1note6 || color_p1note7|| color_p1note8 
								|| color_p2note1 || color_p2note2 || color_p2note3 || color_p2note4 || color_p2note5 || color_p2note6 || color_p2note7|| color_p2note8;
					

				wire [18:0] addr_note, addr_p1n1, addr_p1n2, addr_p1n3, addr_p1n4, addr_p1n5, addr_p1n6, addr_p1n7, addr_p1n8, addr_p2n1, addr_p2n2, addr_p2n3, addr_p2n4, addr_p2n5, addr_p2n6, addr_p2n7, addr_p2n8;
				address_offset off11(.addr_in(ADDR), .x_pos(p1note1_x), .y_pos(p1note1_y), .w(12'd29), .addr_out(addr_p1n1));
				address_offset off12(.addr_in(ADDR), .x_pos(p1note2_x), .y_pos(p1note2_y), .w(12'd29), .addr_out(addr_p1n2));
				address_offset off13(.addr_in(ADDR), .x_pos(p1note3_x), .y_pos(p1note3_y), .w(12'd29), .addr_out(addr_p1n3));
				address_offset off14(.addr_in(ADDR), .x_pos(p1note4_x), .y_pos(p1note4_y), .w(12'd29), .addr_out(addr_p1n4));
				address_offset off15(.addr_in(ADDR), .x_pos(p1note5_x), .y_pos(p1note5_y), .w(12'd29), .addr_out(addr_p1n5));
				address_offset off16(.addr_in(ADDR), .x_pos(p1note6_x), .y_pos(p1note6_y), .w(12'd29), .addr_out(addr_p1n6));
				address_offset off17(.addr_in(ADDR), .x_pos(p1note7_x), .y_pos(p1note7_y), .w(12'd29), .addr_out(addr_p1n7));
				address_offset off18(.addr_in(ADDR), .x_pos(p1note8_x), .y_pos(p1note8_y), .w(12'd29), .addr_out(addr_p1n8));
				address_offset off21(.addr_in(ADDR), .x_pos(p2note1_x), .y_pos(p2note1_y), .w(12'd29), .addr_out(addr_p2n1));
				address_offset off22(.addr_in(ADDR), .x_pos(p2note2_x), .y_pos(p2note2_y), .w(12'd29), .addr_out(addr_p2n2));
				address_offset off23(.addr_in(ADDR), .x_pos(p2note3_x), .y_pos(p2note3_y), .w(12'd29), .addr_out(addr_p2n3));
				address_offset off24(.addr_in(ADDR), .x_pos(p2note4_x), .y_pos(p2note4_y), .w(12'd29), .addr_out(addr_p2n4));
				address_offset off25(.addr_in(ADDR), .x_pos(p2note5_x), .y_pos(p2note5_y), .w(12'd29), .addr_out(addr_p2n5));
				address_offset off26(.addr_in(ADDR), .x_pos(p2note6_x), .y_pos(p2note6_y), .w(12'd29), .addr_out(addr_p2n6));
				address_offset off27(.addr_in(ADDR), .x_pos(p2note7_x), .y_pos(p2note7_y), .w(12'd29), .addr_out(addr_p2n7));
				address_offset off28(.addr_in(ADDR), .x_pos(p2note8_x), .y_pos(p2note8_y), .w(12'd29), .addr_out(addr_p2n8));
				
				mux_16 choose_address(.c(c), 
					.in0( addr_p1n1), 
					.in1( addr_p1n2), 
					.in2( addr_p1n3), 
					.in3( addr_p1n4), 
					.in4( addr_p1n5), 
					.in5( addr_p1n6), 
					.in6( addr_p1n7), 
					.in7( addr_p1n8), 
					.in8( addr_p2n1), 
					.in9( addr_p2n2), 
					.in10(addr_p2n3), 
					.in11(addr_p2n4),
					.in12(addr_p2n5),
			      .in13(addr_p2n6),
		         .in14(addr_p2n7),
		         .in15(addr_p2n8),
					.out(addr_note));
					
				
				wire note_exists;
				mux_16 existence(.c(c), 
					.in0( notes1[20] || notes1[19] || notes1[18]), 
					.in1( notes1[4]  || notes1[3]  || notes1[2] ), 
					.in2( notes2[20] || notes2[19] || notes2[18]), 
					.in3( notes2[4]  || notes2[3]  || notes2[2] ), 
					.in4( notes3[20] || notes3[19] || notes3[18]), 
					.in5( notes3[4]  || notes3[3]  || notes3[2] ),
					.in6( notes4[20] || notes4[19] || notes4[18]), 
					.in7( notes4[4]  || notes4[3]  || notes4[2] ), 
					.in8( notes1[20] || notes1[19] || notes1[18]), 
					.in9( notes1[4]  || notes1[3]  || notes1[2] ), 
					.in10(notes2[20] || notes2[19] || notes2[18]), 
					.in11(notes2[4]  || notes2[3]  || notes2[2] ),
					.in12(notes3[20] || notes3[19] || notes3[18]),
			      .in13(notes3[4]  || notes3[3]  || notes3[2] ),
		         .in14(notes4[20] || notes4[19] || notes4[18]),
		         .in15(notes4[4]  || notes4[3]  || notes4[2] ),
					.out(note_exists));
				
				wire note_hit;
				mux_16 hitness(.c(c), 
					.in0( notes1[17]), 
					.in1( notes1[1] ), 
					.in2( notes2[17]), 
					.in3( notes2[1] ), 
					.in4( notes3[17]), 
					.in5( notes3[1] ),
					.in6( notes4[17]), 
					.in7( notes4[1] ), 
					.in8( notes1[16]), 
					.in9( notes1[0] ), 
					.in10(notes2[16]), 
					.in11(notes2[0] ),
					.in12(notes3[16]),
			      .in13(notes3[0] ),
		         .in14(notes4[16]),
		         .in15(notes4[0] ),
					.out(note_hit));
					
				
				wire [18:0] addr_str, addr_logo, addr_over, addr_welcome, addr_inst, addr_one;
				assign addr_str = ADDR;
				address_offset adlog(.addr_in(ADDR), .x_pos(12'd153), .y_pos(12'd184), .w(12'd334), .addr_out(addr_logo));
				assign addr_over = addr_logo;
				address_offset adone (.addr_in(ADDR), .x_pos(12'd317), .y_pos(12'd273), .w(12'd24), .addr_out(addr_one));
				address_offset adwel(.addr_in(ADDR), .x_pos(12'd220), .y_pos(12'd127), .w(12'd200), .addr_out(addr_welcome));
				address_offset adins(.addr_in(ADDR), .x_pos(12'd220), .y_pos(12'd420), .w(12'd200), .addr_out(addr_inst));
				
				wire [18:0] addr_p1l1, addr_p1l2, addr_p1l3, addr_p2l1, addr_p2l2, addr_p2l3, addr_life;
				address_offset offl11 (.addr_in(ADDR), .x_pos(12'd20),  .y_pos(12'd460), .w(12'd10), .addr_out(addr_p1l1));
				address_offset offl12 (.addr_in(ADDR), .x_pos(12'd40),  .y_pos(12'd460), .w(12'd10), .addr_out(addr_p1l2));
				address_offset offl13 (.addr_in(ADDR), .x_pos(12'd60),  .y_pos(12'd460), .w(12'd10), .addr_out(addr_p1l3));
				address_offset offl21 (.addr_in(ADDR), .x_pos(12'd600), .y_pos(12'd460), .w(12'd10), .addr_out(addr_p2l1));
				address_offset offl22 (.addr_in(ADDR), .x_pos(12'd580), .y_pos(12'd460), .w(12'd10), .addr_out(addr_p2l2));
				address_offset offl23 (.addr_in(ADDR), .x_pos(12'd560), .y_pos(12'd460), .w(12'd10), .addr_out(addr_p2l3));
				
				wire [15:0] life;
				assign life[0]   = color_p1l1 && (player_info[9:5] > 5'd0); 
				assign life[1]   = color_p1l2 && (player_info[9:5] > 5'd1); 
				assign life[2]   = color_p1l3 && (player_info[9:5] > 5'd2);
				assign life[3]   = color_p2l1 && (player_info[4:0] > 5'd0);
				assign life[4]   = color_p2l2 && (player_info[4:0] > 5'd1);
				assign life[5]   = color_p2l3 && (player_info[4:0] > 5'd2);
				assign life[15:6]   = 10'b0;
				
				
				mux_16 life_addr(.c(life), 
					.in0(addr_p1l1), 
					.in1(addr_p1l2), 
					.in2(addr_p1l3), 
					.in3(addr_p2l1), 
					.in4(addr_p2l2), 
					.in5(addr_p2l3),
					.in6(1'b0), 
					.in7(1'b0), 
					.in8(1'b0), 
					.in9(1'b0), 
					.in10(1'b0), 
					.in11(1'b0), 
					.out(addr_life));
				
				//wire [18:0] addr_p1p1, addr_p2p1, addr_power;
				//address_offset offl11 (.addr_in(ADDR), .x_pos(12'd20),  .y_pos(12'd460), .w(12'd10), .addr_out(addr_p1l1));
				
				
				wire [18:0] addr_hit, addr_p1hit1, addr_p1hit2, addr_p1hit3, addr_p2hit1, addr_p2hit2, addr_p2hit3;
				wire [15:0] hit;
				
				
				address_offset offh11(.addr_in(ADDR), .x_pos(12'd43 ), .y_pos(12'd5 ), .w(12'd34), .addr_out(addr_p1hit1));
				address_offset offh12(.addr_in(ADDR), .x_pos(12'd43 ), .y_pos(12'd39), .w(12'd34), .addr_out(addr_p1hit2));
				address_offset offh13(.addr_in(ADDR), .x_pos(12'd43 ), .y_pos(12'd73), .w(12'd34), .addr_out(addr_p1hit3));
				address_offset offh21(.addr_in(ADDR), .x_pos(12'd563), .y_pos(12'd5 ), .w(12'd34), .addr_out(addr_p2hit1));
				address_offset offh22(.addr_in(ADDR), .x_pos(12'd563), .y_pos(12'd39), .w(12'd34), .addr_out(addr_p2hit2));
				address_offset offh23(.addr_in(ADDR), .x_pos(12'd563), .y_pos(12'd73), .w(12'd34), .addr_out(addr_p2hit3));
	
				
				assign hit[0]   = color_p1hit1; 
				assign hit[1]   = color_p1hit2; 
				assign hit[2]   = color_p1hit3;
				assign hit[3]   = color_p2hit1;
				assign hit[4]   = color_p2hit2;
				assign hit[5]   = color_p2hit3;
				assign hit[15:6]   = 10'b0;
				
				
				mux_16 hit_addr(.c(hit), 
					.in0(addr_p1hit1), 
					.in1(addr_p1hit2), 
					.in2(addr_p1hit3), 
					.in3(addr_p2hit1), 
					.in4(addr_p2hit2), 
					.in5(addr_p2hit3),
					.in6(1'b0), 
					.in7(1'b0), 
					.in8(1'b0), 
					.in9(1'b0), 
					.in10(1'b0), 
					.in11(1'b0), 
					.out(addr_hit));
				
				wire guitar_hit;
				mux_16 guitar_strummed(.c(hit), 
					.in0(guitar_in[0]), 
					.in1(guitar_in[1]), 
					.in2(guitar_in[2]), 
					.in3(guitar_in[3]), 
					.in4(guitar_in[4]), 
					.in5(guitar_in[5]),
					.in6(1'b0), 
					.in7(1'b0), 
					.in8(1'b0), 
					.in9(1'b0), 
					.in10(1'b0), 
					.in11(1'b0), 
					.out(guitar_hit));
					
					
				wire [18:0] addr_flame, addr_p1perf1, addr_p1perf2, addr_p1perf3, addr_p1perf4, addr_p1perf5, addr_p1perf6, addr_p1perf7, addr_p1perf8, 
												addr_p2perf1, addr_p2perf2, addr_p2perf3, addr_p2perf4, addr_p2perf5, addr_p2perf6, addr_p2perf7, addr_p2perf8;
				
				address_offset offp11(.addr_in(ADDR), .x_pos(p1note1_x-5), .y_pos(p1note1_y-5), .w(12'd39), .addr_out(addr_p1perf1));
				address_offset offp12(.addr_in(ADDR), .x_pos(p1note2_x-5), .y_pos(p1note2_y-5), .w(12'd39), .addr_out(addr_p1perf2));
				address_offset offp13(.addr_in(ADDR), .x_pos(p1note3_x-5), .y_pos(p1note3_y-5), .w(12'd39), .addr_out(addr_p1perf3));
				address_offset offp14(.addr_in(ADDR), .x_pos(p1note4_x-5), .y_pos(p1note4_y-5), .w(12'd39), .addr_out(addr_p1perf4));
				address_offset offp15(.addr_in(ADDR), .x_pos(p1note5_x-5), .y_pos(p1note5_y-5), .w(12'd39), .addr_out(addr_p1perf5));
				address_offset offp16(.addr_in(ADDR), .x_pos(p1note6_x-5), .y_pos(p1note6_y-5), .w(12'd39), .addr_out(addr_p1perf6));
				address_offset offp17(.addr_in(ADDR), .x_pos(p1note7_x-5), .y_pos(p1note7_y-5), .w(12'd39), .addr_out(addr_p1perf7));
				address_offset offp18(.addr_in(ADDR), .x_pos(p1note8_x-5), .y_pos(p1note8_y-5), .w(12'd39), .addr_out(addr_p1perf8));
				address_offset offp21(.addr_in(ADDR), .x_pos(p2note1_x-5), .y_pos(p2note1_y-5), .w(12'd39), .addr_out(addr_p2perf1));
				address_offset offp22(.addr_in(ADDR), .x_pos(p2note2_x-5), .y_pos(p2note2_y-5), .w(12'd39), .addr_out(addr_p2perf2));
				address_offset offp23(.addr_in(ADDR), .x_pos(p2note3_x-5), .y_pos(p2note3_y-5), .w(12'd39), .addr_out(addr_p2perf3));
				address_offset offp24(.addr_in(ADDR), .x_pos(p2note4_x-5), .y_pos(p2note4_y-5), .w(12'd39), .addr_out(addr_p2perf4));
				address_offset offp25(.addr_in(ADDR), .x_pos(p2note5_x-5), .y_pos(p2note5_y-5), .w(12'd39), .addr_out(addr_p2perf5));
				address_offset offp26(.addr_in(ADDR), .x_pos(p2note6_x-5), .y_pos(p2note6_y-5), .w(12'd39), .addr_out(addr_p2perf6));
				address_offset offp27(.addr_in(ADDR), .x_pos(p2note7_x-5), .y_pos(p2note7_y-5), .w(12'd39), .addr_out(addr_p2perf7));
				address_offset offp28(.addr_in(ADDR), .x_pos(p2note8_x-5), .y_pos(p2note8_y-5), .w(12'd39), .addr_out(addr_p2perf8));
				
				wire [15:0] flame;
				assign flame[0]   = color_p1perf1;//&& ) || ()); 
				assign flame[1]   = color_p1perf2;//&& ) || ()); 
				assign flame[2]   = color_p1perf3;//&& ) || ());
				assign flame[3]   = color_p1perf4;//&& ) || ());
				assign flame[4]   = color_p1perf5;//&& ) || ());
				assign flame[5]   = color_p1perf6;//&& ) || ());
				assign flame[6]   = color_p1perf7;//&& ) || ());
				assign flame[7]   = color_p1perf8;//&& ) || ());
				assign flame[8]   = color_p2perf1;//&& ) || ());
				assign flame[9]   = color_p2perf2;//&& ) || ());
				assign flame[10]  = color_p2perf3;//&& ) || ());
				assign flame[11]  = color_p2perf4;//&& ) || ());
				assign flame[12]  = color_p2perf5;//&& ) || ());
				assign flame[13]  = color_p2perf6;//&& ) || ());
				assign flame[14]  = color_p2perf7;//&& ) || ());
				assign flame[15]  = color_p2perf8;//&& ) || ());
				
				
				
				mux_16 flamez(.c(flame), 
					.in0( addr_p1perf1), 
					.in1( addr_p1perf2), 
					.in2( addr_p1perf3), 
					.in3( addr_p1perf4), 
					.in4( addr_p1perf5), 
					.in5( addr_p1perf6),
					.in6( addr_p1perf7), 
					.in7( addr_p1perf8), 
					.in8( addr_p2perf1), 
					.in9( addr_p2perf2), 
					.in10(addr_p2perf3), 
					.in11(addr_p2perf4),
					.in12(addr_p2perf5),
			      .in13(addr_p2perf6),
		         .in14(addr_p2perf7),
		         .in15(addr_p2perf8),
					.out(addr_flame));
					
				wire flame_exists;
				mux_16 existencesd(.c(flame), 
					.in0( notes1[20] || notes1[19] || notes1[18]), 
					.in1( notes1[4]  || notes1[3]  || notes1[2] ), 
					.in2( notes2[20] || notes2[19] || notes2[18]), 
					.in3( notes2[4]  || notes2[3]  || notes2[2] ), 
					.in4( notes3[20] || notes3[19] || notes3[18]), 
					.in5( notes3[4]  || notes3[3]  || notes3[2] ),
					.in6( notes4[20] || notes4[19] || notes4[18]), 
					.in7( notes4[4]  || notes4[3]  || notes4[2] ), 
					.in8( notes1[20] || notes1[19] || notes1[18]), 
					.in9( notes1[4]  || notes1[3]  || notes1[2] ), 
					.in10(notes2[20] || notes2[19] || notes2[18]), 
					.in11(notes2[4]  || notes2[3]  || notes2[2] ),
					.in12(notes3[20] || notes3[19] || notes3[18]),
			      .in13(notes3[4]  || notes3[3]  || notes3[2] ),
		         .in14(notes4[20] || notes4[19] || notes4[18]),
		         .in15(notes4[4]  || notes4[3]  || notes4[2] ),
					.out(flame_exists));
				
				wire flame_hit;
				mux_16 hitnesssd(.c(flame), 
					.in0( notes1[17]), 
					.in1( notes1[1] ), 
					.in2( notes2[17]), 
					.in3( notes2[1] ), 
					.in4( notes3[17]), 
					.in5( notes3[1] ),
					.in6( notes4[17]), 
					.in7( notes4[1] ), 
					.in8( notes1[16]), 
					.in9( notes1[0] ), 
					.in10(notes2[16]), 
					.in11(notes2[0] ),
					.in12(notes3[16]),
			      .in13(notes3[0] ),
		         .in14(notes4[16]),
		         .in15(notes4[0] ),
					.out(flame_hit));
					
				wire color_hit;
				assign color_hit = hit[0] || hit[1] || hit[2] || hit[3] || hit[4] || hit[5];
				
				
			 	
				// =======================================================================================================================
				// -----------------------------PUT THINGS ON THE SCREEN------------------------------------------------
				// =======================================================================================================================
				
				wire [7:0] paddle_ball, strings, strums, notes, states, lives;
				
			 	wire [7:0] post_paddle1_index, post_paddle2_index, post_ball_index, 
					str1, str2, str3, 
					p1r, p1g, p1y, p2r, p2g, p2y, 
					p1n1, p1n2, p1n3, p1n4, p1n5, p1n6, p2n1, p2n2, p2n3, p2n4, p2n5, p2n6,
					menu, game_over, sp, mp,
					p1l1, p1l2, p1l3, p2l1, p2l2, p2l3, p1p1, p2p1;
					
				// Paddle + Ball	
				//assign post_paddle1_index = color_pL ? 8'h000002 : background_index;
			 	//assign post_paddle2_index = color_pR ? 8'h000002 : post_paddle1_index;
				//assign post_ball_index = color_b ? 8'h000002 : post_paddle2_index;
				//assign paddle_ball = post_ball_index;
				
				//assign p1n1 = (color_p1note1 && (notes1[20] || notes1[19] || notes1[18]) && ~notes1[17])  ? p1note1_c : paddle_ball;
				//assign p1n2 = (color_p1note2 && (notes1[4]  || notes1[3]  || notes1[2] ) && ~notes1[1] )  ? p1note2_c : p1n1;
				//assign p1n3 = (color_p1note3 && (notes2[20] || notes2[19] || notes2[18]) && ~notes2[17])  ? p1note3_c : p1n2;
				//assign p1n4 = (color_p1note4 && (notes2[4]  || notes2[3]  || notes2[2] ) && ~notes2[1] )  ? p1note4_c : p1n3;
				//assign p1n5 = (color_p1note5 && (notes3[20] || notes3[19] || notes3[18]) && ~notes3[17])  ? p1note5_c : p1n4;
				//assign p1n6 = (color_p1note6 && (notes3[4]  || notes3[3]  || notes3[2] ) && ~notes3[1] )  ? p1note6_c : p1n5;
				//assign p2n1 = (color_p2note1 && (notes1[20] || notes1[19] || notes1[18]) && ~notes1[16])  ? p2note1_c : p1n6;
				//assign p2n2 = (color_p2note2 && (notes1[4]  || notes1[3]  || notes1[2] ) && ~notes1[0] )  ? p2note2_c : p2n1;
				//assign p2n3 = (color_p2note3 && (notes2[20] || notes2[19] || notes2[18]) && ~notes2[16])  ? p2note3_c : p2n2;
				//assign p2n4 = (color_p2note4 && (notes2[4]  || notes2[3]  || notes2[2] ) && ~notes2[0] )  ? p2note4_c : p2n3;
				//assign p2n5 = (color_p2note5 && (notes3[20] || notes3[19] || notes3[18]) && ~notes3[16])  ? p2note5_c : p2n4;
				//assign p2n6 = (color_p2note6 && (notes3[4]  || notes3[3]  || notes3[2] ) && ~notes3[0] )  ? p2note6_c : p2n5;
				//assign notes = p2n6;
				
				
				//assign p1r = (color_p1r && guitar_in[0]) ? 8'h000003 : notes;
				//assign p1g = (color_p1g && guitar_in[1]) ? 8'h000004 : p1r;
				//assign p1y = (color_p1y && guitar_in[2]) ? 8'h000005 : p1g;
				//assign p2r = (color_p2r && guitar_in[3]) ? 8'h000003 : p1y;
				//assign p2g = (color_p2g && guitar_in[4]) ? 8'h000004 : p2r;
				//assign p2y = (color_p2y && guitar_in[5]) ? 8'h000005 : p2g;
				//assign strums = p2y;
				
				//assign menu = (color_menu && (game_info[1:0] == 2'b00)) ? 8'h000005 : strums; //yellow
				//assign sp = (color_menu && (game_info[1:0] == 2'b01)) ? 8'h000003 : menu;  	//red
				//assign mp = (color_menu && (game_info[1:0] == 2'b10)) ? 8'h000006 : sp;			//black
				//assign game_over = (color_end && (game_info[1:0] == 2'b11)) ? 8'h000004 : mp;	//green
				//assign states = game_over;
				
				//assign p1l1 = (color_p1l1 && (player_info[9:5] > 5'd0)) ? 8'h000003 : background_index;
				//assign p1l2 = (color_p1l2 && (player_info[9:5] > 5'd1)) ? 8'h000003 : p1l1;
				//assign p1l3 = (color_p1l3 && (player_info[9:5] > 5'd2)) ? 8'h000003 : p1l2;
				//assign p2l1 = (color_p2l1 && (player_info[4:0] > 5'd0)) ? 8'h000003 : p1l3;
				//assign p2l2 = (color_p2l2 && (player_info[4:0] > 5'd1)) ? 8'h000003 : p2l1;
				//assign p2l3 = (color_p2l3 && (player_info[4:0] > 5'd2)) ? 8'h000003 : p2l2;
				
				assign p1p1 = (color_p1p1 && (player_info[31:21] > 11'd10)) ? 8'h000004 : background_index; //TOT gouttham... change powerup threshold here
				assign p2p1 = (color_p2p1 && (player_info[20:10] > 11'd10)) ? 8'h000004 : p1p1;
				
				
				assign color_index = p2p1;
				
				wire [2:0] colored_note;
				assign colored_note = (note_index == 3'b1) ? note_color[2:0] : note_index;
				//assign colored_note = note_color[2:0];
				
				
				
				

	// Handle ADDR Manipulation. 
		always@(posedge iVGA_CLK,negedge iRST_n)
		begin
		  if (!iRST_n)
		  begin
		     ADDR<=19'd0;
			  end
		  else if (cHS==1'b0 && cVS==1'b0)
		  begin
		     ADDR<=19'd0;
			  end
		  else if (cBLANK_n==1'b1)
		  begin
		     ADDR<=ADDR+1;
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
			.clock (~iVGA_CLK),
			.q (background_index)
			);
		
		img_index	img_index_inst (
			.address (color_index),
			.clock (iVGA_CLK),
			.q (bgr_data_raw)
			);
			
			
		string_data	string_d(
			.address (addr_str),
			.clock (~iVGA_CLK),
			.q (str_index)
			);
		
		string_index string_i(
			.address (str_index),
			.clock (iVGA_CLK),
			.q (string_img)
			);
			
		logo_data	logo_d(
			.address (addr_logo),
			.clock (~iVGA_CLK),
			.q (logo_index)
			);
		
		logo_index logo_i(
			.address (logo_index),
			.clock (iVGA_CLK),
			.q (logo_img)
			);
			
		paddle_data	paddle_d(
			.address (addr_paddle),
			.clock (~iVGA_CLK),
			.q (paddle_index)
			);
		
		paddle_index paddle_i(
			.address (paddle_index),
			.clock (iVGA_CLK),
			.q (paddle_img)
			);
			
		ball_data	ball_d(
			.address (addr_ball),
			.clock (~iVGA_CLK),
			.q (ball_index)
			);
		
		ball_index ball_i(
			.address (ball_index),
			.clock (iVGA_CLK),
			.q (ball_img)
			);
			
		yelnote_data	yel_d (
			.address (addr_note),
			.clock (~iVGA_CLK),
			.q (note_index)
			);
		
		yelnote_index	yel_i (
			.address (colored_note),
			.clock (iVGA_CLK),
			.q (note_img)
			);
			
		welcome_data	welcome_d(
			.address (addr_welcome),
			.clock (~iVGA_CLK),
			.q (welcome_index)
			);
		
		welcome_index welcome_i(
			.address (welcome_index),
			.clock (iVGA_CLK),
			.q (welcome_img)
			);
		
		over_data	over_d(
			.address (addr_over),
			.clock (~iVGA_CLK),
			.q (over_index)
			);
		
		over_index over_i(
			.address (over_index),
			.clock (iVGA_CLK),
			.q (over_img)
			);
			
		inst_data	inst_d(
			.address (addr_inst),
			.clock (~iVGA_CLK),
			.q (inst_index)
			);
		
		inst_index inst_i(
			.address (inst_index),
			.clock (iVGA_CLK),
			.q (inst_img)
			);
		
		one_data	one_d(
			.address (addr_one),
			.clock (~iVGA_CLK),
			.q (one_index)
			);
		
		one_index one_i(
			.address (one_index),
			.clock (iVGA_CLK),
			.q (one_img)
			);
			
		hit_data	hit_d(
			.address (addr_hit),
			.clock (~iVGA_CLK),
			.q (hit_index)
			);
		
		hit_index hit_i(
			.address (hit_index),
			.clock (iVGA_CLK),
			.q (hit_img)
			);
			
		flame_data	flame_d(
			.address (addr_flame),
			.clock (~iVGA_CLK),
			.q (flame_index)
			);
		
		flame_index flame_i(
			.address (flame_index),
			.clock (iVGA_CLK),
			.q (flame_img)
			);
		life_data	life_d(
			.address (addr_life),
			.clock (~iVGA_CLK),
			.q (life_index)
			);
		
		life_index life_i(
			.address (life_index),
			.clock (iVGA_CLK),
			.q (life_img)
			);

		// Latch valid color_index data at falling of the VGA clock.
		always@(posedge ~iVGA_CLK) begin
		//always@(ADDR) begin
			if (guitar_hit && (hit_img != 24'hff00ff))
				bgr_data <= hit_img;
			else if (in_note && note_exists && ~note_hit && (note_img != 24'hff00ff))
				bgr_data <= note_img;
			else if (color_flame && (flame_img != 24'hff00ff) && flame_exists && ~flame_hit && game_info[31:14] > 18'd2) // Gouttham
				bgr_data <= flame_img;
			else if (color_b && (ball_img != 24'hff00ff))
				bgr_data <= ball_img;
			else if ((color_pL || color_pR) && (paddle_img != 24'hff00ff))
				bgr_data <= paddle_img;
			else if (color_life)
				bgr_data <= life_img;
			else if (color_str)
				bgr_data <= string_img;
			else if (color_welcome && game_info[1:0] == 2'b00)
				bgr_data <= welcome_img;
			else if (color_inst && game_info[1:0] == 2'b00)
				bgr_data <= inst_img;
			else if (color_one && game_info[1:0] == 2'b11 && player_info[4:0] == 5'd0)
				bgr_data <= one_img;
			else if (color_over && game_info[1:0] == 2'b11)
				bgr_data <= over_img;
			else if (color_logo)
				bgr_data <= logo_img;
			else 
				bgr_data <= bgr_data_raw;
		end
		assign b_data = bgr_data[23:16];
		assign g_data = bgr_data[15:8];
		assign r_data = bgr_data[7:0]; 
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
	assign inboundsX = ((x_ADDR - obj_xpos) <= obj_width && (x_ADDR - obj_xpos) >= 12'd0);
	assign inboundsY = ((y_ADDR - obj_ypos) < obj_length && (y_ADDR - obj_ypos) >= 12'd0);

	assign color_obj = inboundsX & inboundsY;
endmodule

module address_offset(addr_in, x_pos, y_pos, w, addr_out);
	input [18:0] addr_in, x_pos, y_pos, w;
	output [18:0] addr_out;
	
	assign addr_out = (addr_in-(12'd640*y_pos+x_pos)) - (12'd640-w)*(addr_in/12'd640-y_pos);
endmodule


module calcCord(address, hor, ver);
	input [18:0] address;
	output [11:0] hor, ver;
	assign hor = address%12'd640;
	assign ver = address/12'd640;
endmodule