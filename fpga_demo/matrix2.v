module matrix2 (
    input wire [15:0] address,
    output reg signed [31:0] data_out
);
    reg signed [31:0] memory [0:4095];  // 32-bit values

    initial begin
        $readmemh("mem/matrix2.mif", memory);
    end

    always @(address) begin
        data_out = memory[address];
    end
endmodule