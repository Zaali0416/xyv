SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Pass SIMULATION macro to enable fast debouncer bypass during testing
COMPILE_ARGS += -DSIMULATION

# Direct relative paths to source files
VERILOG_SOURCES += $(PWD)/../src/project.v
VERILOG_SOURCES += $(PWD)/../src/wms_ic_asic_system.v

TOPLEVEL = tb
MODULE = test

include $(shell cocotb-config --makefiles)/makefile.sim
