`timescale 1ns / 1ps

module tb_Race_Lights();

    reg clk;
    reg reset_n;
    reg start;
    wire red, yellow, green;
    wire [2:0] current_state;

    // Instantiate UUT
    Race_Lights UUT (
        .CLOCK(clk),
        .nRESET(reset_n),
        .START(start),
        .RED(red),
        .YELLOW(yellow),
        .GREEN(green),
        .state_out(current_state)
    );

    // Clock Generation (1Hz = 1 sec period)
    // For simulation speed, we scale this down. 
    // Let's say 10 time units = 1 second.
    initial clk = 0;
    always #5 clk = ~clk; // Period = 10 units

    initial begin
        // 1. Initialize Inputs
        $display("Time | RST STR | State | R Y G");
        $display("--------------------------------");
        reset_n = 0; start = 0;
        
        // 2. Hold Reset for a moment
        #12 reset_n = 1;
        $display("%4t |  0   0  |  %3b  | %b %b %b (Reset Released - Red ON)", $time, current_state, red, yellow, green);

        // 3. Wait in IDLE state (Red should stay ON)
        #20;

        // 4. Activate START signal
        $display("%4t |  1   1  |  %3b  | %b %b %b (Start Pressed)", $time, current_state, red, yellow, green);
        start = 1;
        
        // Hold start long enough to capture edge
        #15 start = 0; 

        // 5. Let the FSM run through the full sequence
        // We expect:
        // IDLE -> RED_HOLD (1s) -> YELLOW (1s) -> GREEN (3s) -> RESET
        
        repeat(7) @(negedge clk) begin
             $display("%4t |  1   0  |  %3b  | %b %b %b", $time, current_state, red, yellow, green);
        end

        $stop;
    end

endmodule