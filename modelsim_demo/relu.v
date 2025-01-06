module relu(
    input wire clk,
    input wire start,
    input wire [9:0] d, // Size of input array
    output reg [15:0] input_addr,
    input wire signed [31:0] input_data,
    output reg [15:0] output_addr,
    output reg signed [31:0] output_data,
    output reg write_enable,
    output reg done
);

    localparam IDLE = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam FINISH = 2'b10;

    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [9:0] i;
    reg wait_cycle;
    reg final_store_done;

    always @(posedge clk) begin
        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? COMPUTE : IDLE;
            COMPUTE: next_state = final_store_done ? FINISH : COMPUTE;
            FINISH: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                if (start) begin
                    i <= 0;
                    done <= 0;
                    final_store_done <= 0;
                    write_enable <= 0;
                    wait_cycle <= 1;
                    input_addr <= 0;
                    output_addr <= 0;
                    $display("\nStarting ReLU operation...");
                end
            end

            COMPUTE: begin
                write_enable <= 0;
                
                if (wait_cycle) begin
                    wait_cycle <= 0;
                end else begin
                    output_addr <= i;
                    output_data <= (input_data[31]) ? 32'h0 : input_data; // Check sign bit
                    write_enable <= 1;

                    if (i == d-1) begin
                        final_store_done <= 1;
                    end else begin
                        i <= i + 1;
                        input_addr <= i + 1;
                        wait_cycle <= 1;
                    end
                end
            end

            FINISH: begin
                done <= 1;
                write_enable <= 0;
                $display("\nFinished ReLU operation...");
            end
        endcase
    end
endmodule