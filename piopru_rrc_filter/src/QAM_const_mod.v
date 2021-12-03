`timescale 1ns/100ps

// input: stream of bytes
// output: complex pairs (real, imag) corresponding to read symbol (sequence of bits)

module QAM_const_mod	(
					real_out,
					imag_out,
					inp,
					clk,
					rst);
input wire clk, rst;
input wire [3:0] inp;
output [31:0] real_out,imag_out;
reg signed [31:0] real_out, imag_out;

initial real_out = 32'b0;
initial imag_out = 32'b0;

localparam level = 1;  			// can be modified from outside the module
//localparam level = $sqrt(0.1);	// real type constant; value derived from GNURadio module source

// Task 1: creating diagram of constellation based on number of constellation points
//parameter NUMBER_OF_POINTS = 16;
//wire [$clog2(NUMBER_OF_POINTS)-1:0] symbol_tmp;
always @(rst or posedge clk) // hangs processing until input event
begin
	if (~rst)
		begin
			real_out = 32'b0;
			imag_out = 32'b0;
		end
	else if (clk)
		begin
		case(inp)
				4'b1000 : begin real_out = -3*level; imag_out =  3*level ;end
				4'b1101 : begin real_out = -1*level; imag_out =  3*level ;end
				4'b1100 : begin real_out =  1*level; imag_out =  3*level ;end
				4'b1001 : begin real_out =  3*level; imag_out =  3*level ;end
				4'b1111 : begin real_out = -3*level; imag_out =  1*level ;end
				4'b1010 : begin real_out = -1*level; imag_out =  1*level ;end
				4'b1011 : begin real_out =  1*level; imag_out =  1*level ;end
				4'b1110 : begin real_out =  3*level; imag_out =  1*level ;end
				4'b0100 : begin real_out = -3*level; imag_out = -1*level ;end
				4'b0001 : begin real_out = -1*level; imag_out = -1*level ;end
				4'b0000 : begin real_out =  1*level; imag_out = -1*level ;end
				4'b0101 : begin real_out =  3*level; imag_out = -1*level ;end
				4'b0011 : begin real_out = -3*level; imag_out = -3*level ;end
				4'b0110 : begin real_out = -1*level; imag_out = -3*level ;end
				4'b0111 : begin real_out =  1*level; imag_out = -3*level ;end
				4'b0010 : begin real_out =  3*level; imag_out = -3*level ;end
				default : begin real_out = 0; imag_out = 0;end
		endcase	
		end
	else
		begin
		real_out = real_out;
		imag_out = imag_out;
		end
end

endmodule