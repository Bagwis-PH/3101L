module JK_FF (
    input  wire j_in,
    input  wire k_in,
    input  wire rst_high,
    input  wire clk_signal,
    output reg  q_out,
    output wire q_not
);

    // Continuous assignment for the inverted output
    assign q_not = ~q_out;

    // Sequential logic triggered on falling clock edge or rising reset
    always @(negedge clk_signal or posedge rst_high) begin
        if (rst_high) begin
            q_out <= 1'b0; // Asynchronous reset
        end else begin
            // Using a truth-table approach for the JK logic
            case ({j_in, k_in})
                2'b01:   q_out <= 1'b0;      // Reset state
                2'b10:   q_out <= 1'b1;      // Set state
                2'b11:   q_out <= ~q_out;    // Toggle state
                2'b00:   q_out <= q_out;     // Hold state
                default: q_out <= q_out;
            endcase
        end
    end

endmodule
