module ComplexCounter_Top (
    input  wire       CLOCK_50,    // Physical PIN_P11
    input  wire       RESET_N,     // Physical PIN_B8 (Active Low)
    input  wire       MODE_M,      // Physical PIN_C10 (Binary/Gray select)
    input  wire       SEL_CLK,     // Physical PIN_C11 (Bypass/Divided select)
    output wire [2:0] COUNT_LEDS   // Physical LEDR0, LEDR1, LEDR2
);

    // Internal net to carry the divided clock signal
    wire manual_clk;

    // 1. Instantiate the Clock Divider
    // This reduces the 50MHz frequency to 2Hz (human readable)
    Clock_Divider #(
        .oldHz(50_000_000), 
        .newHz(2)
    ) clk_unit (
        .Clock_in(CLOCK_50),
        .nReset(RESET_N),
        .Clk(SEL_CLK),
        .Clock_out(manual_clk)
    );

    // 2. Instantiate the Moore FSM (Complex Counter)
    // We connect the divider's output to the FSM's clock input
    Complex_Counter counter_unit (
        .CLOCK(manual_clk),   // Driven by the divider
        .nRESET(RESET_N),
        .M(MODE_M),
        .COUNT(COUNT_LEDS)
    );

endmodule