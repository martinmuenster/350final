module less_than_check(in1, in2, res, out);

	input in1, in2, res;
	output out;
	
	wire c0, c1, c2;
	wire n_in1, n_in2;

	not(n_in1, in1);
	not(n_in2, in2);


	and case_0(c0, n_in1, n_in2, res);
	and case_1(c1, in1, n_in2);
	and case_2(c2, in1, in2, res);
	or (out, c0, c1, c2);
endmodule


module not_equal_check(in, out);
	input [31:0] in;
	output out;

	or(out, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31]);
endmodule

module twoscomp32(out, in);
	input [31:0] in;
	output [31:0] out;
	
	wire cout;
	cselect_adder_32 c1(~in, 32'b0, 1'b1, cout, out);
endmodule

// --------------------------------Bitwise Operations---------------------------------

module bit_and_32(out, in1, in2);
	input [31:0] in1, in2;
	output [31:0] out;
	and and0(out[0], in1[0], in2[0]);
	and and1(out[1], in1[1], in2[1]);
	and and2(out[2], in1[2], in2[2]);
	and and3(out[3], in1[3], in2[3]);
	and and4(out[4], in1[4], in2[4]);
	and and5(out[5], in1[5], in2[5]);
	and and6(out[6], in1[6], in2[6]);
	and and7(out[7], in1[7], in2[7]);
	and and8(out[8], in1[8], in2[8]);
	and and9(out[9], in1[9], in2[9]);
	and and10(out[10], in1[10], in2[10]);
	and and11(out[11], in1[11], in2[11]);
	and and12(out[12], in1[12], in2[12]);
	and and13(out[13], in1[13], in2[13]);
	and and14(out[14], in1[14], in2[14]);
	and and15(out[15], in1[15], in2[15]);
	and and16(out[16], in1[16], in2[16]);
	and and17(out[17], in1[17], in2[17]);
	and and18(out[18], in1[18], in2[18]);
	and and19(out[19], in1[19], in2[19]);
	and and20(out[20], in1[20], in2[20]);
	and and21(out[21], in1[21], in2[21]);
	and and22(out[22], in1[22], in2[22]);
	and and23(out[23], in1[23], in2[23]);
	and and24(out[24], in1[24], in2[24]);
	and and25(out[25], in1[25], in2[25]);
	and and26(out[26], in1[26], in2[26]);
	and and27(out[27], in1[27], in2[27]);
	and and28(out[28], in1[28], in2[28]);
	and and29(out[29], in1[29], in2[29]);
	and and30(out[30], in1[30], in2[30]);
	and and31(out[31], in1[31], in2[31]);
endmodule

module bit_not_32(in, out);

	input [31:0] in;
	output [31:0] out;
	
	not not0(out[0], in[0]);
	not not1(out[1], in[1]);
	not not2(out[2], in[2]);
	not not3(out[3], in[3]);
	not not4(out[4], in[4]);
	not not5(out[5], in[5]);
	not not6(out[6], in[6]);
	not not7(out[7], in[7]);
	not not8(out[8], in[8]);
	not not9(out[9], in[9]);
	not not10(out[10], in[10]);
	not not11(out[11], in[11]);
	not not12(out[12], in[12]);
	not not13(out[13], in[13]);
	not not14(out[14], in[14]);
	not not15(out[15], in[15]);
	not not16(out[16], in[16]);
	not not17(out[17], in[17]);
	not not18(out[18], in[18]);
	not not19(out[19], in[19]);
	not not20(out[20], in[20]);
	not not21(out[21], in[21]);
	not not22(out[22], in[22]);
	not not23(out[23], in[23]);
	not not24(out[24], in[24]);
	not not25(out[25], in[25]);
	not not26(out[26], in[26]);
	not not27(out[27], in[27]);
	not not28(out[28], in[28]);
	not not29(out[29], in[29]);
	not not30(out[30], in[30]);
	not not31(out[31], in[31]);
endmodule

module bit_or_32(in1, in2, out);

	input [31:0] in1, in2;
	output [31:0] out;
	
	or or0(out[0], in1[0], in2[0]);
	or or1(out[1], in1[1], in2[1]);
	or or2(out[2], in1[2], in2[2]);
	or or3(out[3], in1[3], in2[3]);
	or or4(out[4], in1[4], in2[4]);
	or or5(out[5], in1[5], in2[5]);
	or or6(out[6], in1[6], in2[6]);
	or or7(out[7], in1[7], in2[7]);
	or or8(out[8], in1[8], in2[8]);
	or or9(out[9], in1[9], in2[9]);
	or or10(out[10], in1[10], in2[10]);
	or or11(out[11], in1[11], in2[11]);
	or or12(out[12], in1[12], in2[12]);
	or or13(out[13], in1[13], in2[13]);
	or or14(out[14], in1[14], in2[14]);
	or or15(out[15], in1[15], in2[15]);
	or or16(out[16], in1[16], in2[16]);
	or or17(out[17], in1[17], in2[17]);
	or or18(out[18], in1[18], in2[18]);
	or or19(out[19], in1[19], in2[19]);
	or or20(out[20], in1[20], in2[20]);
	or or21(out[21], in1[21], in2[21]);
	or or22(out[22], in1[22], in2[22]);
	or or23(out[23], in1[23], in2[23]);
	or or24(out[24], in1[24], in2[24]);
	or or25(out[25], in1[25], in2[25]);
	or or26(out[26], in1[26], in2[26]);
	or or27(out[27], in1[27], in2[27]);
	or or28(out[28], in1[28], in2[28]);
	or or29(out[29], in1[29], in2[29]);
	or or30(out[30], in1[30], in2[30]);
	or or31(out[31], in1[31], in2[31]);
endmodule

// --------------------------------Registers---------------------------------

module reg_1(in, clk, clrn, enable, out);

	input in;
	input clk, clrn, enable;
	
	output out;
	
	dflipflop dff(in, clk, clrn, 1'b1, enable, out);  
endmodule

module reg_3(in, clk, clrn, enable, out);

	input [2:0] in;
	input clk, clrn, enable;
	
	output [2:0] out;
	
	reg_1 reg0(in[0], clk, clrn, enable, out[0]);
	reg_1 reg1(in[1], clk, clrn, enable, out[1]);
	reg_1 reg2(in[2], clk, clrn, enable, out[2]);
endmodule

module reg_32(in, clk, clrn, enable, out);

	input [31:0] in;
	input clk, clrn, enable;
	
	output [31:0] out;
	
	reg_1 reg0(in[0], clk, clrn, enable, out[0]);
	reg_1 reg1(in[1], clk, clrn, enable, out[1]);
	reg_1 reg2(in[2], clk, clrn, enable, out[2]);
	reg_1 reg3(in[3], clk, clrn, enable, out[3]);
	reg_1 reg4(in[4], clk, clrn, enable, out[4]);
	reg_1 reg5(in[5], clk, clrn, enable, out[5]);
	reg_1 reg6(in[6], clk, clrn, enable, out[6]);
	reg_1 reg7(in[7], clk, clrn, enable, out[7]);
	reg_1 reg8(in[8], clk, clrn, enable, out[8]);
	reg_1 reg9(in[9], clk, clrn, enable, out[9]);
	reg_1 reg10(in[10], clk, clrn, enable, out[10]);
	reg_1 reg11(in[11], clk, clrn, enable, out[11]);
	reg_1 reg12(in[12], clk, clrn, enable, out[12]);
	reg_1 reg13(in[13], clk, clrn, enable, out[13]);
	reg_1 reg14(in[14], clk, clrn, enable, out[14]);
	reg_1 reg15(in[15], clk, clrn, enable, out[15]);
	reg_1 reg16(in[16], clk, clrn, enable, out[16]);
	reg_1 reg17(in[17], clk, clrn, enable, out[17]);
	reg_1 reg18(in[18], clk, clrn, enable, out[18]);
	reg_1 reg19(in[19], clk, clrn, enable, out[19]);
	reg_1 reg20(in[20], clk, clrn, enable, out[20]);
	reg_1 reg21(in[21], clk, clrn, enable, out[21]);
	reg_1 reg22(in[22], clk, clrn, enable, out[22]);
	reg_1 reg23(in[23], clk, clrn, enable, out[23]);
	reg_1 reg24(in[24], clk, clrn, enable, out[24]);
	reg_1 reg25(in[25], clk, clrn, enable, out[25]);
	reg_1 reg26(in[26], clk, clrn, enable, out[26]);
	reg_1 reg27(in[27], clk, clrn, enable, out[27]);
	reg_1 reg28(in[28], clk, clrn, enable, out[28]);
	reg_1 reg29(in[29], clk, clrn, enable, out[29]);
	reg_1 reg30(in[30], clk, clrn, enable, out[30]);
	reg_1 reg31(in[31], clk, clrn, enable, out[31]);
endmodule

module reg_33(in, clk, clrn, enable, out);

	input [32:0] in;
	input clk, clrn, enable;
	
	output [32:0] out;
	
	reg_1 reg0(in[0], clk, clrn, enable, out[0]);
	reg_1 reg1(in[1], clk, clrn, enable, out[1]);
	reg_1 reg2(in[2], clk, clrn, enable, out[2]);
	reg_1 reg3(in[3], clk, clrn, enable, out[3]);
	reg_1 reg4(in[4], clk, clrn, enable, out[4]);
	reg_1 reg5(in[5], clk, clrn, enable, out[5]);
	reg_1 reg6(in[6], clk, clrn, enable, out[6]);
	reg_1 reg7(in[7], clk, clrn, enable, out[7]);
	reg_1 reg8(in[8], clk, clrn, enable, out[8]);
	reg_1 reg9(in[9], clk, clrn, enable, out[9]);
	reg_1 reg10(in[10], clk, clrn, enable, out[10]);
	reg_1 reg11(in[11], clk, clrn, enable, out[11]);
	reg_1 reg12(in[12], clk, clrn, enable, out[12]);
	reg_1 reg13(in[13], clk, clrn, enable, out[13]);
	reg_1 reg14(in[14], clk, clrn, enable, out[14]);
	reg_1 reg15(in[15], clk, clrn, enable, out[15]);
	reg_1 reg16(in[16], clk, clrn, enable, out[16]);
	reg_1 reg17(in[17], clk, clrn, enable, out[17]);
	reg_1 reg18(in[18], clk, clrn, enable, out[18]);
	reg_1 reg19(in[19], clk, clrn, enable, out[19]);
	reg_1 reg20(in[20], clk, clrn, enable, out[20]);
	reg_1 reg21(in[21], clk, clrn, enable, out[21]);
	reg_1 reg22(in[22], clk, clrn, enable, out[22]);
	reg_1 reg23(in[23], clk, clrn, enable, out[23]);
	reg_1 reg24(in[24], clk, clrn, enable, out[24]);
	reg_1 reg25(in[25], clk, clrn, enable, out[25]);
	reg_1 reg26(in[26], clk, clrn, enable, out[26]);
	reg_1 reg27(in[27], clk, clrn, enable, out[27]);
	reg_1 reg28(in[28], clk, clrn, enable, out[28]);
	reg_1 reg29(in[29], clk, clrn, enable, out[29]);
	reg_1 reg30(in[30], clk, clrn, enable, out[30]);
	reg_1 reg31(in[31], clk, clrn, enable, out[31]);
	reg_1 reg32(in[32], clk, clrn, enable, out[32]);
endmodule

module reg_34(in, clk, clrn, enable, out);

	input [33:0] in;
	input clk, clrn, enable;
	
	output [33:0] out;
	
	reg_1 reg0(in[0], clk, clrn, enable, out[0]);
	reg_1 reg1(in[1], clk, clrn, enable, out[1]);
	reg_1 reg2(in[2], clk, clrn, enable, out[2]);
	reg_1 reg3(in[3], clk, clrn, enable, out[3]);
	reg_1 reg4(in[4], clk, clrn, enable, out[4]);
	reg_1 reg5(in[5], clk, clrn, enable, out[5]);
	reg_1 reg6(in[6], clk, clrn, enable, out[6]);
	reg_1 reg7(in[7], clk, clrn, enable, out[7]);
	reg_1 reg8(in[8], clk, clrn, enable, out[8]);
	reg_1 reg9(in[9], clk, clrn, enable, out[9]);
	reg_1 reg10(in[10], clk, clrn, enable, out[10]);
	reg_1 reg11(in[11], clk, clrn, enable, out[11]);
	reg_1 reg12(in[12], clk, clrn, enable, out[12]);
	reg_1 reg13(in[13], clk, clrn, enable, out[13]);
	reg_1 reg14(in[14], clk, clrn, enable, out[14]);
	reg_1 reg15(in[15], clk, clrn, enable, out[15]);
	reg_1 reg16(in[16], clk, clrn, enable, out[16]);
	reg_1 reg17(in[17], clk, clrn, enable, out[17]);
	reg_1 reg18(in[18], clk, clrn, enable, out[18]);
	reg_1 reg19(in[19], clk, clrn, enable, out[19]);
	reg_1 reg20(in[20], clk, clrn, enable, out[20]);
	reg_1 reg21(in[21], clk, clrn, enable, out[21]);
	reg_1 reg22(in[22], clk, clrn, enable, out[22]);
	reg_1 reg23(in[23], clk, clrn, enable, out[23]);
	reg_1 reg24(in[24], clk, clrn, enable, out[24]);
	reg_1 reg25(in[25], clk, clrn, enable, out[25]);
	reg_1 reg26(in[26], clk, clrn, enable, out[26]);
	reg_1 reg27(in[27], clk, clrn, enable, out[27]);
	reg_1 reg28(in[28], clk, clrn, enable, out[28]);
	reg_1 reg29(in[29], clk, clrn, enable, out[29]);
	reg_1 reg30(in[30], clk, clrn, enable, out[30]);
	reg_1 reg31(in[31], clk, clrn, enable, out[31]);
	reg_1 reg32(in[32], clk, clrn, enable, out[32]);
	reg_1 reg33(in[33], clk, clrn, enable, out[33]);
endmodule

module reg_64(in, clk, clrn, enable, out);

	input [63:0] in;
	input clk, clrn, enable;
	
	output [63:0] out;
	
	reg_32 reg0_31(in[31:0], clk, clrn, enable, out[31:0]);
	reg_32 reg63_32(in[63:32], clk, clrn, enable, out[63:32]);
endmodule

// --------------------------------D Flip Flops---------------------------------

// Multdiv dffe
module dflipflop(d, clk, clrn, prn, ena, q);
    input d, clk, ena, clrn, prn;
    wire clr;

    output q;
    reg q;
	 
	 wire prn;

    assign clr = ~clrn;

    initial
    begin
        q = 1'b0;
    end

    always @(posedge clk) begin
        if (q == 1'bx) begin
            q <= 1'b0;
        end else if (clr) begin
            q <= 1'b0;
        end else if (ena) begin
            q <= d;
        end
    end
endmodule

// Regfile dffe
module dffe_ref(q, d, clk, en, clr);
   
   //Inputs
   input d, clk, en, clr;
   
   //Internal wire
   wire clr;

   //Output
   output q;
   
   //Register
   reg q;

   //Intialize q to 0
   initial
   begin
       q = 1'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 1'b0;
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
endmodule

// --------------------------------Tristate buffer---------------------------------

module tristate_buffer_32(in, out, ctrl);
	input [31:0] in;
	input ctrl;
	output [31:0] out;
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: loop
			assign out[i] = ctrl ? in[i] : 1'bz;
		end
	endgenerate
endmodule

// --------------------------------Decoder----------------------------------------

module decoder_2_4 (out, inp, enable);
	input enable;
	input [1:0] inp;
	output [3:0] out;
	wire not0, not1;


	not notb0(not0, inp[0]);
	not notb1(not1, inp[1]);
	and andD0(out[0], not0, not1, enable);
	and andD1(out[1], inp[0], not1, enable);
	and andD2(out[2], not0, inp[1], enable);
	and andD3(out[3], inp[0], inp[1], enable);
endmodule

module decoder_3_8 (out, in, enable);

	input enable;
	input [2:0] in;
	output [7:0] out;
	wire [3:0] enabler;



	decoder_2_4 enable_f(enabler, in[2], enable);
	decoder_2_4 lbits(out[3:0], in[1:0], enabler[0]);
	decoder_2_4 hbits(out[7:4], in[1:0], enabler[1]);
endmodule

module decoder_5_32(in, enable, out);

	input [4:0] in;
	input enable;
	
	output [31:0] out;
	wire input1, input2, input3, input4, input5;
	wire n_input1, n_input2, n_input3, n_input4, n_input5;
	assign input1 = in[0];
	assign input2 = in[1];
	assign input3 = in[2];
	assign input4 = in[3];
	assign input5 = in[4];
	
	assign n_input1 = ~in[0];
	assign n_input2 = ~in[1];
	assign n_input3 = ~in[2];
	assign n_input4 = ~in[3];
	assign n_input5 = ~in[4];
	
	and(out[0],n_input5,n_input4,n_input3, n_input2, n_input1);
	and(out[1],n_input5,n_input4,n_input3, n_input2, input1);
	and(out[2],n_input5,n_input4,n_input3, input2, n_input1);
	and(out[3],n_input5,n_input4,n_input3, input2, input1);
	and(out[4],n_input5,n_input4,input3, n_input2, n_input1);
	and(out[5],n_input5,n_input4,input3, n_input2, input1);
	and(out[6],n_input5,n_input4,input3, input2, n_input1);
	and(out[7],n_input5,n_input4,input3, input2, input1);
	and(out[8],n_input5,input4,n_input3, n_input2, n_input1);
	and(out[9],n_input5,input4,n_input3, n_input2, input1);
	and(out[10],n_input5,input4,n_input3, input2, n_input1);
	and(out[11],n_input5,input4,n_input3, input2, input1);
	and(out[12],n_input5,input4,input3, n_input2, n_input1);
	and(out[13],n_input5,input4,input3, n_input2, input1);
	and(out[14],n_input5,input4,input3, input2, n_input1);
	and(out[15],n_input5,input4,input3, input2, input1);
	and(out[16],input5,n_input4,n_input3, n_input2, n_input1);
	and(out[17],input5,n_input4,n_input3, n_input2, input1);
	and(out[18],input5,n_input4,n_input3, input2, n_input1);
	and(out[19],input5,n_input4,n_input3, input2, input1);
	and(out[20],input5,n_input4,input3, n_input2, n_input1);
	and(out[21],input5,n_input4,input3, n_input2, input1);
	and(out[22],input5,n_input4,input3, input2, n_input1);
	and(out[23],input5,n_input4,input3, input2, input1);
	and(out[24],input5,input4,n_input3, n_input2, n_input1);
	and(out[25],input5,input4,n_input3, n_input2, input1);
	and(out[26],input5,input4,n_input3, input2, n_input1);
	and(out[27],input5,input4,n_input3, input2, input1);
	and(out[28],input5,input4,input3, n_input2, n_input1);
	and(out[29],input5,input4,input3, n_input2, input1);
	and(out[30],input5,input4,input3, input2, n_input1);
	and(out[31],input5,input4,input3, input2, input1);
endmodule

// --------------------------------Adder Modules-----------------------------------
module half_adder(s, cout, in1, in2);


  input  in1, in2;
  output s, cout;

  xor xor1(s, in1, in2);
  and and1(cout, in1, in2);
endmodule

module full_adder(in1, in2, cin, cout, s);
	input in1, in2, cin;
	output cout, s;
	
	wire out_xor1, out_and1, out_and2;
	
	
	xor xor1(out_xor1, in1, in2);
	and and1(out_and1, in1, in2);
	xor xor2(s, out_xor1, cin);
	and and2(out_and2, out_xor1, cin);
	or or1(cout, out_and1, out_and2);
endmodule

module cselect_block(in1, in2, cin, cout, s);

	input [3:0] in1, in2;
	input cin;
	output [3:0] s;
	output cout;


	wire [3:0] s_rc4_1_0, s_rc4_1_1;
	wire cout_rc4_1_0, cout_rc4_1_1;

	ripple_carry_4 rc4_1_0(.in1(in1), .in2(in2), .cin(1'b0), .cout(cout_rc4_1_0), .s(s_rc4_1_0));
	ripple_carry_4 rc4_1_1(.in1(in1), .in2(in2), .cin(1'b1), .cout(cout_rc4_1_1), .s(s_rc4_1_1));

	assign s = cin ? s_rc4_1_1 : s_rc4_1_0;
	assign cout = cin ? cout_rc4_1_1 : cout_rc4_1_0;
endmodule

module carry_lookahead_adder_4(in1, in2, cin, cout, s);
	input cin;
	output cout;
	input [3:0] in1, in2;
	output [3:0] s;

	wire g0, g1, g2, g3;
	wire p0, p1, p2, p3;

	and andg0(g0, in1[0], in2[0]);
	and andg1(g1, in1[1], in2[1]);
	and andg2(g2, in1[2], in2[2]);
	and andg3(g3, in1[3], in2[3]);

	or orp0(p0, in1[0], in2[0]);
	or orp1(p1, in1[1], in2[1]);
	or orp2(p2, in1[2], in2[2]);
	or orp3(p3, in1[3], in2[3]);

	wire c1, c2, c3, c4, w_c1_0, w_c2_0, w_c2_1, w_c3_0, w_c3_1, w_c3_2;

	and and_c1_0(w_c1_0, p0, cin);
	or or_c1(c1, w_c1_0, g0);

	and and_c2_0(w_c2_0, cin, p0, p1);
	and and_c2_1(w_c2_1, g0, p1);
	or or_c2(c2, w_c2_0, w_c2_1, g1);

	and and_c3_0(w_c3_0, p2, g1);
	and and_c3_1(w_c3_1, p2, p1, g0);
	and and_c3_2(w_c3_2, p2, p1, p0, cin);
	or or_c3(c3, w_c3_0, w_c3_1, w_c3_2, g2);


	wire w_c4_0, w_c4_1, w_c4_2, w_c4_3;

	and and_c4_0(w_c4_0, p3, g2);
	and and_c4_1(w_c4_1, p3, p2, g1);
	and and_c4_2(w_c4_2, p3, p2, p1, g0);
	and and_c4_3(w_c4_3, p3, p2, p1, p0, cin);
	or or_c4(cout, w_c4_0, w_c4_1, w_c4_2, w_c4_3, g3);


	xor xor_s0(s[0], in1[0], in2[0], cin);
	xor xor_s1(s[1], in1[1], in2[1], c1);
	xor xor_s2(s[2], in1[2], in2[2], c2);
	xor xor_s3(s[3], in1[3], in2[3], c3);
endmodule

module ripple_carry_4(in1, in2, cin, cout, s);
	input cin;
	output cout;
	input [3:0] in1, in2;
	output [3:0] s;
	
	wire [2:0] cout_mid;
	
	full_adder fa0(.in1(in1[0]), .in2(in2[0]), .cin(cin), .cout(cout_mid[0]), .s(s[0]));
	full_adder fa1(.in1(in1[1]), .in2(in2[1]), .cin(cout_mid[0]), .cout(cout_mid[1]), .s(s[1]));
	full_adder fa2(.in1(in1[2]), .in2(in2[2]), .cin(cout_mid[1]), .cout(cout_mid[2]), .s(s[2]));
	full_adder fa3(.in1(in1[3]), .in2(in2[3]), .cin(cout_mid[2]), .cout(cout), .s(s[3]));
endmodule

module cselect_adder_32(in1, in2, cin, cout, s);
	input [31:0] in1, in2;
	output [31:0] s;
	input cin;
	output cout;
	
	wire [6:0] c_mid;
	
	cselect_block csb_0(.in1(in1[3:0]), .in2(in2[3:0]), .cin(cin), .cout(c_mid[0]), .s(s[3:0]));
	cselect_block csb_1(.in1(in1[7:4]), .in2(in2[7:4]), .cin(c_mid[0]), .cout(c_mid[1]), .s(s[7:4]));
	cselect_block csb_2(.in1(in1[11:8]), .in2(in2[11:8]), .cin(c_mid[1]), .cout(c_mid[2]), .s(s[11:8]));
	cselect_block csb_3(.in1(in1[15:12]), .in2(in2[15:12]), .cin(c_mid[2]), .cout(c_mid[3]), .s(s[15:12]));
	cselect_block csb_4(.in1(in1[19:16]), .in2(in2[19:16]), .cin(c_mid[3]), .cout(c_mid[4]), .s(s[19:16]));
	cselect_block csb_5(.in1(in1[23:20]), .in2(in2[23:20]), .cin(c_mid[4]), .cout(c_mid[5]), .s(s[23:20]));
	cselect_block csb_6(.in1(in1[27:24]), .in2(in2[27:24]), .cin(c_mid[5]), .cout(c_mid[6]), .s(s[27:24]));
	cselect_block csb_7(.in1(in1[31:28]), .in2(in2[31:28]), .cin(c_mid[6]), .cout(cout), .s(s[31:28]));
endmodule



// -------------------------------------Muxes---------------------------------------
module mux_2(select, in0, in1, out);
	input select;
	input [ 31 : 0 ] in0, in1;
	output [ 31 : 0 ] out;
	assign out = select ? in1 : in0;
endmodule

module mux_4(select, in0, in1, in2, in3, out);
	input [ 1 : 0 ] select;
	input [ 31 : 0 ] in0, in1, in2, in3;
	output [ 31 : 0 ] out;
	wire [ 31 : 0 ] w1, w2;
	mux_2 first_top(. select (select[0]), . in0 (in0), . in1 (in1), . out (w1));
	mux_2 first_bottom(. select (select[0]), . in0 (in2), . in1 (in3), . out (w2));
	mux_2 second(. select (select[1]), . in0 (w1), . in1 (w2), . out (out));
endmodule

module mux_16(select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, out);
	input [ 3 : 0 ] select;
	input [ 31 : 0 ] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
	output [ 31 : 0 ] out;
	wire [ 31 : 0 ] w1, w2, w3, w4;
	mux_4 first_first(. select (select[1:0]), . in0 (in0), . in1 (in1), . in2 (in2), . in3 (in3), . out (w1));
	mux_4 first_second(. select (select[1:0]), . in0 (in4), . in1 (in5), . in2 (in6), . in3 (in7),. out (w2));
	mux_4 first_third(. select (select[1:0]), . in0 (in8), . in1 (in9), . in2 (in10), . in3 (in11), . out (w3));
	mux_4 first_fourth(. select (select[1:0]), . in0 (in12), . in1 (in13), . in2 (in14), . in3 (in15),. out (w4));
	mux_4 second(. select (select[3:2]), . in0 (w1), . in1 (w2), . in2 (w3), . in3 (w4),  . out (out));
endmodule

module mux_32(select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, out);
	input [ 4 : 0 ] select;
	input [ 31 : 0 ] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31 ;
	output [ 31 : 0 ] out;
	wire [ 31 : 0 ] w1, w2;
	mux_16 first_top(. select (select[4:0]), . in0 (in0), . in1 (in1), . in2 (in2), . in3 (in3), . in4 (in4), . in5 (in5), . in6 (in6), . in7 (in7), . in8 (in8), . in9 (in9), . in10 (in10), . in11 (in11), . in12 (in12), . in13 (in13), . in14 (in14), . in15 (in15), . out (w1));
	mux_16 first_bottom(. select (select[4:0]), . in0 (in16), . in1 (in17), . in2 (in18), . in3 (in19), . in4 (in20), . in5 (in21), . in6 (in22), . in7 (in23), . in8 (in24), . in9 (in25), . in10 (in26), . in11 (in27), . in12 (in28), . in13 (in29), . in14 (in30), . in15 (in31), . out (w2));
	mux_2 second(. select (select[4]), .in0 (w1), .in1 (w2), .out(out));	
endmodule

// --------------------------Left Logical Shifter-----------------------------------
module l_shift_1(in, out);

	input [31:0] in;
	output [31:0] out;

	assign out[31:1] = in[30:0];
	assign out[0] = 1'b0;	
endmodule

module l_shift_2(in, out);
	input [31:0] in;
	output [31:0] out;

	assign out[31:2] = in[29:0];
	assign out[1:0] = 2'b0;
endmodule

module l_shift_4(in, out);
	input [31:0] in;
	output [31:0] out;

	assign out[31:4] = in[27:0];
	assign out[3:0] = 4'b0;
endmodule

module l_shift_8(in, out);

	input [31:0] in;
	output [31:0] out;

	assign out[31:8] = in[23:0];
	assign out[7:0] = 8'b0;	
endmodule

module l_shift_16(in, out);

	input [31:0] in;
	output [31:0] out;

	assign out[31:16] = in[15:0];
	assign out[15:0] = 16'b0;

	
endmodule

module l_shift_main(num, ctrl_shiftamt, out);
	input [31:0] num;
	input [4:0] ctrl_shiftamt;

	output [31:0] out;

	wire [31:0] post_s_16, post_s_8, post_s_4, post_s_2, post_s_1;
	wire [31:0] s_16, s_8, s_4, s_2, s_1;
	
	l_shift_16 ls0(.in(num), .out(s_16));
	assign post_s_16 = ctrl_shiftamt[4] ? s_16 : num;
	
	l_shift_8 ls1(.in(post_s_16), .out(s_8));
	assign post_s_8 = ctrl_shiftamt[3] ? s_8 : post_s_16;
	
	l_shift_4 ls2(.in(post_s_8), .out(s_4));
	assign post_s_4 = ctrl_shiftamt[2] ? s_4 : post_s_8;

	
	l_shift_2 ls3(.in(post_s_4), .out(s_2));
	assign post_s_2 = ctrl_shiftamt[1] ? s_2 : post_s_4;

	
	l_shift_1 ls4(.in(post_s_2), .out(s_1));
	assign out = ctrl_shiftamt[0] ? s_1 : post_s_2;
endmodule

// --------------------------Right Arithmetic Shifter-----------------------------------
module r_shift_1(in, out);
	input [31:0] in;
	output [31:0] out;

	assign out[30:0] = in[31:1];
	assign out[31] = in[31];
endmodule

module r_shift_2(in, out);
	input [31:0] in;
	output [31:0] out;

	assign out[29:0] = in[31:2];
	assign out[31] = in[31];
	assign out[30] = in[31];	
endmodule

module r_shift_4(in, out);

	input [31:0] in;
	output [31:0] out;

	assign out[27:0] = in[31:4];
	
	assign out[31] = in[31];
	assign out[30] = in[31];
	assign out[29] = in[31];
	assign out[28] = in[31];
endmodule

module r_shift_8(in, out);

	input [31:0] in;
	output [31:0] out;

	assign out[23:0] = in[31:8];
	assign out[31] = in[31];
	assign out[30] = in[31];
	assign out[29] = in[31];
	assign out[28] = in[31];
	assign out[27] = in[31];
	assign out[26] = in[31];
	assign out[25] = in[31];
	assign out[24] = in[31];
endmodule

module r_shift_16(in, out);

	input [31:0] in;
	output [31:0] out;

	assign out[15:0] = in[31:16];
	assign out[31] = in[31];
	assign out[30] = in[31];
	assign out[29] = in[31];
	assign out[28] = in[31];
	assign out[27] = in[31];
	assign out[26] = in[31];
	assign out[25] = in[31];
	assign out[24] = in[31];
	assign out[23] = in[31];
	assign out[22] = in[31];
	assign out[21] = in[31];
	assign out[20] = in[31];
	assign out[19] = in[31];
	assign out[18] = in[31];
	assign out[17] = in[31];
	assign out[16] = in[31];	
endmodule

module r_shift_main(num, ctrl_shiftamt, out);
	input [31:0] num;
	input [4:0] ctrl_shiftamt;

	output [31:0] out;

	wire [31:0] post_s_16, post_s_8, post_s_4, post_s_2, post_s_1;
	wire [31:0] s_16, s_8, s_4, s_2, s_1;
	
	r_shift_16 rs0(.in(num), .out(s_16));
	assign post_s_16 = ctrl_shiftamt[4] ? s_16 : num;
	
	r_shift_8 rs1(.in(post_s_16), .out(s_8));
	assign post_s_8 = ctrl_shiftamt[3] ? s_8 : post_s_16;
	
	r_shift_4 rs2(.in(post_s_8), .out(s_4));
	assign post_s_4 = ctrl_shiftamt[2] ? s_4 : post_s_8;

	
	r_shift_2 rs3(.in(post_s_4), .out(s_2));
	assign post_s_2 = ctrl_shiftamt[1] ? s_2 : post_s_4;

	
	r_shift_1 rs4(.in(post_s_2), .out(s_1));
	assign out = ctrl_shiftamt[0] ? s_1 : post_s_2;
endmodule