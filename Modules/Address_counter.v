module Store_address_counter(doStart, ascii, clk, addressOut, clockOut);
	input [6:0] ascii;
	input clk;
	input doStart; // Start counting only when doStart is 1
	output reg [7:0] addressOut = 8'b0;
	output reg clockOut = 0;

	reg [7:0] isIn;
	reg [6:0] preAscii = 7'd32;
	reg [7:0] zero = 8'b00000000;

	always @(posedge clk)
	begin
		// Start counting from 0 whenever doStart is turned on
		if (doStart == 1'b1)
		begin
			// Reset the output clock bit if the current clock bit is on
			if (clockOut == 1)	
			begin
				clockOut <= 0;
			end
			// Every time the ascii passed in is changed, update the previous ascii and the count
			if ((preAscii[0] != ascii[0]) || (preAscii[1] != ascii[1]) ||(preAscii[2] != ascii[2]) ||(preAscii[3] != ascii[3]) ||(preAscii[4] != ascii[4]) ||(preAscii[5] != ascii[5]) ||(preAscii[6] != ascii[6]))
			begin
				//addressOut[7:0] <= addressOut + 8'b1;
				isIn <= isIn+1;
				addressOut[7:0] <= isIn;
				clockOut <= 1;
				preAscii[6:0] <= ascii[6:0];
			end
		end

//		if (doStart == 1'b0)
//		begin
//			addressOut[7:0] <= zero[7:0];
//		end


		// When doStart is turned off, reset the address count
		//else begin
			//addressOut[7:0] <= 8'b01010101;
		//	isIn <= 8'b0;
		//	preAscii[6:0] <= 7'd32;
		//end
		
		
	end

endmodule

module Load_address_counter(doStart, clk, addressOut, isItEmpty);
	input clk;
	input isItEmpty;
	input doStart; // Start counting only when doStart is 1
	output reg [7:0] addressOut = 8'b0;
	// parameters to check if a reloop is needed

	reg [31:0] counter = 32'b1;
	reg [31:0] maxCount = 50000000; // Output one signal per second
	// This is a tiny rate divider
	always @(posedge clk)
	    begin
		if(counter==0) counter <= maxCount - 1; else counter <= counter - 1;
	    end

	always @(posedge clk)
	 begin
		if (doStart == 1'b1)
		begin
			////clockOut
			//if (doStart == 0) //|| isItEmpty)
			//begin
			//	addressOut <= 8'b0; // Keep the address to be 0 when the doStart is Off OR WE NEED TO RELOOP
			if (counter == 0)
			begin
				addressOut[7:0] <= addressOut[7:0] + 8'b1; // Increment the address by one per signal (per second)
			end
		end
		if (doStart == 1'b0)
		begin
			addressOut[7:0] <= 8'b0;
		end
	end

endmodule

