module Race_Lights_Top (
    input  wire CLOCK_50,    // Physical 50MHz Clock
    input  wire RESET_N,     // Physical Switch (Active Low)
    input  wire START_BTN,   // Physical Button for Start
    output wire [2:0] LEDS   // Mapping: LED[2]=Red, LED[1]=Yellow, LED[0]=Green
);

    wire clk_1hz;
    wire [2:0] debug_state;
    
    // Instantiate Clock Divider (50MHz -> 1Hz)
    Clock_Divider #(
        .oldHz(50_000_000), 
        .newHz(1)
    ) clk_gen (
        .Clock_in(CLOCK_50),
        .nReset(RESET_N),
        .Clk(1'b1),        // Force "Divided" mode
        .Clock_out(clk_1hz)
    );

    // Instantiate Race Lights FSM
    Race_Lights fsm_inst (
        .CLOCK(clk_1hz),   // Driven by 1Hz signal
        .nRESET(RESET_N),
        .START(START_BTN),
        .RED(LEDS[2]),
        .YELLOW(LEDS[1]),
        .GREEN(LEDS[0]),
        .state_out(debug_state)
    );

endmodule