module Traffic_Light_Controller (
    input clk,         
    input rst,         
    output reg [2:0] NS, 
    output reg [2:0] EW  
);

    
    typedef enum logic [1:0] {
        S0 = 2'b00,  // NS Green, EW Red
        S1 = 2'b01,  // NS Yellow, EW Red
        S2 = 2'b10,  // NS Red, EW Green
        S3 = 2'b11   // NS Red, EW Yellow
    } state_t;
    
    state_t current_state, next_state;
    integer counter;

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S0;
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter >= 5) begin  // Change state every 5 clock cycles
                counter <= 0;
                current_state <= next_state;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Assigning light signals)
    always @(*) begin
        case (current_state)
            S0: begin NS = 3'b001; EW = 3'b100; end // NS Green, EW Red
            S1: begin NS = 3'b010; EW = 3'b100; end // NS Yellow, EW Red
            S2: begin NS = 3'b100; EW = 3'b001; end // NS Red, EW Green
            S3: begin NS = 3'b100; EW = 3'b010; end // NS Red, EW Yellow
            default: begin NS = 3'b100; EW = 3'b100; end // Default: Red for safety
        endcase
    end

endmodule
