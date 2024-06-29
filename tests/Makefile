include ../scripts/common.mk

.PHONY: all clean test test_verilator test_modelsim test_vcs

extra_args ?=

export SVJSON_ROOT := $(realpath ..)
export SVUNIT_INSTALL := $(SVJSON_ROOT)/contrib/svunit
export JSON_TEST_SUITE_INSTALL := $(SVJSON_ROOT)/contrib/json_test_suite
export GOLDEN_JSON_DIR := $(SVJSON_ROOT)/tests/golden_json
export PATH := $(SVUNIT_INSTALL)/bin:$(PATH)

all: test

test: test_verilator test_modelsim test_vcs

test_verilator:
	@echo Test sources with Verilator
	runSVUnit \
		-s verilator \
		-l run.log \
		-c "--binary -j $$(nproc) \
			+define+JSON_TEST_SUITE_INSTALL=$(JSON_TEST_SUITE_INSTALL) \
			+define+GOLDEN_JSON_DIR=$(GOLDEN_JSON_DIR)" \
		-f $(SVJSON_ROOT)/src/filelist.f \
		-f $(SVJSON_ROOT)/tests/filelist.f \
		$(extra_args) \
		-o work_verilator

test_modelsim:
	@echo Test sources with Modelsim
	$(call run_if_exist,vsim, \
		runSVUnit \
			-s modelsim \
			-l run.log \
			-c "-sv \
				+define+JSON_TEST_SUITE_INSTALL=$(JSON_TEST_SUITE_INSTALL) \
				+define+GOLDEN_JSON_DIR=$(GOLDEN_JSON_DIR)" \
			-f $(SVJSON_ROOT)/src/filelist.f \
			-f $(SVJSON_ROOT)/tests/filelist.f \
			$(extra_args) \
			-o work_modelsim \
	)

test_vcs:
	@echo Test sources with VCS
	$(call run_if_exist,vcs, \
		runSVUnit \
			-s vcs \
			-l run.log \
			-c "-full64 \
				+define+JSON_TEST_SUITE_INSTALL=$(JSON_TEST_SUITE_INSTALL) \
				+define+GOLDEN_JSON_DIR=$(GOLDEN_JSON_DIR)" \
			-f $(SVJSON_ROOT)/src/filelist.f \
			-f $(SVJSON_ROOT)/tests/filelist.f \
			$(extra_args) \
			-o work_vcs \
	)

clean:
	rm -rf work_*
