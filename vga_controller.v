module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data, moveleft, moveright, moveup, movedown);

	
input iRST_n;
input iVGA_CLK;
input moveleft, moveright, moveup, movedown;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire [7:0] color;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));

////
////Addresss generator

reg [11:0] xpos = 12'd100;
reg [11:0] ypos = 12'd100;
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


always@(posedge slowclock)
begin
  
	if (moveleft == 1'b0)
	begin
		xpos = xpos - 12'd10;
	end
	if (moveright == 1'b0)
	begin
		xpos = xpos + 12'd10;
	end
	if (moveup == 1'b0)
	begin
		ypos = ypos + 12'd10;
	end
	if (movedown == 1'b0)
	begin
		ypos = ypos - 12'd10;
	end
end

 
 wire [11:0] xadd, yadd;
 wire inboundsx, inboundsy;
 calcCord trs(ADDR, xadd, yadd);
 assign inboundsx = ((xadd - xpos) < 12'd50 && (xadd - xpos) > 12'd0);
 assign inboundsy = ((yadd - ypos) < 12'd50 && (yadd - ypos) > 12'd0);
 assign color = (inboundsx && inboundsy) ? 8'h000002 : index;
 //assign color = 24'h0000FF;
  



always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
// 
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
img_index	img_index_inst (
	.address ( color ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw )
	);	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	

module calcCord(address, hor, ver);
	input [18:0] address;
	output [11:0] hor, ver;
	assign hor = address%640;
	assign ver = address/640;
endmodule













