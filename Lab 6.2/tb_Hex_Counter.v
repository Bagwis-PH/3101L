`timescale 1 ns / 1 ps

module tb_Hex_Counter ();
    // Local interconnects
    reg         clk_sys;
    reg         reset_n;
    reg         load_cmd;
    reg         enable;
    reg         dir_up;
    reg         dot_pt;
    reg  [3:0]  parallel_in;
    
    wire [7:0]  seven_seg_out;
    wire        slow_clock_debug;

    // Simulation timing parameters
    localparam REF_FREQ = 10;
    localparam TARGET_FREQ = 1;
    localparam SCALE_FACTOR = (REF_FREQ / TARGET_FREQ);

    // Instantiate UUT using Named Port Mapping (Different from positional)
    Hex_Counter #(
        .oldHz(REF_FREQ), 
        .newHz(TARGET_FREQ)
    ) UUT (
        .Clk(clk_sys),
        .nReset(reset_n),
        .Load(load_cmd),
        .Count_en(enable),
        .Up(dir_up),
        .DP(dot_pt),
        .Count_in(parallel_in),
        .SSeg(seven_seg_out),
        .div_clock(slow_clock_debug)
    );

    // Clock Generation: 5ns toggles (10ns period)
    initial clk_sys = 1'b0;
    always #2.5 clk_sys = ~clk_sys;

    // Async toggle for Decimal Point
    always #(8 * SCALE_FACTOR) dot_pt = ~dot_pt;

    // --- Task to simplify stimulus application ---
    task apply_vector(input r, input l, input e, input u, input [3:0] data, input integer dly);
        begin
            reset_n = r; load_cmd = l; enable = e; dir_up = u; parallel_in = data;
            #(dly * SCALE_FACTOR);
        end
    endtask

    // Main Test Sequence
    initial begin
        dot_pt = 1'b0;
        $display("Time | RST LD EN UP DP | IN | SSeg");
        
        // 1. System Setup
        apply_vector(0, 0, 1, 1, 4'h0, 3);
        
        // 2. Increment Test
        $display(">> Incrementing...");
        apply_vector(1, 0, 1, 1, 4'h0, 12);
        
        // 3. Enable Logic Check
        $display(">> Testing Pause...");
        apply_vector(1, 0, 0, 1, 4'h0, 7);
        apply_vector(1, 0, 1, 1, 4'h0, 5);
        
        // 4. Manual Load
        $display(">> Loading 0xD...");
        apply_vector(1, 1, 1, 1, 4'hD, 4);
        apply_vector(1, 0, 1, 1, 4'hD, 25);
        
        // 5. Mid-stream Reset
        $display(">> Clearing System...");
        apply_vector(0, 0, 1, 1, 4'h0, 3);
        apply_vector(1, 0, 1, 1, 4'h0, 7);
        
        // 6. Decrement Test
        $display(">> Decrementing...");
        apply_vector(1, 0, 1, 0, 4'h0, 13);
        
        // 7. Final Operations
        apply_vector(1, 0, 0, 0, 4'h0, 5);
        apply_vector(1, 0, 1, 0, 4'h0, 12);
        
        $display(">> Final Load 0x6...");
        apply_vector(1, 1, 1, 0, 4'h6, 5);
        apply_vector(1, 0, 1, 0, 4'h6, 14);

        $display("Simulation Ended at %t", $time);
        $stop;
    end

    // Systematic Monitoring
    initial begin
        $monitor("%t | %b  %b  %b  %b  %b | %h | %b", 
                 $time, reset_n, load_cmd, enable, dir_up, dot_pt, parallel_in, seven_seg_out);
    end

endmodule