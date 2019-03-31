module Beat_recorder (LEDG, LEDR, SW, KEY, PS2_KBCLK, CLOCK_50, PS2_KBDAT, GPIO, HEX0, HEX1);
	input [3:0] KEY;     // KEY0 is our record button. KEY0 again is stop recording (saved recordings can be written over, so no reset button needed).
	input [17:0] SW;      // SW 1,0 are our registers for saved recordings
	input PS2_KBCLK;    // Clock input from the keyboard
	input CLOCK_50;     // Clock input for rate divider
	input PS2_KBDAT;    // Data input from the keyboard (byte)      (This and the above input need to be deciphered to values we can work with)
	output [35:0] GPIO; // These are our buzzer speakers. 7-0 is main buzzer. 35-28 is register buzzer #1. 27-20 is #2. 19-12 is #3.
	
	output [7:0] HEX0; // NOT NEEDED - DESIGN
	output [7:0] HEX1; // ^

	output [17:0] LEDR;
	output [7:0] LEDG;
	
	// Convert the keyboard input into processable data (ie, get ascii symbol of key)
	wire [6:0] ascii_val;
	read_keyboard ps2(.kb_data(PS2_KBDAT), .kb_clock(PS2_KBCLK), .ascii(ascii_val[6:0]));
	
	show_key keys(ascii_val[6:0], HEX1[7:0], HEX0[7:0]); // visual display -> showing the keys being used (for testing and looking pretty lol')
	
	// The FSM module
	wire ramAwren, ramBwren;
	wire isLoadingFromA, isLoadingFromB;
	FSM fsmMod(isLoadingFromA, isLoadingFromB, ramAwren, ramBwren, SW, CLOCK_50, LEDG[3:0]);
	
	// parameters to check if a reloop is needed
	reg isAempty;
	reg isBempty;

	// Get address for loading and storing
	wire [7:0] storeAddressA;
	wire [7:0] storeAddressB;
	wire [7:0] loadAddressA;
	wire [7:0] loadAddressB;
	wire [40:0] wev;
	Store_address_counter sAdrsCtrModA(ramAwren, ascii_val[6:0], CLOCK_50, storeAddressA);
	Store_address_counter sAdrsCtrModB(ramBwren, ascii_val[6:0], CLOCK_50, storeAddressB); 
	Load_address_counter lAdrsCtrModA(isLoadingFromA, CLOCK_50, loadAddressA, isAempty);
	Load_address_counter lAdrsCtrModB(isLoadingFromB, CLOCK_50, loadAddressB, isBempty);

	// Give different address in different state
	wire [7:0] ramAAddress;
	wire [7:0] ramBAddress;
	Mux muxForRamA(storeAddressA, loadAddressA, isLoadingFromA, ramAAddress);
	Mux muxForRamB(storeAddressB, loadAddressB, isLoadingFromB, ramBAddress);

	// Initialize two rams for buzzer A and B
	wire [6:0] ramAOut;
	wire [6:0] ramBOut;
	Ram ramA(.address(ramAAddress[7:0]),
			.clock(CLOCK_50),
			.data(ascii_val[6:0]),
			.wren(ramAwren),
			.q(ramAOut));

	Ram ramB(.address(ramBAddress[7:0]),
			.clock(CLOCK_50),
			.data(ascii_val[6:0]),
			.wren(ramBwren),
			.q(ramBOut));

	// Free play mode should be always on: call module
	rate_divider buzzer1(CLOCK_50, ascii_val, GPIO[8:6], LEDR[9:0]);
	rate_divider_for_load buzzer2(isLoadingFromA, CLOCK_50, ramAOut, GPIO[14:12]);
	//rate_divider_for_load buzzer3(isLoadingFromB, CLOCK_50, test, GPIO[20:18]);
	
	// Simply call the music player module:
	// ChooseMusic buzzers(.clk(CLOCK_50), .ascii(ascii_val[6:0]), .saved1(LEDG[1]), .saved2(LEDG[2]), .toggle(SW[17:0]), .record(KEY[3:0])); // NOT DONE, MORE I/O present
	
endmodule
