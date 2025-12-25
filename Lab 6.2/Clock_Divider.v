module Clock_Divider #(
    parameter oldHz = 50_000_000, 
    parameter newHz = 2
)(
    input  wire Clock_in,
    input  wire nReset,
    input  wire Clk,          // Select signal: 0 = Bypass, 1 = Divided
    output reg  Clock_out
);

    // Calculate terminal count for toggle
    localparam integer TERMINAL_COUNT = (oldHz / (newHz * 2)) - 1;
    localparam integer WIDTH = $clog2(TERMINAL_COUNT + 1);

    reg [WIDTH-1:0] cntr;
    reg divided_clock;

    // Counter and Divided Clock Generation
    always @(posedge Clock_in or negedge nReset) begin
        if (!nReset) begin
            cntr <= {WIDTH{1'b0}};
            divided_clock <= 1'b0;
        end else if (cntr >= TERMINAL_COUNT) begin
            cntr <= {WIDTH{1'b0}};
            divided_clock <= ~divided_clock;
        end else begin
            cntr <= cntr + 1'b1;
        end
    end

    // Clock Selection Mux (Synchronous output to avoid glitches)
    always @(*) begin
        Clock_out = (Clk) ? divided_clock : Clock_in;
    end

endmodule