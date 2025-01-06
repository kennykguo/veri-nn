module clock_divider (
    input clk_in,
    output reg clk_out,
    input [31:0] DIVISOR
);
    reg [31:0] counter;
    
    always @(posedge clk_in) begin
        if (counter >= DIVISOR-1) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule