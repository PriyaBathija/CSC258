module lut(in, code);
	input [2:0] in;
	output reg [15:0] code;
	always @(in)
	case(in)
		3'b000: code = 16'b1010101010100000;
		3'b001: code = 16'b1110000000000000;
		3'b010: code = 16'b1010101011100000;
		3'b011: code = 16'b1010101010101110;
		3'b100: code = 16'b1010111011100000;
		3'b101: code = 16'b1110101010101110;
		3'b110: code = 16'b1110101011101110;
		3'b111: code = 16'b1110111010101010;
	end case
endmodule


module disp(in, code, LEDR);
	input [2:0] in;
	input [15:0] code;

end module

module p1(clock, LEDR);
	input [1:0] LEDR;
	LEDR[0] = 1'b1;
	assign out = 1'b1;
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
				q <= (count - 1);
				bool <= 1'b0;
			end
		else if (enable == 1'b1)
		begin
			if (q == 28'b0000000000000000000000000000)
				begin
					q <= (count - 1);
					bool <= 1'b1;
				end
			else
				begin
					q <= q - 1'b1;
					bool <= 1'b0;
				end
		end
	end
endmodule
