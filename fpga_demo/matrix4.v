module matrix4 (
    input wire [15:0] address,
    output reg signed [31:0] data_out
);
    reg signed [31:0] memory [0:319];  // 32-bit values

    initial begin
        $readmemh("mem/matrix4.mif", memory);
        //if ($test$plusargs("DEBUG")) begin
        //     $display("Weight matrix 4 memory file successfully loaded.");
        // end
    end

    always @(address) begin
        data_out = memory[address];
    end
endmodule