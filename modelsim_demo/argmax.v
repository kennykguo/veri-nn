module argmax (
    input wire clk,
    input wire start,
    input wire [15:0] size,          
    output reg [15:0] addr,          
    input wire signed [31:0] data,   
    output reg [3:0] max_index,      
    output reg done
);
    reg signed [31:0] max_value;     
    reg [3:0] current_max_index;
    reg running;

    always @(posedge clk) begin
        if (start) begin
            addr <= 0;
            max_value <= 32'h80000000;  
            current_max_index <= 0;
            running <= 1;
            done <= 0;
            $display("\nStarting argmax operation...");
            $display("Time=%0t: Initialized max_value to %0d", $time, 32'h80000000);
        end
        else if (running) begin
            if (addr < size) begin
                $display("\nTime=%0t: Checking address %0d", $time, addr);
                $display("Current value at addr %0d = %0d", addr, data);
                $display("Current max_value = %0d at index %0d", max_value, current_max_index);
                
                if (data > max_value) begin
                    $display("New maximum found!");
                    $display("Updating max_value from %0d to %0d", max_value, data);
                    $display("Updating max_index from %0d to %0d", current_max_index, addr[3:0]);
                    max_value <= data;
                    current_max_index <= addr[3:0];
                end

                addr <= addr + 1;
            end
            else begin
                max_index <= current_max_index;
                running <= 0;
                done <= 1;
                $display("\nTime=%0t: Argmax operation complete", $time);
                $display("Final max_value = %0d at index %0d", max_value, current_max_index);
            end
        end
    end

endmodule