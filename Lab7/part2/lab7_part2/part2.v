// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    wire [7:0] X;
    assign X[6:0] = SW[6:0];
    assign X[7] = 1'b0;
    wire [2:0] control;
    
    datapath d0(
    .clock(CLOCK_50),
    .resetn(resetn),
    .color(SW[9:7]),
    .x_pos(X[7:0]),
    .y_pos(SW[6:0]),
    .ld_x(control[2]),
    .ld_y(control[1]),
    .control_dye(control[0]),
    .x(x),
    .y(y),
    .clr(colour)
    );

    control c0(
    .clock(CLOCK_50),
    .resetn(resetn),
    .load(KEY[3]),
    .start(KEY[1]),
    .ld_x(control[2]),
    .ld_y(control[1]),
    .control_dye(control[0]),
    .writeEnable(writeEn)
    );
    
endmodule

module datapath(clock, resetn, color, x_pos, y_pos, x, y, clr, ld_x, ld_y, control_dye);
	input clock;
	input resetn;
	input [2:0] color;
	input [7:0] x_pos; 
	input [6:0] y_pos;
	input ld_x, ld_y, control_dye;
	reg [7:0] x_init;
	reg [6:0] y_init;
	output reg [7:0] x;
	output reg [6:0] y;
	output reg [2:0] clr;
	reg [4:0] position;
	reg [15:0] initializer = 16'b0;
	
	always @(posedge clock) begin
		if(!resetn) begin
			x_init <= 8'b0;
			y_init <= 7'b0;
			x <= 8'b0;
			y <= 7'b0;
			clr <= 3'b000;
			position <= 5'b0;
			if(initializer != 15'b100000000000000) begin
				x <= x_init + initializer[14:7];
				y <= y_init + initializer[6:0];
				clr <= 3'b000;
				initializer <= initializer + 1'b1;
			end
			else
				initializer <= initializer;
		end
		else begin
			initializer = 16'b0;
			if(ld_x)
				x_init <= x_pos;
			else if(ld_y)
				y_init <= y_pos;
			else if(control_dye) begin
				if(position != 5'b10000) begin
					x <= x_init + position[3:2];
					y <= y_init + position[1:0];
					clr <= color;
					position <= position + 1'b1;
				end
				else
					position <= position;
			end
			else begin
				x_init <= x_pos;
				y_init <= y_pos;
			end
		end
	end
endmodule   

module control(clock, resetn, load, start, writeEnable, ld_x, ld_y, control_dye);
	input clock;
	input resetn;
	input load;
	input start;
	output reg ld_x;
	output reg ld_y;
	output control_dye;
	output writeEnable;
	
	reg [2:0] current_state, next_state;
	
	localparam 	LOAD_X = 3'b000,
			LOAD_X_WAIT = 3'b001,
			LOAD_Y = 3'b010,
			START_DYE = 3'b011;
			
	assign control_dye = (current_state == START_DYE) ? 1'b1 : 1'b0;
	assign writeEnable = (current_state == START_DYE || !resetn) ? 1'b1 : 1'b0;
	always@(*)
	begin: state_table
		case (current_state)
			LOAD_X: next_state = load ? LOAD_X_WAIT : LOAD_X;
			LOAD_X_WAIT: next_state = load ? LOAD_X_WAIT : LOAD_Y;
			LOAD_Y: next_state = start ? LOAD_Y : START_DYE;
			START_DYE: next_state = start ? LOAD_X : START_DYE;
			default: next_state = LOAD_X;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		ld_x = 1'b0;
		ld_y = 1'b0;
		
		case(current_state)
			LOAD_X:
			begin 
				ld_x = 1'b1;
			end
			LOAD_Y: 
			begin
				ld_y = 1'b1;
			end
			START_DYE: 
			begin
//				control_dye = 1'b1;
				ld_y = 1'b0;
			end
		endcase
	end

	always @(posedge clock)
	begin: state_FFs
		if(resetn==0) 
		begin
			current_state <= LOAD_X;
//			control_dye <= 1'b0;
		end
		else
		begin
			current_state <= next_state;
		end
	end
endmodule
			
			
	
			
	
	
