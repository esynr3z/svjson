include scripts/common.mk

.PHONY: all \
	lint lint_verilator lint_modelsim lint_vcs lint_xcelium \
	test test_src test_examples

export SVJSON_ROOT := $(realpath .)

all: lint test

lint: lint_verilator lint_modelsim lint_vcs lint_xcelium

# VARHIDDEN - too strict, method arguments may overlap with class property names
# UNDRIVEN - has false positives on interface classes and custom constructors
lint_verilator:
	@echo "Lint sources with Verilator"
	verilator --lint-only -f $(SVJSON_ROOT)/src/filelist.f \
	-Wall -Wno-VARHIDDEN -Wno-UNDRIVEN

lint_modelsim:
	@echo "Lint sources with Modelsim"
	$(call run_if_exist,vsim, \
		mkdir -p work_lint_modelsim && \
		cd work_lint_modelsim && \
		vlib work && \
		vlog -l log.txt -sv -warning error -f $(SVJSON_ROOT)/src/filelist.f \
	)

lint_vcs:
	@echo "Lint sources with VCS"
	$(call run_if_exist,vcs, \
		mkdir -p work_lint_vcs && \
		cd work_lint_vcs && \
		vcs -full64 -sverilog -l log.txt +lint=all -error=all \
			-f $(SVJSON_ROOT)/src/filelist.f \
	)

lint_xcelium:
	@echo "Lint sources with Xcelium"
	$(call run_if_exist,xrun, \
		mkdir -p work_lint_xrun && \
		cd work_lint_xrun && \
		xrun -64bit -clean -elaborate -disable_sem2009 -l log.txt -sv -xmallerror \
			-f $(SVJSON_ROOT)/src/filelist.f \
	)

test: test_src test_examples

test_src:
	@echo "Run tests for main sources"
	make -C tests test

test_examples:
	@echo "Run tests for documentation example snippets"
	make -C docs/modules/ROOT/examples/selftest test

clean:
	rm -rf work_*
	make -C tests clean
	make -C docs/modules/ROOT/examples/selftest clean
