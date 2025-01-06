
#verilator needs this to run
export VERILATOR_ROOT := verilator

#catch all verilog and system verilog files up to 2 folders deep
# SOURCES := $(wildcard *.sv */*.sv */*/*.sv)
SOURCES += $(wildcard *.v)

#ignore the verilog files internal to verilator
SOURCES := $(filter-out verilator/include/verilated_std.sv verilator/include/verilated.v, $(SOURCES))

check:
	@verilator\bin\verilator_bin.exe --lint-only -Wno-DECLFILENAME --no-timing -Wno-WIDTHTRUNC -Wno-EOFNEWLINE $(SOURCES)

