module argmax (
    input wire clk,                  // Clock signal
    input wire resetn,              // Active-low reset signal
    input wire start,                // Start signal to trigger the operation
    input wire [15:0] size,          // Size of the data (number of elements)
    input wire signed [31:0] data,   // Data input for each address
    output reg [15:0] addr,          // Output address pointer
    output reg [3:0] max_index,      // Output max index
    output reg done                  // Done signal when operation is complete
);
    reg signed [31:0] max_value;     // To store the max value
    reg [3:0] current_max_index;     // To store the index of the max value
    reg running;                     // Indicates whether the operation is running

    // Always block with reset functionality
    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin  // Reset when resetn is low (active-low reset)
            addr <= 0;                             // Reset address pointer
            max_value <= 32'h80000000;             // Initialize max_value to a very low value
            current_max_index <= 0;               // Reset current max index
            max_index <= 4'b1010;                  // Reset max_index to 0
            running <= 0;                          // Reset running flag
            done <= 0;                             // Reset done flag
            $display("\nTime=%0t: Argmax operation reset", $time);
        
        end else if (start) begin
            // Initialize the operation when the start signal is asserted
            addr <= 0;                             // Reset address to start from 0
            max_value <= 32'h80000000;             // Initialize max_value to a very low number
            current_max_index <= 0;               // Reset the current max index
            running <= 1;                          // Start the operation
            done <= 0;                             // Reset done flag
            // max_index <= 4'b1010;                  // Reset max_index to 0 at start
            // $display("\nTime=%0t: Starting argmax operation...", $time);
            // $display("Initialized max_value to %0d", max_value);
        end else if (running) begin
            // If the operation is running, check data values and find the max
            if (addr < size) begin
                $display("\nTime=%0t: Checking address %0d", $time, addr);
                $display("Current value at addr %0d = %0d", addr, data);
                $display("Current max_value = %0d at index %0d", max_value, current_max_index);
                
                if (data > max_value) begin
                    // Update max_value and max_index when a larger value is found
                    $display("New maximum found!");
                    $display("Updating max_value from %0d to %0d", max_value, data);
                    $display("Updating max_index from %0d to %0d", current_max_index, addr[3:0]);
                    max_value <= data;
                    current_max_index <= addr[3:0];
                end

                addr <= addr + 1;  // Move to the next address
            end else begin
                // Operation complete: output the final result
                max_index <= current_max_index;
                running <= 0;  // Stop running
                done <= 1;     // Set done flag
                $display("\nTime=%0t: Argmax operation complete", $time);
                $display("Final max_value = %0d at index %0d", max_value, current_max_index);
            end
        end
    end
endmodule
