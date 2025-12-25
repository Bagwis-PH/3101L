module Race_Lights (
    input  wire CLOCK,      // 1Hz Clock (Negative Edge Triggered)
    input  wire nRESET,     // Asynchronous Active Low Reset
    input  wire START,      // Start Signal
    output reg  RED,        // Red Light Output
    output reg  YELLOW,     // Yellow Light Output
    output reg  GREEN,      // Green Light Output
    output wire [2:0] state_out // For simulation visibility
);

    // State Encoding
    localparam S_IDLE       = 3'b000; // Red ON, waiting for Start
    localparam S_RED_HOLD   = 3'b001; // Red ON, 1 sec delay
    localparam S_YELLOW     = 3'b010; // Yellow ON, 1 sec
    localparam S_GREEN_1    = 3'b011; // Green ON, 1st sec
    localparam S_GREEN_2    = 3'b100; // Green ON, 2nd sec
    localparam S_GREEN_3    = 3'b101; // Green ON, 3rd sec

    reg [2:0] state, next_state;

    // Output the state for Testbench/Waveform visibility
    assign state_out = state;

    // 1. Sequential Logic: State Register
    // Specification asks for Negative Edge Clock and Asynchronous Reset
    always @(negedge CLOCK or negedge nRESET) begin
        if (!nRESET)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // 2. Combinational Logic: Next State Logic
    always @(*) begin
        case (state)
            S_IDLE: begin
                // Wait for START=1 to move. Otherwise stay in IDLE.
                if (START) next_state = S_RED_HOLD;
                else       next_state = S_IDLE;
            end

            S_RED_HOLD: next_state = S_YELLOW;   // After 1 sec, go Yellow
            S_YELLOW:   next_state = S_GREEN_1;  // After 1 sec, go Green
            S_GREEN_1:  next_state = S_GREEN_2;  // Green holds...
            S_GREEN_2:  next_state = S_GREEN_3;  // Green holds...
            S_GREEN_3:  next_state = S_IDLE;     // After 3rd sec, Reset to Red

            default:    next_state = S_IDLE;
        endcase
    end

    // 3. Output Logic (Mealy/Moore Hybrid for Stability)
    // "Outputs determine which light would be on"
    always @(*) begin
        // Defaults
        RED = 0; YELLOW = 0; GREEN = 0;

        case (state)
            S_IDLE, S_RED_HOLD: RED = 1;      // Red is on for both IDLE and the 1s Hold
            S_YELLOW:           YELLOW = 1;
            S_GREEN_1, S_GREEN_2, S_GREEN_3: GREEN = 1;
            default:            RED = 1;      // Safe default
        endcase
    end

endmodule