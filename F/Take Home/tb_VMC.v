// Christian Jay Y. Gallardo
// Lorenz Anthony L. Soriano

`timescale 1ns/1ps

module tb_VMC();
    // Inputs
    reg clk;
    reg [1:0] key;
    reg [9:0] sw;

    // Outputs
    wire [2:0] ledr;
    wire dispense, c1, c5, c10;
    wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5;
    wire [5:0] hex_dp;

    VMC uut (
        .MAX10_CLK1_50(clk),
        .KEY(key),
        .SW(sw),
        .LEDR(ledr),
        .DISPENSE(dispense),
        .C1(c1), .C5(c5), .C10(c10),
        .HEX0(hex0), .HEX1(hex1), .HEX2(hex2), .HEX3(hex3), .HEX4(hex4), .HEX5(hex5),
        .HEX_DP(hex_dp)
    );

    // 50MHz clock Generation (20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialization
        clk = 0;
        key = 2'b11; // KEY0 (Reset) is Active Low, so 1 = No Reset
        sw = 10'b0;  // All switches down

        // Asynchronous Reset
        #50 key[0] = 0; // Trigger Reset
        #50 key[0] = 1; // Release Reset
        #100;

        // Start & select Item 3 (Php 12.00)
        // START is synchronous active high
        sw[0] = 1; #100 sw[0] = 0; // START pulse
        
        // SELECT traverses available items
        repeat(2) begin
            #100 sw[1] = 1; #100 sw[1] = 0; // Toggle SELECT twice to get to Item 3
        end
        
        // OK proceeds to payment
        #100 sw[2] = 1; #100 sw[2] = 0; // OK pulse
        $display("Item 3 selected. Price should be 12.");

        // Payment Phase (Insert Php 15.00)
        // Accept Php 1.00, 5.00, 10.00
        #100 sw[6] = 1; #100 sw[6] = 0; // Insert Php 10.00 (Balance = 10)
        #100 sw[5] = 1; #100 sw[5] = 0; // Insert Php 5.00  (Balance = 15)
        
        // Reject payment once balance >= price
        // Trying to insert another Php 1.00 - should be ignored
        #100 sw[4] = 1; #100 sw[4] = 0;

        // Dispense Phase
        // Another assertion of OK after payment is enough
        #200 sw[2] = 1; #100 sw[2] = 0; // Final OK to Dispense
        
        // Wait for change
        // Provide change (15 - 12 = 3).
        #2000;

        $stop;
    end
endmodule