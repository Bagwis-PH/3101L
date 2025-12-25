/*
Filename			: The Mux_4x1_nbit.v	
Author			: Christian Jay Gallardo
Class				: CPE3101L
GrP. Schedule	: GRP. 4 FRIDAY 10:30AM - 1:30PM
Description		: The Mux_4x1_nbit is a parameterized 4-to-1 multiplexer that selects one of four 
					  n-bit inputs based on a 2-bit selector and outputs the selected value.
*/



module Mux_4x1_nbit #(parameter n = 4) (
    input [n-1:0] A, B, C, D,  // 4 input buses
    input [1:0] S,              // Selector input (2 bits)
    output [n-1:0] Y            // Output bus
);

    // Simple case statement to select the output based on S
    assign Y = (S == 2'b00) ? A :
               (S == 2'b01) ? B :
               (S == 2'b10) ? C :
               (S == 2'b11) ? D : A;  // Default case (for safety)

endmodule
