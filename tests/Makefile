.PHONY: all clean test

export SV_JSON_ROOT := $(realpath ..)
export SVUNIT_INSTALL := $(SV_JSON_ROOT)/contrib/svunit
export PATH := $(SVUNIT_INSTALL)/bin:$(PATH)

all: test

test:
	runSVUnit \
		-s verilator \
		-l run.log \
		-c "--cc --timing -j$(nproc)" \
		-f $(SV_JSON_ROOT)/src/filelist.f \
		-o work

clean:
	rm -rf work