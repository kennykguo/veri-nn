# Cleanup previous simulation
quit -sim
if {[file exists work]} {
    vdel -lib work -all
}

# Create work library
vlib work
vmap work work

# Compile all Verilog files
vlog ../tb_neural_network.v
vlog ../matrix_multiply.v
vlog ../relu.v
vlog ../matrix1.v
vlog ../matrix2.v
vlog ../matrix3.v
vlog ../matrix4.v
vlog ../mm1_memory.v
vlog ../mm2_memory.v
vlog ../mm3_memory.v
vlog ../mm4_memory.v
vlog ../relu1_memory.v
vlog ../relu2_memory.v
vlog ../relu3_memory.v
vlog ../image_memory.v
vlog ../argmax.v

# Start simulation
vsim -t 1ps work.tb_neural_network

# Add image visualization (simplified approach)
add wave -noupdate -divider "MNIST Image Visualization"
add wave -position end -radix binary /tb_neural_network/input_mem/memory

# Add your existing waves
add wave -noupdate -divider "Control Signals"
add wave -position insertpoint -radix unsigned /tb_neural_network/current_state
add wave -position insertpoint -radix unsigned /tb_neural_network/next_state
add wave -position insertpoint -radix binary /tb_neural_network/start
add wave -position insertpoint -radix binary /tb_neural_network/done

add wave -noupdate -divider "Layer Control Signals"
add wave -position insertpoint -radix binary /tb_neural_network/start_mm1
add wave -position insertpoint -radix binary /tb_neural_network/mm1_done
add wave -position insertpoint -radix binary /tb_neural_network/start_relu1
add wave -position insertpoint -radix binary /tb_neural_network/relu1_done
add wave -position insertpoint -radix binary /tb_neural_network/start_mm2
add wave -position insertpoint -radix binary /tb_neural_network/mm2_done
add wave -position insertpoint -radix binary /tb_neural_network/start_relu2
add wave -position insertpoint -radix binary /tb_neural_network/relu2_done
add wave -position insertpoint -radix binary /tb_neural_network/start_mm3
add wave -position insertpoint -radix binary /tb_neural_network/mm3_done
add wave -position insertpoint -radix binary /tb_neural_network/start_relu3
add wave -position insertpoint -radix binary /tb_neural_network/relu3_done
add wave -position insertpoint -radix binary /tb_neural_network/start_mm4
add wave -position insertpoint -radix binary /tb_neural_network/mm4_done

add wave -noupdate -divider "Addresses"
add wave -position insertpoint -radix unsigned /tb_neural_network/input_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/weight1_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/weight2_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/weight3_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/weight4_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/mm1_write_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/mm1_read_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/relu1_write_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/relu1_read_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/mm2_write_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/mm2_read_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/relu2_write_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/relu2_read_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/mm3_write_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/mm3_read_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/relu3_write_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/relu3_read_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/mm4_write_addr
add wave -position insertpoint -radix unsigned /tb_neural_network/mm4_read_addr

add wave -noupdate -divider "Data Signals"
add wave -position insertpoint -radix hexadecimal /tb_neural_network/input_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/weight1_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/weight2_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/weight3_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/weight4_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm1_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm1_data_out
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu1_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu1_data_out
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm2_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm2_data_out
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu2_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu2_data_out
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm3_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm3_data_out
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu3_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu3_data_out
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm4_data
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm4_data_out

add wave -noupdate -divider "Memory Write Enable Signals"
add wave -position insertpoint -radix binary /tb_neural_network/write_mm1
add wave -position insertpoint -radix binary /tb_neural_network/write_relu1
add wave -position insertpoint -radix binary /tb_neural_network/write_mm2
add wave -position insertpoint -radix binary /tb_neural_network/write_relu2
add wave -position insertpoint -radix binary /tb_neural_network/write_mm3
add wave -position insertpoint -radix binary /tb_neural_network/write_relu3
add wave -position insertpoint -radix binary /tb_neural_network/write_mm4

add wave -noupdate -divider "Memory Contents"
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm1_mem/memory
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu1_mem/memory
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm2_mem/memory
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu2_mem/memory
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm3_mem/memory
add wave -position insertpoint -radix hexadecimal /tb_neural_network/relu3_mem/memory
add wave -position insertpoint -radix hexadecimal /tb_neural_network/mm4_mem/memory

add wave -noupdate -divider "Argmax"
add wave -position insertpoint -radix binary /tb_neural_network/start_argmax
add wave -position insertpoint -radix binary /tb_neural_network/argmax_done
add wave -position insertpoint -radix unsigned /tb_neural_network/argmax_output

# Configure wave window
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

# Add image display procedure
proc display_image_memory {} {
    puts "\nMNIST Image Visualization:"
    puts "------------------------"
    for {set row 0} {$row < 28} {incr row} {
        set line ""
        for {set col 0} {$col < 28} {incr col} {
            set addr [expr {$row * 28 + $col}]
            set value [examine -radix binary /tb_neural_network/input_mem/memory($addr)]
            if {$value == 1} {
                append line "xx"
            } else {
                append line "  "
            }
        }
        puts $line
    }
    puts "------------------------"
}

# Window button for refreshing display
# button .refresh -text "Refresh Image View" -command display_image_memory
# pack .refresh

# Run simulation and display initial image
run -all
display_image_memory

# Zoom wave window to show everything
wave zoom full