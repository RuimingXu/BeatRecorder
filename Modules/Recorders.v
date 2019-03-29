module storeRecording (ascii, clk, isA);
	input isA; //which file to store to (A or not A ie B)
	input clk; // clock
	input [6:0] ascii; //current character
	reg [6:0] prev_key;

	integer keyfile; // pointer to file with saved keys
	reg [31:0] counter;

//	// Create (or overwrite the file)
//	initial begin
//		if (isA) begin // name the file based on which buzzer it is
//			keyfile = $readmemb("A_keys.txt","w");
//		end
//		else begin
//			keyfile = $readmemb("B_keys.txt","w");
//		end
//		prev_key[6:0] <= ascii[6:0]; // initially set the current key to be the first one found
//		$fdisplay(keyfile,"%d", prev_key); //store the first keys name to the file in decimal form
//		
//	end

	counter <= 1'b1;

	always@(posedge clk) // IF THE VALUES BELOW AREN'T CHANGING IT MEANS ASCII ISN'T BEING REASSIGNED WHEN PRESSED.
	begin: adding_keys
		// New key is still same as old one. Just increment counter
		if (prev_key == ascii) begin
			counter <= counter+1;
			if (counter == 32'd2147483646) begin // If the counter goes out of bounds, completely ignore/ nullify that held note
				counter <= 1'b1;
			end
		end
		else begin // otherwise a new ascii vlaue passed. Save the old one
			$fdisplay(keyfile,"%d", ascii); //write as decimal
			$fdisplay(keyfile,"%b", counter); //write as binary the length as well
			prev_key[6:0] <= ascii[6:0]; // prev_key now moves onto the new ascii symbol
			counter <= 1'b1; // reset counter
		end
	end

	//$fclose(keyfile); // THIS MIGHT CAUSE ISSUES, SINCE ITERATING EVERY TIME --- MIGHT NEED TO MOVE TO PLAYER MODULE

endmodule



module readRecording (newkey, clk, isA);
	output reg [6:0] newkey; // new ascii character/ note to return
	input clk;
	input isA;
	reg [6:0] prev_key;

	integer keyfile; // pointer to file with saved keys
	reg [31:0] counter;// the count for each chosen key
	
	initial begin
		if (isA) begin // get the named file based on which buzzer it is
			keyfile = $fopen("A_keys.txt","r");
		end
		else begin
			keyfile = $fopen("B_keys.txt","r");
		end
		if (keyfile != 0) begin // if existant file... ********************************
			$fscanf(keyfile,"%d\n", newkey); //scan and keep first ascii character
			$fscanf(keyfile,"%b\n", counter); //scan and keep first count value
			prev_key[6:0] <= newkey[6:0];// assign previous key to be new initial key
		end
	end

	always@(posedge clk)
	begin: getting_keys

		// Only perform operations if file is existant
		if (keyfile != 0) begin // ******************************
			// Need to hold note: return previous key and decrement counter
			if (counter != 1'b0) begin
				counter <= counter-1'b1;
				newkey[6:0] <= prev_key[6:0]; // is this even necessary?
			end
			else begin // otherwise get next key and length
				if ($feof(keyfile)) begin
					// if we reached end of the A buzzers output, (and presumably read A switch is still on), restart reading from top
					// EITHER RESTART ENTIRE MODULE HERE SOMEHOW OR JUST REOPEN FILE
					if (isA) begin // get the named file based on which buzzer it is
						keyfile = $fopen("A_keys.txt","r");
					end
					else begin
						keyfile = $fopen("B_keys.txt","r");
					end
					$fscanf(keyfile,"%d\n", newkey); //scan and keep first ascii character again
					$fscanf(keyfile,"%b\n", counter); //scan and keep first count value again
					prev_key[6:0] <= newkey[6:0];
				end
				$fscanf(keyfile,"%d\n", newkey);
				$fscanf(keyfile,"%b\n", counter);
				prev_key[6:0] <= newkey[6:0]; // not necessary? ***************************
			end
		end
	end

	// THIS MODULE NEEDS ERROR HANDLING (FOR EOF AND FILE NONEXISTANT CASES)

	//$fclose(keyfile); // THIS MIGHT CAUSE ISSUES, SINCE ITERATING EVERY TIME --- MIGHT NEED TO MOVE TO PLAYER MODULE
endmodule
