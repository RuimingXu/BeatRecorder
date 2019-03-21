module storeRecording (ascii, clk, isA);
input isA; //which file to store to (A or not A ie B)
input clk; // clock
input [6:0] ascii; //current character
reg [6:0] prev_key;

integer keyfile; // pointer to file with saved keys
reg [31:0] counter;

// Create (or overwrite the file)
initial begin
	if (isA) begin // name the file based on which buzzer it is
		keyfile = $fopen("A_keys.txt","w");
	end
	else begin
		keyfile = $fopen("B_keys.txt","w");
	end
	prev_key[6:0] = ascii[6:0]; // initially set the current key to be the first one found
	$fdisplay(keyfile,"%d", prev_key); //store the first keys name to the file in decimal form
	counter <= 1'b1
end

always@(posedge clk) // IF THE VALUES BELOW AREN'T CHANGING IT MEANS ASCII ISN'T BEING REASSIGNED WHEN PRESSED.
begin: adding_keys
	// New key is still same as old one. Just increment counter
	if (prev_key == ascii) begin
		counter <= counter+1;
	end
	else begin // otherwise a new ascii vlaue passed. Save the old one
	    $fdisplay(keyfile,"%d", ascii); //write as decimal
		$fdisplay(keyfile,"%b", counter); //write as binary the length as well
		prev_key <= ascii; // prev_key now moves onto the new ascii symbol
	end
	if (counter == 32'd2147483646) begin // If the counter goes out of bounds, completely ignore/ nullify that held note
		counter = 1'b1;
	end
end

$fclose(keyfile); // THIS MIGHT CAUSE ISSUES, SINCE ITERATING EVERY TIME --- MIGHT NEED TO MOVE TO PLAYER MODULE

endmodule



module readRecording (newkey, clk, isA);
output reg newkey; // new ascii character/ note to return
input clk;
input isA;

// THIS MODULE NEEDS ERROR HANDLING (FOR EOF AND FILE NONEXISTANT CASES)
$fscanf(keyfile,"%d\n", newkey); //scan each line and get the value as a decimal (of course)
endmodule