module z_branch_predictor(branch_taken, take_branch, branch_op);

   input branch_taken, branch_op;
	output take_branch;
	
	wire q1, q0, d1, d0;
	assign take_branch = q1;
	
	z_dflipflop dffe1(.d(d1), .q(q1), .clk(~branch_op), .ena(1'b1), .clrn(1'b1), .prn(1'b1));
	z_dflipflop dffe0(.d(d0), .q(q0), .clk(~branch_op), .ena(1'b1), .clrn(1'b1), .prn(1'b1));

	assign d1 = (q1 && q0) || (q0 && branch_taken) || (q1 && branch_taken);
	assign d0 = (q1 && ~q0) || (q1 && branch_taken) || (~q0 && branch_taken);
   
endmodule