// Christian Jay Y. Gallardo
// Lorenz Anthony L. Soriano

module VMC(
    input              MAX10_CLK1_50, 
    input        [1:0] KEY,           // KEY[0] = nRESET (Asynchronous Active Low)
    input        [9:0] SW,            // SW[0]:START, SW[1]:SELECT, SW[2]:OK, SW[3]:CANCEL
                                      // SW[4]:Php1, SW[5]:Php5, SW[6]:Php10
    output reg   [9:0] LEDR,          // ITEM indicators & Actuator feedback
    output reg         DISPENSE,      // DISPENSE actuator
    output reg         C1, C5, C10,   // Change actuators
    output       [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output       [5:0] HEX_DP         // Decimal point control
);

    // Timing and clock Divider
    reg [24:0] clk_divider;
    
    // Logic to switch between real hardware clock and fast simulation clock
    `ifdef SIMULATION_MODE
        wire slow_clk = MAX10_CLK1_50;
    `else
        wire slow_clk = clk_divider[23];
    `endif

    always @(negedge MAX10_CLK1_50) clk_divider <= clk_divider + 1;

    // State Definitions
    parameter IDLE = 3'b000, SEL = 3'b001, PAY = 3'b010, VEND = 3'b011, CHANGE = 3'b100;
    reg [2:0] state;

    reg [7:0] balance, price;
    reg [1:0] item_select;

    // Synchronous Display Logic
    wire [3:0] bal_tens = balance / 10;
    wire [3:0] bal_ones = balance % 10;
    wire [3:0] prc_tens = price / 10;
    wire [3:0] prc_ones = price % 10;

    seven_seg_decoder h0 (bal_ones, HEX0);
    seven_seg_decoder h1 (bal_tens, HEX1);
    seven_seg_decoder h4 (prc_ones, HEX4);
    seven_seg_decoder h5 (prc_tens, HEX5);
    assign {HEX2, HEX3} = 14'h3FFF; // Turn off unused digits
    assign HEX_DP = 6'b111111;      // Decimal point control

    // FSM Logic (Negative-Edged Clock)
    always @(negedge slow_clk or negedge KEY[0]) begin
        if (!KEY[0]) begin // Asynchronous Active Low Reset
            state <= IDLE;
            balance <= 0;
            price <= 0;
            item_select <= 0;
            {DISPENSE, C1, C5, C10} <= 4'b0000;
            LEDR <= 10'b0;
        end 
        else if (SW[3]) begin // Synchronous CANCEL
            if (state == PAY || state == VEND) state <= CHANGE;
            else state <= IDLE;
        end 
        else begin
            // Default outputs
            {DISPENSE, C1, C5, C10} <= 4'b0000;
            LEDR <= 10'b0;

            case (state)
                IDLE: begin
                    if (SW[0]) state <= SEL;
                    balance <= 0;
                    price <= 0;
                end

                SEL: begin
                    LEDR[item_select] <= 1'b1;
                    case(item_select)
                        0: price <= 3;   // Php 3.00
                        1: price <= 5;   // Php 5.00
                        2: price <= 12;  // Php 12.00
                    endcase

                    if (SW[1]) item_select <= (item_select + 1) % 3;
                    if (SW[2]) state <= PAY;
                end

                PAY: begin
                    LEDR[item_select] <= 1'b1;

                    if (balance < price) begin // Payment Rejection logic
                        if (SW[4]) balance <= balance + 1;
                        if (SW[5]) balance <= balance + 5;
                        if (SW[6]) balance <= balance + 10;
                    end

                    if (balance >= price && SW[2]) state <= VEND;
                end

                VEND: begin
                    DISPENSE <= 1'b1;
                    LEDR[9] <= 1'b1;
                    balance <= balance - price;
                    state <= CHANGE;
                end

                CHANGE: begin
                    if (balance >= 10) begin 
                        C10 <= 1; LEDR[7] <= 1; balance <= balance - 10;
                    end
                    else if (balance >= 5) begin 
                        C5 <= 1;  LEDR[6] <= 1; balance <= balance - 5;
                    end
                    else if (balance >= 1) begin 
                        C1 <= 1;  LEDR[5] <= 1; balance <= balance - 1;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule

// Segment Decoder
module seven_seg_decoder(input [3:0] bin, output reg [6:0] seg);
    always @(*) begin
        case(bin)
            4'h0: seg = 7'b1000000; 4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100; 4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001; 4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010; 4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000; 4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end
endmodule