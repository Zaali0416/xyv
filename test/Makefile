SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Pass SIMULATION macro to enable fast debouncer bypass during testing
COMPILE_ARGS += -DSIMULATION

# Source paths
VERILOG_SOURCES += $(PWD)/../src/project.v
VERILOG_SOURCES += $(PWD)/../src/wms_ic_asic_system.v

TOPLEVEL = tb
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim
