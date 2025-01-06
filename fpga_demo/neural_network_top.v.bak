module neural_network_top (
    input wire CLOCK_50,
    input wire KEY1, // Start signal
    output reg [9:0] LEDR, // 10 LEDs for states
    output reg [6:0] HEX0 // HEX display for the output digit
);
    // Internal signals
    reg start;
    wire done;
    wire [3:0] argmax_output;

    // Instantiate the neural network
    tb_neural_network nn (
        .clk(CLOCK_50),
        .start(start),
        .done(done),
        .argmax_output(argmax_output)
    );

    // State management
    localparam IDLE = 4'd0;
    localparam RUNNING = 4'd1;
    localparam COMPLETED = 4'd2;

    reg [3:0] current_state, next_state;

    always @(posedge CLOCK_50 or negedge KEY1) begin
        if (!KEY1) begin
            current_state <= IDLE; // Reset to IDLE on KEY1 press
            start <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                LEDR = 10'b0000000001; // Indicate IDLE
                if (KEY1) begin
                    start = 1;
                    next_state = RUNNING;
                end else begin
                    next_state = IDLE;
                end
            end
            RUNNING: begin
                LEDR = 10'b0000000010; // Indicate RUNNING
                start = 1;
                if (done) begin
                    next_state = COMPLETED;
                end else begin
                    next_state = RUNNING;
                end
            end
            COMPLETED: begin
                LEDR = 10'b0000000100; // Indicate COMPLETED
                start = 0;
                // Convert argmax_output to HEX0 display
                HEX0 = ~digit_to_hex(argmax_output);
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Function to convert 4-bit output to 7-segment HEX display
    function [6:0] digit_to_hex(input [3:0] digit);
        case (digit)
            4'd0: digit_to_hex = 7'b0111111; // 0
            4'd1: digit_to_hex = 7'b0000110; // 1
            4'd2: digit_to_hex = 7'b1011011; // 2
            4'd3: digit_to_hex = 7'b1001111; // 3
            4'd4: digit_to_hex = 7'b1100110; // 4
            4'd5: digit_to_hex = 7'b1101101; // 5
            4'd6: digit_to_hex = 7'b1111101; // 6
            4'd7: digit_to_hex = 7'b0000111; // 7
            4'd8: digit_to_hex = 7'b1111111; // 8
            4'd9: digit_to_hex = 7'b1101111; // 9
            default: digit_to_hex = 7'b0000000; // Blank
        endcase
    endfunction
endmodule