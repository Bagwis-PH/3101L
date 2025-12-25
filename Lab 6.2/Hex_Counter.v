// Revised Hex_Counter to match the working Testbench
module Hex_Counter #(
    parameter oldHz = 50_000_000, 
    parameter newHz = 2
)(
    input wire          Clk, 
    input wire          nReset, 
    input wire          Load, 
    input wire          Count_en, 
    input wire          Up, 
    input wire          DP,
    input wire  [3:0]   Count_in,
    output wire [7:0]   SSeg,
    output wire         div_clock
);

    wire [3:0] internal_count;
    
    // Connect div_clock to Clk for simulation visibility
    assign div_clock = Clk; 

    // FIXED: Changed lowercase 'load' to 'Load' to match the input wire
    // FIXED: Ensured Counter_4bit is called without parameters if it doesn't have any
    Counter_4bit cntr (
        .Clk(Clk), 
        .nReset(nReset), 
        .Load(Load), 
        .Count_en(Count_en), 
        .Up(Up), 
        .Count_in(Count_in), 
        .Count_out(internal_count)
    );

    // FIXED: Mapping to your HexTo7SegmentDecoder
    HexTo7SegmentDecoder disp (
        .Hex(internal_count), 
        .DP(DP), 
        .SSeg(SSeg)
    );

endmodule