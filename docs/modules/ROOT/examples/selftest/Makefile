.PHONY: all clean test test_verilator

export SVJSON_ROOT := $(realpath ../../../../..)
export EXAMPLES_ROOT := $(realpath ..)
export SVUNIT_INSTALL := $(SVJSON_ROOT)/contrib/svunit
export PATH := $(SVUNIT_INSTALL)/bin:$(PATH)

all: test

test: test_verilator

test_verilator:
	runSVUnit \
		-s verilator \
		-l run.log \
		-c "--binary -j $$(nproc) +incdir+$(EXAMPLES_ROOT)" \
		-f $(SVJSON_ROOT)/src/filelist.f \
		-o work_verilator

clean:
	rm -rf work_*
