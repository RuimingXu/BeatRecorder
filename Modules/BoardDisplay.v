module show_key (ascii_val, note, symbol);
	input [6:0] ascii_val;
	output reg [7:0] symbol;
	output reg [7:0] note;

	// drawing key based on the key that was clicked
	always @(*)
	begin: display_notes
		// default case -> don't display anything
		note = 7'b1111111;
		symbol = 7'b1111111;
		// @ROBERT -- YOU CAN EDIT THESE DISPLAYS BASED ON WHAT YOU THINK THE NOTES SHOULD BE
		case(ascii_val)
			7'd65: begin // This note is: C
				   note = 7'b1000110;
				   end
			7'd87: begin // This note is: C sharp
				   note = 7'b1000110;
				   symbol = 7'b0011100;
				   end
			7'd83: begin // This note is: D
				   note = 7'b1000000;
				   end
			7'd69: begin // This note is: D sharp
				   note = 7'b1000000;
				   symbol = 7'b0011100;
				   end
			7'd68: begin // This note is: E
				   note = 7'b0000110;
				   end
			7'd70: begin // This note is: F
				   note = 7'b0001110;
				   end
			7'd84: begin // This note is: F sharp
				   note = 7'b0001110;
				   symbol = 7'b0011100;
				   end
			7'd72: begin // This note is: A
				   note = 7'b0001000;
				   end
			7'd85: begin // This note is: A sharp
				   note = 7'b0001000;
				   symbol = 7'b0011100;
				   end
			7'd74: begin // This note is: B
				   note = 7'b0000000;
				   end
			7'd71: begin // This note is: G
				   note = 7'b0000010;
				   end
			7'd89: begin // This note is G sharp
				   note = 7'b0000010;
				   symbol = 7'b0011100;
				   end
		endcase

	end	
endmodule