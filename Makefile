.PHONY: all test test_src test_examples

all: test

test: test_src test_examples

test_src:
	make -C tests test

test_examples:
	make -C docs/modules/ROOT/examples/selftest test

clean:
	make -C tests clean
	make -C docs/modules/ROOT/examples/selftest clean