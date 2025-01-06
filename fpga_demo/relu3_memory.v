module relu3_memory (
    input wire clk,
    input wire [15:0] write_addr,    // Address for writing
    input wire [15:0] read_addr,     // Address for reading
    input wire signed [31:0] data_in,
    input wire write_enable,
    output reg signed [31:0] data_out
);
    reg signed [31:0] memory [0:63];  // 1x64 output

    // Read operation (getter)
    always @(*) begin
        data_out = memory[read_addr];
        if (read_addr < 64) begin  // Debug for read
            // $display("RELU1_MEM Time=%0t Reading addr=%d, data=%h", $time, read_addr, data_out);
        end
    end

    // Write operation (setter)
    always @(posedge clk) begin
        if (write_enable && write_addr < 64) begin
            memory[write_addr] = data_in;
            // $display("RELU1_MEM Time=%0t Writing addr=%d, data=%h", $time, write_addr, data_in);
        end
    end
endmodule