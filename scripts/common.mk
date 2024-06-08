# Generic rule to check for binary and execute multiple commands
define run_if_exist
	@if command -v $(1) >/dev/null 2>&1; then \
		$(2); \
	else \
		echo "$(1) was not found!"; \
	fi
endef