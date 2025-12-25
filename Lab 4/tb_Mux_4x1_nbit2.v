/*
Filename			: tb_Mux_4x1_nbit2.v	
Author			: Christian Jay Gallardo
Class				: CPE3101L
GrP. Schedule	: GRP. 4 FRIDAY 10:30AM - 1:30PM
Description		: The tb_Mux_4x1_nbit testbench verifies the multiplexer by testing all selector values 
					  (S = 00, 01, 10, 11) with two input sets, ensuring correct output selection.
*/
	
module tb_Mux_4x1_nbit2;

    // Parameters and signals for the testbench
    reg [3:0] A, B, C, D;  // 4-bit input buses
    reg [1:0] S;            // Selector input (2 bits)
    wire [3:0] Y;           // Output wire

    // Instantiate the Mux_4x1_nbit module
    Mux_4x1_nbit #(4) uut (
        .A(A), .B(B), .C(C), .D(D), 
        .S(S), .Y(Y)
    );

    // Test procedure
    initial begin
        // Apply test vectors
        A = 4'b0001; B = 4'b0010; C = 4'b0100; D = 4'b1000;

        // Test case 1: S = 00, output should be A
        S = 2'b00; #10;
        $display("S = %b, A = %b, B = %b, C = %b, D = %b, Y = %b", S, A, B, C, D, Y);

        // Test case 2: S = 01, output should be B
        S = 2'b01; #10;
        $display("S = %b, A = %b, B = %b, C = %b, D = %b, Y = %b", S, A, B, C, D, Y);

        // Test case 3: S = 10, output should be C
        S = 2'b10; #10;
        $display("S = %b, A = %b, B = %b, C = %b, D = %b, Y = %b", S, A, B, C, D, Y);

        // Test case 4: S = 11, output should be D
        S = 2'b11; #10;
        $display("S = %b, A = %b, B = %b, C = %b, D = %b, Y = %b", S, A, B, C, D, Y);

        // Test case 5: Change inputs to check for different combinations
        A = 4'b1111; B = 4'b0000; C = 4'b1010; D = 4'b0101;
        
        // Test case 6: S = 00 with new inputs, output should be A
        S = 2'b00; #10;
        $display("S = %b, A = %b, B = %b, C = %b, D = %b, Y = %b", S, A, B, C, D, Y);

        // Test case 7: S = 01 with new inputs, output should be B
        S = 2'b01; #10;
        $display("S = %b, A = %b, B = %b, C = %b, D = %b, Y = %b", S, A, B, C, D, Y);

        // Test case 8: S = 10 with new inputs, output should be C
        S = 2'b10; #10;
        $display("S = %b, A = %b, B = %b, C = %b, D = %b, Y = %b", S, A, B, C, D, Y);

        // Test case 9: S = 11 with new inputs, output should be D
        S = 2'b11; #10;
        $display("S = %b, A = %b, B = %b, C = %b, D = %b, Y = %b", S, A, B, C, D, Y);

        // End of simulation
        $finish;
    end

endmodule
