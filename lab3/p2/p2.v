//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module fulladder(LEDR, SW);
	input [9:0] SW;
	output [4:0] LEDR;
	wire w1, w2, w3;
	halfadder h1(
		.inp0(SW[0]),
		.inp1(SW[4]),
		.cin(SW[9]),
		.cout(w1),
		.lout(LEDR[0])
	);
	
	halfadder h2(
		.inp0(SW[1]),
		.inp1(SW[5]),
		.cin(w1),
		.cout(w2),
		.lout(LEDR[1])
	);
	
	halfadder h3(
		.inp0(SW[2]),
		.inp1(SW[6]),
		.cin(w2),
		.cout(w3),
		.lout(LEDR[2])
	);
	
	halfadder h4(
		.inp0(SW[3]),
		.inp1(SW[7]),
		.cin(w3),
		.cout(LEDR[4]),
		.lout(LEDR[3])
	);


endmodule


module halfadder(inp0, inp1, cin, cout, lout);
	input inp0, inp1, cin;
	output cout, lout;
	assign lout = ((inp0 ^ inp1) ^ cin);
	assign cout = ((inp0 ^ inp1) & cin) | (~(inp0 ^ inp1) & inp1);
endmodule
