module Store_address_counter(doStart, ascii, clk, addressOut);
	input [6:0] ascii;
	input clk;
	input doStart; // Start counting only when doStart is 1
	output reg [7:0] addressOut = 8'b0;

	reg [6:0] preAscii;

	always @(posedge clk)
	begin
		// Start counting from 0 whenever doStart is turned on
		if (doStart)
		begin
			// Every time the ascii passed in is changed, update the previous ascii and the count
			if (preAscii[6:0] != ascii[6:0])
			begin
				addressOut[7:0] <= addressOut[7:0] + 8'b1;
				preAscii[6:0] <= ascii[6:0];
			end
		end
		// When doStart is turned off, reset the address count
		else
		begin
			addressOut[7:0] <= 8'b0;
		end
	end
endmodule

module Load_address_counter(doStart, clk, addressOut);
	input clk;
	input doStart; // Start counting only when doStart is 1
	output reg [7:0] addressOut = 8'b0;

	reg [31:0] counter = 32'b1;
	reg [31:0] maxCount = 50000000; // Output one signal per second
	// This is a tiny rate divider
	always @(posedge clk)
	    begin
		if(counter==0) counter <= maxCount - 1; else counter <= counter - 1;
	    end

	always @(posedge clk)
	 begin
		if (doStart == 0)
		begin
			addressOut <= 8'b0; // Keep the address to be 0 when the doStart is Off
		end
		else if (counter == 0)
		begin
			addressOut[7:0] <= addressOut[7:0] + 8'b1; // Increment the address by one per signal (per second)
		end
	 end
endmodule

