module ChooseMusic (ascii, clk, saved1, saved2, toggle, record);
	input [6:0] ascii;
	input clk;
	input [17:0] toggle; // tells us which switch/buzzer to store info for if at all
	input [3:0] record; // KEY for if record button is pressed or not
   output saved1; // recorder buzzer #1
	output saved2; // recorder buzzer #2


   wire loadAFromRam;
	wire loadBFromRam;
	wire ramARecord;
	wire ramBRecord; // above four are acquired from FSM below
	
	FSM storevals(loadAFromRam, loadBFromRam, ramARecord, ramBRecord, toggle, clk); // get states from user/FSM
	
	wire [6:0] new_keyA; // the artificial note acquired from storage files
	wire [6:0] new_keyB; // artificial note

	// LoadAFromRam == 1
	readRecording forAvalue(.newkey(new_keyA), .clk(clk), .isA(1'b1), .ramRecord(loadAFromRam)); // call helper to get stored key
	rate_divider_no_display buzzerA(.clk(clk), .ascii(new_keyA), .speaker(saved1)); // send to output
	// LoadBFromRam == 1
	readRecording forBvalue(.newkey(new_keyB), .clk(clk), .isA(1'b0), .ramRecord(loadBFromRam)); // call helper to get stored key
	rate_divider_no_display buzzerB(.clk(clk), .ascii(new_keyB), .speaker(saved2)); // output
	// StoreToA == 1
	storeRecording forA(.ascii(ascii), .clk(clk), .isA(1'b1), .ramRecord(ramARecord)); // call helper module
	// StoreToB == 1
	storeRecording forB(.ascii(ascii), .clk(clk), .isA(1'b0), .ramRecord(ramBRecord)); // call helper module

endmodule
