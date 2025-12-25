`timescale 1 ns / 1 ps

module tb_Clock_Divider ();
    reg  iClock_in, inReset, iClk;
    wire oClock_out;

    // Use parameters that allow us to see the division clearly in a short window
    localparam simOldHz = 50; 
    localparam simNewHz = 5;  // 10x slower output
    
    // Instantiate UUT
    Clock_Divider #(simOldHz, simNewHz) UUT (
        .Clock_in(iClock_in), 
        .nReset(inReset), 
        .Clk(iClk), 
        .Clock_out(oClock_out)
    );

    // Clock generator: 10ns period
    initial iClock_in = 1'b0;
    always #5 iClock_in = ~iClock_in;

    initial begin
        // --- PHASE A: INITIAL CONDITION ---
        // nReset = 0 (Output should be idle)
        inReset = 0; iClk = 1; 
        $display("PHASE A: Reset active");
        #100;

        // --- PHASE B: TRIGGER ---
        // nReset = 1 (Divider starts counting)
        inReset = 1;
        $display("PHASE B: Trigger nReset = 1");
        #400;

        // --- PHASE C: RESET PULSE ---
        // nReset = 1 then back to 0 temporarily
        $display("PHASE C: Pulse nReset to 0");
        inReset = 0; #40;
        inReset = 1;
        #200;

        // --- PHASE D: PROLONGED DURATION ---
        // Maintain nReset = 1 to see toggling and mode switching
        $display("PHASE D: Prolonged run");
        
        // Testing the "iClk" mux: Switch to bypass (original clock)
        iClk = 0; 
        #500;
        
        // Switch back to divided clock
        iClk = 1;
        #2000;

        $display("Simulation Finished");
        $stop;
    end
endmodule