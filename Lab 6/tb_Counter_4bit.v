`timescale 1ns / 1ps

module tb_Counter_4bit();

    // Signal Declarations
    reg         clk;
    reg         rst_n;
    reg         load_en;
    reg         en;
    reg         dir_up;
    reg  [3:0]  d_in;
    wire [3:0]  q_out;

    // Instantiate Unit Under Test (UUT) using named port mapping
    Counter_4bit UUT (
        .Clk(clk),
        .nReset(rst_n),
        .Load(load_en),
        .Count_en(en),
        .Up(dir_up),
        .Count_in(d_in),
        .Count_out(q_out)
    );

    // Clock Generation (200MHz / 5ns period)
    initial clk = 0;
    always #2.5 clk = ~clk;

    // Task for resetting the counter
    task reset_system;
        begin
            rst_n = 0;
            #5;
            rst_n = 1;
        end
    endtask

    // Main Simulation Block
    initial begin
        // 1. Initialize Signals
        rst_n = 1; load_en = 0; en = 0; dir_up = 1; d_in = 4'h0;
        
        $display("--- Starting Simulation ---");
        reset_system(); // Call reset task

        // 2. Test Up Counting
        $display("Testing: Incrementing");
        en = 1; dir_up = 1;
        #20;

        // 3. Test Enable Toggle
        en = 0; #10;
        en = 1; #10;

        // 4. Test Loading Value
        $display("Testing: Parallel Load");
        d_in = 4'hD; // 1101
        load_en = 1; #5;
        load_en = 0; #20;

        // 5. Test Reset during operation
        $display("Testing: Async Reset");
        reset_system();
        #10;

        // 6. Test Down Counting
        $display("Testing: Decrementing");
        dir_up = 0;
        #20;

        // 7. Test Final Load
        d_in = 4'h6;
        load_en = 1; #5;
        load_en = 0; #15;

        $display("Simulation Ended at %t", $realtime);
        $finish; // Use finish to end simulation
    end

    // Automatic Monitor: Tracks signals whenever they change
    initial begin
        $display(" Time | RST | LD | EN | UP |  IN  | OUT");
        $display("---------------------------------------");
        $monitor("%5t |  %b  | %b  | %b  | %b  | %b | %b", 
                 $time, rst_n, load_en, en, dir_up, d_in, q_out);
    end

endmodule