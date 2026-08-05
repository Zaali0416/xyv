SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
VERILOG_SOURCES += $(WORKSPACE)/src/project.v
VERILOG_SOURCES += $(WORKSPACE)/src/wms_ic_asic_system.v

TOPLEVEL = tb
MODULE = test

include $(shell cocotb-config --makefiles)/makefile.sim
