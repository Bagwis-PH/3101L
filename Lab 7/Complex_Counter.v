module Complex_Counter #(
    parameter oldHz = 50_000_000, 
    parameter newHz = 1
)(
    input wire CLOCK,    
    input wire nRESET,   
    input wire M,        
    output reg [2:0] COUNT,
    output wire [2:0] onstate
);

    // Using synthesis attributes to help Quartus "see" the FSM
    (* syn_encoding = "safe" *) reg [2:0] state;
    reg [2:0] next_state;

    assign onstate = next_state; 

    // 1. State Register (Fixed Sensitivity List for Hardware)
    always @(negedge CLOCK or negedge nRESET) begin
        if (!nRESET)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // 2. Next State Logic
    // REPLACED "state + 1" with explicit transitions to force FSM Viewer
    always @(*) begin
        case (M)
            1'b0: begin // BINARY SEQUENCE (Manual transitions)
                case (state)
                    3'b000: next_state = 3'b001;
                    3'b001: next_state = 3'b010;
                    3'b010: next_state = 3'b011;
                    3'b011: next_state = 3'b100;
                    3'b100: next_state = 3'b101;
                    3'b101: next_state = 3'b110;
                    3'b110: next_state = 3'b111;
                    3'b111: next_state = 3'b000; // Wrap around
                    default: next_state = 3'b000;
                endcase
            end
            
            1'b1: begin // GRAY CODE SEQUENCE
                case (state)
                    3'b000: next_state = 3'b001;
                    3'b001: next_state = 3'b011;
                    3'b011: next_state = 3'b010;
                    3'b010: next_state = 3'b110;
                    3'b110: next_state = 3'b111;
                    3'b111: next_state = 3'b101;
                    3'b101: next_state = 3'b100;
                    3'b100: next_state = 3'b000; // Wrap around
                    default: next_state = 3'b000;
                endcase
            end
            
            default: next_state = 3'b000;
        endcase
    end

    always @(*) COUNT = state;

endmodule