/*
Filename			: Comparator4Bit.v	
Author			: Christian Jay Gallardo
Class				: CPE3101L
GrP. Schedule	: GRP. 4 FRIDAY 10:30AM - 1:30PM
Description		: This Verilog module performs a series of test cases to compare two 4-bit binary values, A and B. For each case, it checks 
						if A is greater than, less than, or equal to B, and displays the results using the R signal and its individual bits (G, E, L).
*/


module Comparator4Bit(
    input [3:0] A,
    input [3:0] B,
    output [2:0] R
);

    // Dataflow modeling
    assign R[2] = (A > B) ? 1'b1 : 1'b0;  // G: A > B
    assign R[1] = (A == B) ? 1'b1 : 1'b0; // E: A == B
    assign R[0] = (A < B) ? 1'b1 : 1'b0;  // L: A < B

endmodule

