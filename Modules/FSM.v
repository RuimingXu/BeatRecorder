module FSM(ram_load, keyboard_record, RD_load_from, SW, KEY, clk);
    input [2:0] SW;
    input [3:0] KEY;
	input clk;
	
    output reg ram_load;
	output reg keyboard_record;
	output reg RD_load_from;
	

    wire recordAndPlayW, playRecordW, playRecordAndPlayW;
	 reg [7:0] stateInfo;

    reg [3:0] Y_Q, Y_D; // y_Q represents current state, Y_D represents next state
	 reg current_state, next_state;

    localparam freePlay = 4'b0000, recordAndPlay = 4'b0001, playRecord = 4'b0011, playRecordAndPlay = 4'b0010;

    assign recordAndPlayW = SW[0];
    assign playRecordW = SW[1];
    assign playRecordAndPlayW = SW[2];

    //State table
    //The state table should only contain the logic for state transitions
    //Do not mix in any output logic. The output logic should be handled separately.
    //This will make it easier to read, modify and debug the code.
    always@(*)
    begin: state_table
        case (Y_Q)
            freePlay: begin
                   if (recordAndPlayW) Y_D <= recordAndPlay;
				   else if (playRecordW) Y_D <= playRecord;
				   else if (playRecordAndPlayW) Y_D <= playRecordAndPlay;
                   else Y_D <= Y_Q;
               end
            recordAndPlay: begin
                   if (!recordAndPlayW) Y_D <= freePlay;
                   else Y_D <= recordAndPlay;
               end
            playRecordW: begin
                   if (!playRecordW) Y_D <= freePlay;
                   else Y_D <= playRecordW;
               end
            playRecordAndPlay: begin
                   if (!playRecordAndPlayW) Y_D <= freePlay;
                   else Y_D <= playRecordAndPlayW;
               end
            default: Y_D = freePlay;
        endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*)
    begin
        // By default make all our signals 0
        ram_load = 1'b0;
        keyboard_record = 1'b0;
        RD_load_from = 2'b00;

        case (current_state)
            freePlay: begin
				//pass
            end

            recordAndPlay: begin
                ram_load = 1'b1;
                keyboard_record = 1'b1;
				RD_load_from = 1'b1;
            end

            playRecord: begin
				RD_load_from = 1'b0;
            end
			
			playRecordAndPlay: begin
				// Multiple Buzzer needed for this. *******************
			end
			endcase
	end
	
	// current_state registers
    always@(posedge clk)
    begin: state_FFs
        current_state <= next_state;
    end

endmodule
