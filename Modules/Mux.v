module Mux (in1, in2, signal, out);
	input [7:0] in1;
	input [7:0] in2;
	input signal;
	output reg [7:0] out;

	always@(*)
	begin
		if (signal == 1)
		begin
			out[7:0] <= in2[7:0];
		end
		else
		begin
			out[7:0] <= in1[7:0];
		end
	end
endmodule
