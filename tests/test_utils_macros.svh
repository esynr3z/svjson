`ifndef TEST_UTILS_MACROS_SVH

// Automation macro to hide boilerplate of checking JSON string to be successfuly parsed.
// If `GOLDEN_VAL` is provided, then parsed value is compared with the golden one.
// Otherwise, only parsing status (err/ok) is evaluated.
`define EXPECT_OK_LOAD_STR(RAW_STR, GOLDEN_VAL=null)\
  begin \
    string err_msg = test_utils_pkg::expect_ok_load_str(RAW_STR, GOLDEN_VAL);\
    `FAIL_IF_LOG(err_msg.len() > 0, {"\n", err_msg, "\n"})\
  end

`define TEST_UTILS_MACROS_SVH
`endif // !TEST_UTILS_MACROS_SVH