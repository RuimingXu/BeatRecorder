module rate_divider(clk, ascii, speaker, freq_out);
	input [6:0] ascii;
	input clk;
	
	output reg [2:0] speaker = 1'b1;
	output reg [9:0] freq_out;
	
	reg [31:0] clkdivider; // ***** This was [31:0] in reference code. Does not see the point of doing that *****

	reg [31:0] counter = 32'b1;
	
    always @(posedge clk)
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
				7'd72: clkdivider <= 50000000/1730;  //  A  Letter H ******** This is the lower A provided by the current frequency
				7'd74: clkdivider <= 50000000/1960;  // B  Letter J ******** This is the lower B provided by the current frequency
				7'd75: clkdivider <= 50000000/2080; // 
				default: clkdivider <= 200000000;   // center C for default
			endcase
		end


    always @(posedge clk)
    begin
        if(counter==0) counter <= clkdivider-1; else counter <= counter-1;
        freq_out <= clkdivider[9:0];
    end

    always @(posedge clk)
	 begin
		if (counter==0)
		begin
			speaker <= ~speaker;
		end
	 end

endmodule




module rate_divider_for_load(is_loading, clk, ascii, speaker); // this module is for saved buzzers. Just has freq_out removed
	input is_loading;
	input [6:0] ascii;
	input clk;
	
	output reg [2:0]  speaker = 1'b1;
	
	reg [31:0] clkdivider; // ***** This was [31:0] in reference code. Does not see the point of doing that *****

	reg [31:0] counter = 32'b1;
	
    always @(posedge clk)
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
				default: clkdivider <= 200000000;   // center C for default
			endcase
		end


    always @(posedge clk)
    begin
        if(counter==0) counter <= clkdivider-1; else counter <= counter-1;
    end

    always @(posedge clk)
	 begin
		if (is_loading == 0)
		begin
			speaker <= 1'b0; // Play nothing when is_loading is off
		end
		else if (counter == 0)
		begin
			speaker <= ~speaker; // Flip speaker signal every time the counter counts down to 0
		end
	 end

endmodule
