module ChooseMusic (freq_out, ascii, clk, speaker, saved1, saved2, toggle, record);
	input [6:0] ascii;
	input clk;
	output reg speaker; // main buzzer
	output reg [18:0] freq_out; // all the above IO are as needed by rate_divider
	input [17:0] toggle; // tells us which switch/buzzer to store info for if at all
	input [3:0] record; // KEY for if record button is pressed or not
    output reg saved1; // recorder buzzer #1
	output reg saved2; // recorder buzzer #2
	
	// Free play mode should be always on: call module
	rate_divider buzzer1(clk, ascii, speaker, freq_out);

    input loadAFromRam;
	input loadBFromRam;
	input ramARecord;
	input ramBRecord; // above four are acquired from FSM below
	
	FSM storevals(loadAFromRam, loadBFromRam, ramARecord, ramBRecord, toggle, clk); // get states from user/FSM
	
	always @(*)
	begin
		if (loadAFromRam == 1'b1) // Get output/play backdrop from A buzzer
		begin
			rate_divider_no_display buzzerA(clk,.ascii(/*??????*/), .speaker(saved1));
		end
		if (loadBFromRam == 1'b1) // Get output/play backdrop from B buzzer
		begin
			rate_divider_no_display buzzerB(clk,.ascii(/*??????*/), .speaker(saved2));
		end
		if (ramARecord == 1'b1) //Save and store what is being freeplayed to memory for A
		begin
			//??
		end
		if (ramBRecord == 1'b1) //Save and store what is being freeplayed to memory for B
		begin
			//??
		end
	end
endmodule