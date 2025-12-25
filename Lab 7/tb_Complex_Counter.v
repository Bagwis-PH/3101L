`timescale 1 ns / 1 ps

module tb_Complex_Counter();
    // ---------------------------------------------------------
    // Signal Declarations
    // ---------------------------------------------------------
    reg         clk_sys;      // System clock
    reg         reset_n;      // Active-low synchronous reset
    reg         mode_m;       // Mode control (0: Binary, 1: Gray)
    
    wire [2:0]  count_val;    // Current state output
    wire [2:0]  next_state_val; // Next state visibility for TB
    wire        clock_divided;  // Clock signal used by the FSM

    // ---------------------------------------------------------
    // Simulation Parameters
    // ---------------------------------------------------------
    localparam REF_HZ = 2;    // Simulated input frequency
    localparam TARGET_HZ = 1; // Simulated target frequency
    localparam RATIO = (REF_HZ / TARGET_HZ);

    // ---------------------------------------------------------
    // Unit Under Test (UUT) Instantiation
    // ---------------------------------------------------------
    // Using named port mapping to ensure correct connections 
    // and distinct coding style.
    Complex_Counter #(
        .oldHz(REF_HZ), 
        .newHz(TARGET_HZ)
    ) UUT (
        .CLOCK(clk_sys),
        .nRESET(reset_n),
        .M(mode_m),
        .COUNT(count_val),
        .onstate(next_state_val), 
        .onew_clk(clock_divided)
    );

    // ---------------------------------------------------------
    // Clock Generation
    // ---------------------------------------------------------
    initial clk_sys = 1'b0;
    always #2.5 clk_sys = ~clk_sys; // 5ns period toggles every 2.5ns

    // ---------------------------------------------------------
    // Stimulus Task
    // ---------------------------------------------------------
    // This procedural task handles the signal timing.
    task drive_stimulus(input rst, input m_val, input integer duration);
        begin
            reset_n = rst;
            mode_m = m_val;
            #(duration * RATIO);
        end
    endtask

    // ---------------------------------------------------------
    // Main Test Sequence
    // ---------------------------------------------------------
    initial begin
        // 1. System Initialization
        $display(">> Setup: Clearing registers...");
        drive_stimulus(0, 0, 10);
        
        // 2. Binary Mode Testing (M=0)
        $display(">> Mode: Binary Sequence (M=0)");
        drive_stimulus(1, 0, 50);
        
        // 3. Gray Code Testing (M=1)
        $display(">> Mode: Gray Code Sequence (M=1)");
        drive_stimulus(1, 1, 30);
        
        // 4. Verification of Reset
        $display(">> Action: Pulsing Reset...");
        drive_stimulus(0, 1, 10);
        
        // 5. Resume Gray Code
        $display(">> Mode: Continuing Gray Code...");
        drive_stimulus(1, 1, 8);
        
        // 6. Dynamic Mode Switch back to Binary
        $display(">> Mode: Dynamic Switch to Binary...");
        drive_stimulus(1, 0, 8);

        $display("--- Simulation Finished at %t ---", $time);
        $stop;
    end

    // ---------------------------------------------------------
    // Monitoring and Output
    // ---------------------------------------------------------
    initial begin
        $display(" Time | RST M | CUR NXT");
        $display("-----------------------");
        $monitor("%5t |  %b  %b | %3b %3b", 
                 $time, reset_n, mode_m, count_val, next_state_val);
    end

    // Visual indicator for the falling edge of the clock
    always @(negedge clock_divided) begin
        $display("%5t |  %b  %b > %3b %3b (Edge)", 
                 $time, reset_n, mode_m, count_val, next_state_val);
    end

endmodule