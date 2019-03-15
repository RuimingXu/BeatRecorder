module read_keyboard (kb_data, kb_clock, ascii);
	input kb_data;
	input kb_clock;
	output [6:0] ascii;
	wire [7:0] raw_data;
	
	//Convert keyboard inputs to raw data
	get_raw keys(kb_clock, kb_data, raw_data[7:0]);
	
	// Last step: process ascii's
	convert_readable chars(raw_data[7:0], ascii[6:0]);
	
endmodule

// This module created by aid from a referenced project (Notepad--)
module get_raw(clk, data, raw);
    input wire clk; // Clock pin form keyboard
    input wire data; //Data pin form keyboard
    output reg [7:0] raw;


    reg [7:0] data_curr;
    reg [7:0] data_pre;
    reg [3:0] b;
    reg flag;
    
    initial
    begin
        b<=4'h1;
        flag<=1'b0;
        data_curr<=8'hf0;
        data_pre<=8'hf0;
        raw<=8'hf0;
    end
        
    always @(negedge clk) //Activating at negative edge of clock from keyboard
    begin
    case(b)
        1:; //first bit
        2:data_curr[0]<=data;
        3:data_curr[1]<=data;
        4:data_curr[2]<=data;
        5:data_curr[3]<=data;
        6:data_curr[4]<=data;
        7:data_curr[5]<=data;
        8:data_curr[6]<=data;
        9:data_curr[7]<=data;
        10:flag<=1'b1; //Parity bit
        11:flag<=1'b0; //Ending bit
    endcase
    
    if(b<=10)
        b<=b+1;
    else if(b==11)
        b<=1;
    end
    
    always@(posedge flag) // Printing data obtained to led
    begin
    if(data_curr==8'hf0)
        raw<=data_pre;
    else
        data_pre<=data_curr;
    end
endmodule



module convert_readable(raw_data, ascii);
    input [7:0] raw_data;
	output reg [6:0] ascii;
	
	always @(*)
	begin
		case(raw_data[7:0])
			// only using first two rows of letters for keyboard. Thus, only assigning relevant keys signif. values.
			8'b00011100: ascii = 7'd65; // 'A'
			8'b00100011: ascii = 7'd68; // 'D'
			8'b00100100: ascii = 7'd69; // 'E'
			8'b00101011: ascii = 7'd70; // 'F'
			8'b00110100: ascii = 7'd71; // 'G'
			8'b00110011: ascii = 7'd72; // 'H'
			8'b01000011: ascii = 7'd73; // 'I'
			8'b00111011: ascii = 7'd74; // 'J'
			8'b01000010: ascii = 7'd75; // 'K'
			8'b01001011: ascii = 7'd76; // 'L'
			8'b01000100: ascii = 7'd79; // 'O'
			8'b01001101: ascii = 7'd80; // 'P'
			8'b00010101: ascii = 7'd81; // 'Q'
			8'b00101101: ascii = 7'd82; // 'R'
			8'b00011011: ascii = 7'd83; // 'S'
			8'b00101100: ascii = 7'd84; // 'T'
			8'b00111100: ascii = 7'd85; // 'U'
			8'b00011101: ascii = 7'd87; // 'W'
			8'b00110101: ascii = 7'd89; // 'Y'
    		default: ascii = 7'd32; // all other selected vals
		endcase
	end
	
endmodule
