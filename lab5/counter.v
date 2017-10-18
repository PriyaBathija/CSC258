module main(SW, KEY, HEX0, HEX1);
	input [1:0] SW;
	input [1:0] KEY;
	output [6:0] HEX0;
	output [6:0] HEX1;
	wire [7:0] wout;

	counter c1(
		.enable(SW[1]),
		.reset(SW[0]),
		.clock(KEY[0]),
		.q(wout)
	);
	
	sevensegx s0(
		.a(wout[3]),
		.b(wout[2]),
		.c(wout[1]),
		.d(wout[0]),
		.s0(HEX0[0]),
		.s1(HEX0[1]),
		.s2(HEX0[2]),
		.s3(HEX0[3]),
		.s4(HEX0[4]),
		.s5(HEX0[5]),
		.s6(HEX0[6])
	);
	
	sevensegx s1(
		.a(wout[7]),
		.b(wout[6]),
		.c(wout[5]),
		.d(wout[4]),
		.s0(HEX1[0]),
		.s1(HEX1[1]),
		.s2(HEX1[2]),
		.s3(HEX1[3]),
		.s4(HEX1[4]),
		.s5(HEX1[5]),
		.s6(HEX1[6])
	);
	
endmodule

module sevensegx(a, b, c, d, s0, s1, s2, s3, s4, s5, s6);
	input a, b, c, d;
	output s0, s1, s2, s3, s4, s5, s6;
	
	assign s0 = ~a & b & ~c & ~d | ~a & ~b & ~c & d | a & b & ~c & d | a & ~b & c & d;
	assign s1 = a & b & ~d | a & c & d | ~a & b & ~c & d | b & c & ~d;
	assign s2 = ~a & ~b & & c & ~d | a & b & ~d | a & b & c;
	assign s3 = ~b & ~c & d | ~a & b & ~c & ~d | b & c & d |  a & ~b & c & ~d;
	assign s4 = ~a & d | ~a & b & ~c | ~b & ~c & d;
	assign s5 = ~a & ~b & d | ~a & c & d | ~a & ~b & c | a & b & ~c & d;
	assign s6 = a & b & ~c & ~d | ~a & ~b & ~c | ~a & b & c & d;

endmodule


module counter(enable, reset, clock, q);
	input enable, reset, clock;
	output 	[7:0] q;
	wire w0, w1, w2, w3, w4, w5, w6, w7;
	wire a1, a2, a3, a4, a5, a6, a7;

	atff q0(
		.data(enable),
		.clk(clock),
		.reset(reset),
		.q(w0)
	);

	assign a1 = w0 & enable;
	
	atff q1(
		.data(a1),
		.clk(clock),
		.reset(reset),
		.q(w1)
	);

	assign a2 = w0 & w1 & enable;	
	
	atff q2(
		.data(a2),
		.clk(clock),
		.reset(reset),
		.q(w2)
	);

	assign a3 = w0 & w1 & w2 & enable;	
	
	atff q3(
		.data(a3),
		.clk(clock),
		.reset(reset),
		.q(w3)
	);

	assign a4 = w0 & w1 & w2 & w3 & enable;	
	
	atff q4(
		.data(a4),
		.clk(clock),
		.reset(reset),
		.q(w4)
	);
	assign a5 = w0 & w1 & w2 & w3 & w4 & enable;	

	atff t5(
		.data(a5),
		.clk(clock),
		.reset(reset),
		.q(w5)
	);

	assign a6 = w0 & w1 & w2 & w3 & w4 & w5 & enable;	

	atff q6(
		.data(a6),
		.clk(clock),
		.reset(reset),
		.q(w6)
	);

	assign a7 = w0 & w1 & w2 & w3 & w4 & w5 & w6 & enable;	
	
	atff q7(
		.data(a7),
		.clk(clock),
		.reset(reset),
		.q(w7)
	);
	
	assign q = {w7, w6, w5, w4, w3, w2, w1, w0};

endmodule

module atff(data, clk, reset, q);
	input data, clk, reset; 
	output q;
	reg q;

	always @ (posedge clk, negedge reset)
	if (~reset) begin
	  q <= 1'b0;
	end else if (data) begin
	  q <= q ^ data;
	end

endmodule //End Of Module tff_async_reset