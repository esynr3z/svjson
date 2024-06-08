.PHONY: all lint lint_verilator test test_src test_examples

export SVJSON_ROOT := $(realpath .)

all: lint test

lint: lint_verilator

# VARHIDDEN - too strict, method arguments may overlap with class property names
# UNDRIVEN - has false positives on interface classes and custom constructors
lint_verilator:
	@echo "Lint sources with Verilator"
	verilator --lint-only -f $(SVJSON_ROOT)/src/filelist.f \
	-Wall -Wno-VARHIDDEN -Wno-UNDRIVEN

test: test_src test_examples

test_src:
	@echo "Run tests for main sources"
	make -C tests test

test_examples:
	@echo "Run tests for documentation example snippets"
	make -C docs/modules/ROOT/examples/selftest test

clean:
	make -C tests clean
	make -C docs/modules/ROOT/examples/selftest clean
