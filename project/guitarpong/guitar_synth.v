module guitar_synth(assert_note, N, fs, out, str);
	input assert_note;
	input [9:0] N;
	input [15:0] fs;
	output [31:0] out;
	
	output reg [49:0] str [31:0];
	
	integer i;
	always @(posedge assert_note)
	begin
		for(i=0; i<=10; i=i+1) begin
			str[i] <= i*32'd238609294;
		end
		for(i=49; i>=11; i=i-1) begin
			str[i] <= (49-i)*32'd55063683;
		end
	end
	
endmodule