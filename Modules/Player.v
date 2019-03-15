module	play_music(ascii, buzzer, is_record);
	input [6:0] ascii; // ASCII key value that relates to a specific sound
	input is_record;
	output [7:0] buzzer; // audio buzzer
	//input is_record; // one bit value to tell whether to store the sound pattern (recording) or not.
					 // Using this module to play main buzzer and recording buzzers -> (for recording buzzers, should be 1, for main 0)
	
	// Case statement needed: 19 possible sounds... Different frequency rate for each
	// @ Moe: I change the way piano keys are assigned to the keyboard keys. We could add more keys later.
	//        For now the keys assignments looks like the diagram drawn in the rate_divider module

	
	// Recording section goes here. DO NOT DO -> We need to call FSM module and store in registers. Will do next week.
	// @ Moe: not quite sure in which form are sounds stored here. Probably in form of "frequency + duration"?
	
endmodule


module rate_divider(clk, ascii, speaker, freq_out);
	input [6:0] ascii;
	input clk;
	
	output reg speaker;
	output reg [18:0] freq_out;
	
	reg [18:0] clkdivider; // ***** This was [31:0] in reference code. Does not see the point of doing that *****

	reg [31:0] counter;
	reg checkOn = 1'b1;
	
	
	
    always @(posedge clk)
    begin
	 
	 
	 	if (checkOn == 1'b1)
		begin
			case (ascii[6:0])
				7'd87: clkdivider <= 50000000/1108; // C# Letter W
				7'd69: clkdivider <= 50000000/1244; // D# Letter E
				7'd84: clkdivider <= 50000000/1478; // F# Letter T
				7'd89: clkdivider <= 50000000/1660; // G# Letter Y
				7'd85: clkdivider <= 50000000/932;  // A# Letter U ******** This is the lower A# provided by the current frequency
				7'd65: clkdivider <= 50000000/1046; // C  Letter A      piano:     | C#| D#| / | F#| G#| A#| / |
				7'd83: clkdivider <= 50000000/1147; // D  Letter S               | C | D | E | F | G | A | B |
				7'd68: clkdivider <= 50000000/1318; // E  Letter D
				7'd70: clkdivider <= 50000000/1396; // F  Letter F      keyboard:  | W | E | / | T | Y | U | / |
				7'd71: clkdivider <= 50000000/1566; // G  Letter G               | A | S | D | F | G | H | J |
				7'd72: clkdivider <= 50000000/880;  // A  Letter H ******** This is the lower A provided by the current frequency
				7'd74: clkdivider <= 50000000/986;  // B  Letter J ******** This is the lower B provided by the current frequency
				default: clkdivider <= 25000000;   // center C for default
			endcase
			checkOn <= 1'b0;
		end
	 
		if(counter==0)
		begin
			counter <= clkdivider-1;
			checkOn <= 1'b1;
		end
		else begin
			counter <= counter-1;
		end
        freq_out <= counter[18:0];
    end

    always @(posedge clk) if(counter==0) speaker <= ~speaker;
	

endmodule
