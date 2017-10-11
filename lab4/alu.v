module alu(SW, KEY, HEX0, HEX1,HEX2, HEX3, HEX4, HEX5, LEDR);
	input [9:5] SW;
	input [2:0] KEY;
	input [6:0] HEX0;
	input [6:0] HEX4;
	input [6:0] HEX5;
	output [7:0] LEDR;
	wire [7:0] out;
	wire clock;
	wire reset_n;
	
	assign clock = KEY[0];
	assign reset_n = SW[9];
	
	reg [7:0] out;
	wire [7:0] wire5;
	regi r0(
		.d(out[7:0]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.q(wire5)
	);
	
	alum a1(SW[3:0], out[3:0], SW[7:5], out[7:0]);
	
	
	assign LEDR[7:0] = wire5[7:0];
	
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
	
	sevenseg s4(
		.a(wire5[3]),
		.b(wire5[2]),
		.c(wire5[1]),
		.d(wire5[0]),
		.s0(HEX4[0]),
		.s1(HEX4[1]),
		.s2(HEX4[2]),
		.s3(HEX4[3]),
		.s4(HEX4[4]),
		.s5(HEX4[5]),
		.s6(HEX4[6])
	);
	
	sevenseg s5(
		.a(wire5[7]),
		.b(wire5[6]),
		.c(wire5[5]),
		.d(wire5[4]),
		.s0(HEX5[0]),
		.s1(HEX5[1]),
		.s2(HEX5[2]),
		.s3(HEX5[3]),
		.s4(HEX5[4]),
		.s5(HEX5[5]),
		.s6(HEX5[6])
	);
	
	
	
endmodule

module regi(d, clk, reset_n, q);
	input [7:0] d;
	input clk, reset_n;
	output [7:0] q;	
	reg [7:0] q;
	
	always @(posedge clk)
	begin
		if (reset_n == 1'b0)
			q <= 8'b00000000;
		else
			q <= d;
	end
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
	wire [3:0] w1;
	wire [3:0] w2;
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
			3'b000: out = {4'b000, w1}; 
			3'b001: out = {4'b000, w2};
			3'b010: out = a + b; 
			3'b011:	out = {a | b, a ^ b};
			3'b100: out = a | b;			
			3'b101: out = b << a;
			3'b110: out = b >> a;
			3'b111: out = a * b;
			default : out = 8'b00000000;
		endcase
	end
endmodule

	
	