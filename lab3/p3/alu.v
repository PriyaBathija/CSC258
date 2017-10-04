module alu(SW, KEY, HEX0, HEX1,HEX2, HEX3, HEX4, HEX5, LEDR);
	input [7:0] SW;
	input [2:0] KEY;
	input [7:0] HEX0;
	input [7:0] HEX1;
	input [7:0] HEX2;
	input [7:0] HEX3;
	input [7:0] HEX4;
	input [7:0] HEX5;
	output [7:0] LEDR;
	wire [7:0] wire5;
	
	sevenseg s0(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.s0(HEX0[0]),
		.s1(HEX0[1]),
		.s2(HEX0[2]),
		.s3(HEX0[3]),
		.s4(HEX0[4]),
		.s5(HEX0[5]),
		.s6(HEX0[6])
	);
	
	sevenseg s1(
		.a(1'b0),
		.b(1'b0),
		.c(1'b0),
		.d(1'b0),
		.s0(HEX1[0]),
		.s1(HEX1[1]),
		.s2(HEX1[2]),
		.s3(HEX1[3]),
		.s4(HEX1[4]),
		.s5(HEX1[5]),
		.s6(HEX1[6])
	);
	
	sevenseg s2(
		.a(SW[4]),
		.b(SW[5]),
		.c(SW[6]),
		.d(SW[7]),
		.s0(HEX2[0]),
		.s1(HEX2[1]),
		.s2(HEX2[2]),
		.s3(HEX2[3]),
		.s4(HEX2[4]),
		.s5(HEX2[5]),
		.s6(HEX2[6])
	);
	
	sevenseg s3(
		.a(1'b0),
		.b(1'b0),
		.c(1'b0),
		.d(1'b0),
		.s0(HEX3[0]),
		.s1(HEX3[1]),
		.s2(HEX3[2]),
		.s3(HEX3[3]),
		.s4(HEX3[4]),
		.s5(HEX3[5]),
		.s6(HEX3[6])
	);
	
	sevenseg s4(
		.a(wire5[0]),
		.b(wire5[1]),
		.c(wire5[2]),
		.d(wire5[3]),
		.s0(HEX4[0]),
		.s1(HEX4[1]),
		.s2(HEX4[2]),
		.s3(HEX4[3]),
		.s4(HEX4[4]),
		.s5(HEX4[5]),
		.s6(HEX4[6])
	);
	
	sevenseg s5(
		.a(wire5[4]),
		.b(wire5[5]),
		.c(wire5[6]),
		.d(wire5[7]),
		.s0(HEX5[0]),
		.s1(HEX5[1]),
		.s2(HEX5[2]),
		.s3(HEX5[3]),
		.s4(HEX5[4]),
		.s5(HEX5[5]),
		.s6(HEX5[6])
	);
	
	alum a1(SW[3:0], SW[7:4], KEY[2:0], wire5[7:0]);
	assign LEDR[7:0] = wire5[7:0];
	
endmodule

module fulladder(inp0, inp1, out);
	input [3:0] inp0;
	input [3:0] inp1;
	output [7:0] out;
	wire w1, w2, w3;
	halfadder h1(
		.inp0(inp0[0]),
		.inp1(inp1[0]),
		.cin(0'b0),
		.cout(w1),
		.lout(out[0])
	);
	
	halfadder h2(
		.inp0(inp0[1]),
		.inp1(inp1[1]),
		.cin(w1),
		.cout(w2),
		.lout(out[1])
	);
	
	halfadder h3(
		.inp0(inp0[2]),
		.inp1(inp1[2]),
		.cin(w2),
		.cout(w3),
		.lout(out[2])
	);
	
	halfadder h4(
		.inp0(inp0[3]),
		.inp1(inp1[3]),
		.cin(w3),
		.cout(out[4]),
		.lout(out[3])
	);


endmodule


module halfadder(inp0, inp1, cin, cout, lout);
	input inp0, inp1, cin;
	output cout, lout;
	assign lout = 	((inp0 ^ inp1) ^ cin);
	assign cout = ((inp0 ^ inp1) & cin) | (~(inp0 ^ inp1) & inp1);
endmodule



module sevenseg(a, b, c, d, s0, s1, s2, s3, s4, s5, s6);
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

module alum(a, b, c, out);
	output reg [7:0] out;
	input [3:0] a;
	input [3:0] b;
	input [2:0] c;
	wire [7:0] w1;
	wire [7:0] w2;
	fulladder f0(
		.inp0(a),
		.inp1(4'b0001),
		.out(w1)
	);
	fulladder f1(
		.inp0(a),
		.inp1(b),
		.out(w2)
	);
	
	always @(*)
	begin
		case(c[2:0]) 
			3'b000: out = w1; 
			3'b001: out = w2;
			3'b010: out = a + b; 
			3'b011:	out = {a | b, a ^ b};
			3'b101: out = a | b;
			3'b100: out = {a, b};	
			default : out = 7'b0000000;
		endcase
	end
endmodule

	
	