module main(SW, HEX0, CLOCK_50);
	input [3:0] SW;
	output [6:0] HEX0;
	wire [3:0] o;
	input CLOCK_50;
	wire [27:0] temp;
	
	
	ratecounter r0(
		.inp0(SW[0]),
		.inp1(SW[1]),
		.clock(CLOCK_50),
		.reset_n(SW[2]),
		.enable(SW[3]),
		.o(o)
	);
	
	sevensegx s0(
		.a(o[0]),
		.b(o[1]),
		.c(o[2]),
		.d(o[3]),
		.s0(HEX0[0]),
		.s1(HEX0[1]),
		.s2(HEX0[2]),
		.s3(HEX0[3]),
		.s4(HEX0[4]),
		.s5(HEX0[5]),
		.s6(HEX0[6])
	);
	
	
endmodule

module ratecounter(inp0, inp1, clock, reset_n, enable, o);
	input inp0, inp1, clock, reset_n, enable;
	wire [27:0] w0;
	wire w1;
	output [3:0] o;
	wire [27:0] q;
	wire bool;
	rate r1(
		.a(inp1),
		.b(inp0),
		.c(w0)
	);

	counter c1(
		.clock(clock),
		.reset_n(reset_n),
		.enable(1'b1),
		.count(w0),
		.q(q),
		.bool(bool)
	);
	
	countup c0(
		.enable(enable),
		.reset_n(reset_n),
		.clock(bool),
		.o(o)
	);

endmodule

module rate(a, b, c);
	input a;
	input b;
	output reg [27:0] c;
	
	always @(*)
	begin
		if(a == 1'b0 && b == 1'b0)
			assign c = 1'b1;
		else if(a == 1'b0 && b == 1'b1)
			assign c = 28'd10;
		else if(a == 1'b1 && b == 1'b0)
			assign c = 28'd100000000;
		else if(a == 1'b1 && b == 1'b1)
			assign c = 28'd200000000;
	end
		
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

module countup(enable, reset_n, clock, o);
	input enable, reset_n, clock;
	output reg [3:0] o;
	always @(posedge clock, negedge reset_n)
	begin
		if(reset_n == 0)
			o <= 0;
		else if(enable == 1)
			o <= o + 1'b1;
	end

endmodule


module counter(clock, reset_n, enable, count, q, bool);
	input clock;
	input reset_n, count;
	wire [27:0] count;
	input enable;
	output q;
	reg [27:0] q;
	output reg bool;


	always @(posedge clock, negedge reset_n)
	begin
		if(reset_n == 1'b0)
			begin
				q <= 28'b0000000000000000000000000000;
				bool <= 1'b0;
			end
		else if (enable == 1'b1)
		begin
			if (q == (count - 1))
				begin
					q <= 28'b0000000000000000000000000000;
					bool <= 1'b1;
				end
			else
				begin
					q <= q + 1'b1;
					bool <= 1'b0;
				end
		end
	end
endmodule