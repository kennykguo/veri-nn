module image_memory (
    input wire [15:0] address,
    output reg [31:0] data_out
);
    reg signed [31:0] memory [0:783];  // 32-bit values

    initial begin
        $readmemh("image.mif", memory);
        if ($test$plusargs("DEBUG")) begin
            $display("Image memory file successfully loaded.");
        end
    end

    always @(address) begin
        data_out = memory[address];
    end
endmodule