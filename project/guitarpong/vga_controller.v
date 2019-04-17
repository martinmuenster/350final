module vga_controller(iRST_n, iVGA_CLK,oBLANK_n,oHS,oVS, b_data, g_data, r_data, 
						// Custom Additions. 
                      pR_moveup, pR_movedown, pL_moveup, pL_movedown, ball);
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
		wire [23:0] bgr_data_raw;	// 
		wire [7:0] color_index;			// Color
		wire cBLANK_n,cHS,cVS;
		input [31:0] ball;

	// Custom Code. Game Logic.
		input pR_moveup, pR_movedown, pL_moveup, pL_movedown; 

		// Initialize Objects (Top Left Pixel Position)
			// Left Paddle Properties.
				wire [11:0] pL_width, pL_height;

				reg [11:0] pL_xpos = 12'd100;
				reg [11:0] pL_ypos = 12'd100;
				assign pL_width = 12'd20;
				assign pL_height = 12'd100;
			// Right Paddle Properties.
				wire [11:0] pR_width, pR_height;

				reg [11:0] pR_xpos = 12'd500;
				reg [11:0] pR_ypos = 12'd100;
				assign pR_width = 12'd20;
				assign pR_height = 12'd100;
			// Ball Properties
				wire [11:0] b_width, b_height;

				wire [10:0] b_xpos = ball[31:21];
				wire [10:0] b_ypos = ball[20:10];
				assign b_width = 12'd20;
				assign b_height = 12'd20;
		// Game Logistics
			wire [11:0] paddle_vel, ball_vel;

			assign paddle_vel = 12'd10;
			assign ball_vel = 12'd3;

		// Change Position (Button Response)
			always@(posedge slowclock)
			begin
				// Right paddle next position.
					if (pR_moveup == 1'b0)
						begin
							pR_ypos = pR_ypos + paddle_vel;
						end
					if (pR_movedown == 1'b0)
						begin
							pR_ypos = pR_ypos - paddle_vel;
						end
				// Left paddle next position 
					if (pL_moveup == 1'b0)
						begin
							pL_ypos = pL_ypos + paddle_vel;
						end
					if (pL_movedown == 1'b0)
						begin
							pL_ypos = pL_ypos - paddle_vel;
						end
			end

			 wire [11:0] x_ADDR, y_ADDR;  // Address of the x and y pixel that is currently being edited.
			 calcCord trs(ADDR, x_ADDR, y_ADDR);
	 
			 wire inboundsx, inboundsy;
			 wire color_pL, color_pR, color_b;

			 	color_object color_paddleL(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(pL_xpos), .obj_ypos(pL_ypos), .obj_width(12'd20), .obj_length(12'd100), .color_obj(color_pL));
			 	color_object color_paddleR(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(pR_xpos), .obj_ypos(pR_ypos), .obj_width(12'd20), .obj_length(12'd100), .color_obj(color_pR));
			 	color_object color_ball(.x_ADDR(x_ADDR), .y_ADDR(y_ADDR), .obj_xpos(b_xpos), .obj_ypos(b_ypos), .obj_width(12'd20), .obj_length(12'd20), .color_obj(color_b));
			 	
			 	wire [7:0] post_paddle1_index, post_paddle2_index, post_ball_index;
				assign post_paddle1_index = color_pL ? 8'h000002 : background_index;
			 	assign post_paddle2_index = color_pR ? 8'h000002 : post_paddle1_index;
				assign post_ball_index = color_b ? 8'h000002 : post_paddle2_index;
				assign color_index = post_ball_index;

	// Handle ADDR Manipulation. 
		always@(posedge iVGA_CLK,negedge iRST_n)
		begin
		  if (!iRST_n)
		     ADDR<=19'd0;
		  else if (cHS==1'b0 && cVS==1'b0)
		     ADDR<=19'd0;
		  else if (cBLANK_n==1'b1)
		     ADDR<=ADDR+1;
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

		// Latch valid color_index data at falling of the VGA clock.
		always@(posedge ~iVGA_CLK) bgr_data <= bgr_data_raw;
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