module tb_neural_network;
    reg clk;
    reg start;
    reg resetn;
    wire done;

    // Memory addresses for weights and inputs
    wire [15:0] input_addr, weight1_addr, weight2_addr, weight3_addr, weight4_addr;
    
    // Memory data signals
    wire signed [31:0] input_data, weight1_data, weight2_data, weight3_data, weight4_data;
    
    // Separate read/write addresses for each memory module
    wire [15:0] mm1_write_addr, mm1_read_addr;
    wire [15:0] relu1_write_addr, relu1_read_addr;
    wire [15:0] mm2_write_addr, mm2_read_addr;
    wire [15:0] relu2_write_addr, relu2_read_addr;
    wire [15:0] mm3_write_addr, mm3_read_addr;
    wire [15:0] relu3_write_addr, relu3_read_addr;
    wire [15:0] mm4_write_addr, mm4_read_addr;

    // Layer data and memory interfaces
    wire signed [31:0] mm1_data, mm2_data, mm3_data, mm4_data;
    wire signed [31:0] relu1_data, relu2_data, relu3_data, relu4_data;

    wire signed [31:0] mm1_data_out, relu1_data_out;
    wire signed [31:0] mm2_data_out, relu2_data_out;
    wire signed [31:0] mm3_data_out, relu3_data_out;
    wire signed [31:0] mm4_data_out;

    // Write enable signals
    wire write_mm1, write_relu1;
    wire write_mm2, write_relu2;
    wire write_mm3, write_relu3;
    wire write_mm4;

    wire [3:0] argmax_output;

    // Control signals
    reg [3:0] current_state, next_state;
    reg start_mm1, start_mm2, start_mm3, start_mm4;
    reg start_relu1, start_relu2, start_relu3;
    reg start_argmax;

    // Done signals
    wire mm1_done, mm2_done, mm3_done, mm4_done;
    wire relu1_done, relu2_done, relu3_done;
    wire argmax_done;

    // Memory instantiations
    image_memory input_mem(
        .address(input_addr),
        .data_out(input_data)
    );

    matrix1 weight_mem1(
        .address(weight1_addr),
        .data_out(weight1_data)
    );

    matrix2 weight_mem2(
        .address(weight2_addr),
        .data_out(weight2_data)
    );

    matrix3 weight_mem3(
        .address(weight3_addr),
        .data_out(weight3_data)
    );

    matrix4 weight_mem4(
        .address(weight4_addr),
        .data_out(weight4_data)
    );

    mm1_memory mm1_mem(
        .clk(clk),
        .write_addr(mm1_write_addr),
        .read_addr(mm1_read_addr),
        .data_in(mm1_data),
        .write_enable(write_mm1),
        .data_out(mm1_data_out)
    );

    relu1_memory relu1_mem(
        .clk(clk),
        .write_addr(relu1_write_addr),
        .read_addr(relu1_read_addr),
        .data_in(relu1_data),
        .write_enable(write_relu1),
        .data_out(relu1_data_out)
    );

    mm2_memory mm2_mem(
        .clk(clk),
        .write_addr(mm2_write_addr),
        .read_addr(mm2_read_addr),
        .data_in(mm2_data),
        .write_enable(write_mm2),
        .data_out(mm2_data_out)
    );

    relu2_memory relu2_mem(
        .clk(clk),
        .write_addr(relu2_write_addr),
        .read_addr(relu2_read_addr),
        .data_in(relu2_data),
        .write_enable(write_relu2),
        .data_out(relu2_data_out)
    );

    mm3_memory mm3_mem(
        .clk(clk),
        .write_addr(mm3_write_addr),
        .read_addr(mm3_read_addr),
        .data_in(mm3_data),
        .write_enable(write_mm3),
        .data_out(mm3_data_out)
    );

    relu3_memory relu3_mem(
        .clk(clk),
        .write_addr(relu3_write_addr),
        .read_addr(relu3_read_addr),
        .data_in(relu3_data),
        .write_enable(write_relu3),
        .data_out(relu3_data_out)
    );

    mm4_memory mm4_mem(
        .clk(clk),
        .write_addr(mm4_write_addr),
        .read_addr(mm4_read_addr),
        .data_in(mm4_data),
        .write_enable(write_mm4),
        .data_out(mm4_data_out)
    );

    // Neural network components
    matrix_multiply mm1(
        .clk(clk),
        .start(start_mm1),
        .m(10'd1),
        .n(10'd64),
        .k(10'd784),
        .input_addr(input_addr),
        .input_data(input_data),
        .weight_addr(weight1_addr),
        .weight_data(weight1_data),
        .output_addr(mm1_write_addr),
        .output_data(mm1_data),
        .write_enable(write_mm1),
        .done(mm1_done)
    );

    relu relu1(
        .clk(clk),
        .start(start_relu1),
        .d(10'd64),
        .input_addr(mm1_read_addr),
        .input_data(mm1_data_out),
        .output_addr(relu1_write_addr),
        .output_data(relu1_data),
        .write_enable(write_relu1),
        .done(relu1_done)
    );

    matrix_multiply mm2(
        .clk(clk),
        .start(start_mm2),
        .m(10'd1),
        .n(10'd64),
        .k(10'd64),
        .input_addr(relu1_read_addr),
        .input_data(relu1_data_out),
        .weight_addr(weight2_addr),
        .weight_data(weight2_data),
        .output_addr(mm2_write_addr),
        .output_data(mm2_data),
        .write_enable(write_mm2),
        .done(mm2_done)
    );

    relu relu2(
        .clk(clk),
        .start(start_relu2),
        .d(10'd64),
        .input_addr(mm2_read_addr),
        .input_data(mm2_data_out),
        .output_addr(relu2_write_addr),
        .output_data(relu2_data),
        .write_enable(write_relu2),
        .done(relu2_done)
    );

    matrix_multiply mm3(
        .clk(clk),
        .start(start_mm3),
        .m(10'd1),
        .n(10'd32),
        .k(10'd64),
        .input_addr(relu2_read_addr),
        .input_data(relu2_data_out),
        .weight_addr(weight3_addr),
        .weight_data(weight3_data),
        .output_addr(mm3_write_addr),
        .output_data(mm3_data),
        .write_enable(write_mm3),
        .done(mm3_done)
    );

    relu relu3(
        .clk(clk),
        .start(start_relu3),
        .d(10'd32),
        .input_addr(mm3_read_addr),
        .input_data(mm3_data_out),
        .output_addr(relu3_write_addr),
        .output_data(relu3_data),
        .write_enable(write_relu3),
        .done(relu3_done)
    );

    matrix_multiply mm4(
        .clk(clk),
        .start(start_mm4),
        .m(10'd1),
        .n(10'd10),
        .k(10'd32),
        .input_addr(relu3_read_addr),
        .input_data(relu3_data_out),
        .weight_addr(weight4_addr),
        .weight_data(weight4_data),
        .output_addr(mm4_write_addr),
        .output_data(mm4_data),
        .write_enable(write_mm4),
        .done(mm4_done)
    );

    argmax argmax_op(
        .clk(clk),
        .start(start_argmax),
        .size(16'd10),
        .addr(mm4_read_addr),
        .data(mm4_data_out),
        .max_index(argmax_output),
        .done(argmax_done)
    );

    // State definitions
    localparam IDLE = 4'd0;
    localparam LAYER1_MM = 4'd1;
    localparam LAYER1_RELU = 4'd2;
    localparam LAYER2_MM = 4'd3;
    localparam LAYER2_RELU = 4'd4;
    localparam LAYER3_MM = 4'd5;
    localparam LAYER3_RELU = 4'd6;
    localparam LAYER4_MM = 4'd7;
    localparam ARGMAX = 4'd8;
    localparam DONE = 4'd9;

    // State transitions
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // For the output
    assign done = (current_state == DONE);
    
    // Control logic
    always @(*) begin
        start_mm1 = 0;
        start_relu1 = 0;
        start_mm2 = 0;
        start_relu2 = 0;
        start_mm3 = 0;
        start_relu3 = 0;
        start_mm4 = 0;
        start_argmax = 0;

        case (current_state)
            IDLE: begin
                if (start) begin
                    next_state = LAYER1_MM;
                    start_mm1 = 1;
                    start = 0;
                end else begin
                    next_state = IDLE;
                end
            end
            
            LAYER1_MM: begin
                if (mm1_done) begin
                    next_state = LAYER1_RELU;
                    start_relu1 = 1;
                    start_mm1 = 0;
                end else begin
                    next_state = LAYER1_MM;
                end
            end
            
            LAYER1_RELU: begin
                if (relu1_done) begin
                    next_state = LAYER2_MM;
                    start_mm2 = 1;
                end else begin
                    next_state = LAYER1_RELU;
                end
            end
            
            LAYER2_MM: begin
                if (mm2_done) begin
                    next_state = LAYER2_RELU;
                    start_relu2 = 1;
                end else begin
                    next_state = LAYER2_MM;
                end
            end
            
            LAYER2_RELU: begin
                if (relu2_done) begin
                    next_state = LAYER3_MM;
                    start_mm3 = 1;
                end else begin
                    next_state = LAYER2_RELU;
                end
            end
            
            LAYER3_MM: begin
                if (mm3_done) begin
                    next_state = LAYER3_RELU;
                    start_relu3 = 1;
                end else begin
                    next_state = LAYER3_MM;
                end
            end
            
            LAYER3_RELU: begin
                if (relu3_done) begin
                    next_state = LAYER4_MM;
                    start_mm4 = 1;
                end else begin
                    next_state = LAYER3_RELU;
                end
            end
            
            LAYER4_MM: begin
                if (mm4_done) begin
                    next_state = ARGMAX;
                    start_argmax = 1;
                end else begin
                    next_state = LAYER4_MM;
                end
            end
            
            ARGMAX: begin
                if (argmax_done) begin
                    next_state = DONE;
                end else begin
                    next_state = ARGMAX;
                end
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    initial begin
        clk = 0;
        resetn = 0;  // Start with reset active (low)
        start = 0;
        
        // Reset sequence
        #20 resetn = 1;  // Release reset by bringing it high
        #30 start = 1;  // Start the operation
        $display("Simulation started.");
        #40 start = 0;

        @(posedge done);
        $display("Simulation completed.");
        $display("\nPredicted class: %0d", argmax_output);
        
        #100 $finish;
    end

    // Clock generation
    always #10 clk = ~clk;

endmodule