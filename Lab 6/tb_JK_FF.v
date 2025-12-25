`timescale 1 ns / 1 ps

module tb_JK_FF ();
    // Local signals
    reg  j_stim, k_stim, clk_gen, rst_stim;
    wire q_val, q_n_val;

    // UUT Instance with explicit port mapping
    JK_FF UUT (
        .j_in(j_stim),
        .k_in(k_stim),
        .rst_high(rst_stim),
        .clk_signal(clk_gen),
        .q_out(q_val),
        .q_not(q_n_val)
    );

    // 200MHz Clock generation
    initial clk_gen = 1'b0;
    always #2.5 clk_gen = ~clk_gen;

    // Task to apply data inputs
    task apply_test(input [1:0] jk_bits, input integer duration);
        begin
            {j_stim, k_stim} = jk_bits;
            #(duration);
        end
    endtask

    // Main Test Stimulus
    initial begin
        // Reset Phase
        rst_stim = 1'b1;
        j_stim = 0; k_stim = 0;
        #17 rst_stim = 1'b0;

        // Sequence of random tests using the task
        apply_test(2'b01, 8);
        apply_test(2'b11, 7);
        apply_test(2'b00, 9);
        apply_test(2'b10, 5);
        apply_test(2'b01, 6);
        apply_test(2'b11, 8);
        apply_test(2'b00, 4);
        apply_test(2'b10, 7);
        apply_test(2'b11, 5);
        apply_test(2'b01, 9);

        $display("--- Test Sequence Complete ---");
        $stop;
    end

    // Systematic Monitoring
    initial begin
        $display(" Time | RST | J K | Q Q_BAR");
        $display("---------------------------");
        $monitor("%5d |  %b  | %b %b | %b %b", 
                 $time, rst_stim, j_stim, k_stim, q_val, q_n_val);
    end

endmodule