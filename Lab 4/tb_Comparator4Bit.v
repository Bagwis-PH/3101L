/*
Filename			: Comparator4Bit.v	
Author			: Christian Jay Gallardo
Class				: CPE3101L
GrP. Schedule	: GRP. 4 FRIDAY 10:30AM - 1:30PM
Description		: 	This Verilog testbench stimulates the main module by applying various 4-bit input values to signals A and B. 
						It verifies the output by simulating 10 test cases, displaying the comparison results for each case, and
						ensuring correct behavior of the main module under different input conditions.
*/

module tb_Comparator4Bit;
    reg [3:0] A, B;
    wire [2:0] R;
    
    // Instantiate the comparator
    Comparator4Bit uut(
        .A(A),
        .B(B),
        .R(R)
    );
    
   initial begin
		 // Test Case 1: A > B
		 A = 4'b1010; B = 4'b0101; #10;
		 $display("Test 1: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 2: A < B
		 A = 4'b0011; B = 4'b1100; #10;
		 $display("Test 2: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 3: A = B
		 A = 4'b1111; B = 4'b1111; #10;
		 $display("Test 3: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 4: A > B (edge case)
		 A = 4'b0001; B = 4'b0000; #10;
		 $display("Test 4: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 5: A < B (edge case)
		 A = 4'b0000; B = 4'b0001; #10;
		 $display("Test 5: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 6: A > B
		 A = 4'b1100; B = 4'b1011; #10;
		 $display("Test 6: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 7: A < B
		 A = 4'b0101; B = 4'b1010; #10;
		 $display("Test 7: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 8: A = B
		 A = 4'b1010; B = 4'b1010; #10;
		 $display("Test 8: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 9: A > B
		 A = 4'b1110; B = 4'b1101; #10;
		 $display("Test 9: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

		 // Test Case 10: A < B
		 A = 4'b0010; B = 4'b0011; #10;
		 $display("Test 10: A=%b, B=%b, R=%b (G=%b, E=%b, L=%b)", A, B, R, R[2], R[1], R[0]);

    $finish;
end

    
    initial begin
        $monitor("Time=%0t: A=%b, B=%b, R=%b", $time, A, B, R);
    end
    
endmodule