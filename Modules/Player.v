module ChooseMusic (freq_out, ascii, clk, speaker, saved1, saved2, toggle, record);
	input [6:0] ascii;
	input clk;
	output reg speaker; // main buzzer
	output reg [18:0] freq_out; // all the above IO are as needed by rate_divider
	input [2:0] toggle; // tells us which switch/buzzer to store info for if at all
	input record; // KEY for if record button is pressed or not
    output reg saved1; // recorder buzzer #1
	output reg saved2; // recorder buzzer #2

	input ram_load;
	input keyboard_record;
	input RD_load_from; // above three are acquired from FSM
	
	always @(*)
	begin
		FSM storevals(ram_load, keyboard_record, RD_load_from, .SW(toggle), .KEY(record), clk); // get states from user/FSM
		
		if (/*?????*/) // if in freeplay mode, just use the output buzzer and play it
		begin
			rate_divider buzzer1(clk, ascii, speaker, freq_out);
		end
		if (/*?????*/) // if first save buzzer is requested when already saved
		begin
			rate_divider_no_display buzzer2(clk,.ascii(/*??????*/), .speaker(saved1));
		end
		if (/*?????*/) // if second save buzzer is requested when already saved
		begin
			rate_divider_no_display buzzer2(clk,.ascii(/*??????*/), .speaker(saved2));
		end
		if (/*?????*/) // if first buzzer wants to save a new recording (NOTE: If both switches are on, only store in first ie, rightmost)
		begin
			//??
		end
		if (/*?????*/) // if second buzzer wants to save a new recording
		begin
			//??
		end
	end
endmodule