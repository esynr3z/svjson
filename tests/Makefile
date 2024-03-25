.PHONY: all clean test

extra_args ?=

export SV_JSON_ROOT := $(realpath ..)
export SVUNIT_INSTALL := $(SV_JSON_ROOT)/contrib/svunit
export JSON_TEST_SUITE_INSTALL := $(SV_JSON_ROOT)/contrib/json_test_suite
export PATH := $(SVUNIT_INSTALL)/bin:$(PATH)

all: test

test:
	runSVUnit \
		-s verilator \
		-l run.log \
		-c "--binary -j $$(nproc) +define+JSON_TEST_SUITE_INSTALL=$(JSON_TEST_SUITE_INSTALL)" \
		-f $(SV_JSON_ROOT)/src/filelist.f \
		-f $(SV_JSON_ROOT)/tests/filelist.f \
		$(extra_args) \
		-o work

clean:
	rm -rf work