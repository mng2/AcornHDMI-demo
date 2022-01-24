# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# derived from cocotb/examples/matrix_multiplier/tests

TOPLEVEL_LANG ?= verilog
SIM ?= icarus

PWD=$(shell pwd)

ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES = $(PWD)/../src/pkg_dvi.sv $(PWD)/tb_tmds_roundtrip.sv

    ifneq ($(filter $(SIM),riviera activehdl),)
        COMPILE_ARGS += -sv2k12
    endif

else ifeq ($(TOPLEVEL_LANG),vhdl)
    $(error "VHDL is not supported for this test")
else
    $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif

# Fix the seed to ensure deterministic tests
export RANDOM_SEED := 123456789

TOPLEVEL    := tb_tmds_roundtrip
MODULE      := test_pkg_dvi

include $(shell cocotb-config --makefiles)/Makefile.sim


# Profiling

DOT_BINARY ?= dot

test_profile.pstat: sim

callgraph.svg: test_profile.pstat
	$(shell cocotb-config --python-bin) -m gprof2dot -f pstats ./$< | $(DOT_BINARY) -Tsvg -o $@

.PHONY: profile
profile:
	COCOTB_ENABLE_PROFILING=1 $(MAKE) callgraph.svg
