module sevenseg(HEX, SW);
	input [3:0] SW;
	output [6:0] HEX;
	
	sevensegx u1(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.s0(HEX[0]),
		.s1(HEX[1]),
		.s2(HEX[2]),
		.s3(HEX[3]),
		.s4(HEX[4]),
		.s5(HEX[5]),
		.s6(HEX[6])
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