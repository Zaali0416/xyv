# Simulator setup
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Verilog source files
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
VERILOG_SOURCES += $(WORKSPACE)/src/project.v
VERILOG_SOURCES += $(WORKSPACE)/src/wms_ic_asci.v

# Top module name in simulation
TOPLEVEL = tb

# Python test module name
MODULE = test

# Include Cocotb makefiles
include $(shell cocotb-config --makefiles)/makefile.sim
