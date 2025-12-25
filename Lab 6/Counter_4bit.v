module Counter_4bit (
    input wire          Clk, 
    input wire          nReset, 
    input wire          Load, 
    input wire          Count_en, 
    input wire          Up,
    input wire  [3:0]   Count_in,
    output reg  [3:0]   Count_out
);

    // Internal signal for the next state calculation
    reg [3:0] next_count;

    // Combinational Logic: Determining the next value
    always @(*) begin
        if (Load) begin
            next_count = Count_in;
        end else if (Count_en) begin
            // Using a case statement to handle up/down logic
            case (Up)
                1'b1:    next_count = Count_out + 4'd1;
                1'b0:    next_count = Count_out - 4'd1;
                default: next_count = Count_out;
            endcase
        end else begin
            next_count = Count_out; // Default: Hold current value
        end
    end

    // Sequential Logic: Updating the registers
    always @(negedge Clk or negedge nReset) begin
        if (~nReset) begin
            Count_out <= 4'h0;
        end else begin
            Count_out <= next_count;
        end
    end

endmodule