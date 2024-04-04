`ifndef TEST_UTILS_MACROS_SVH

// Macro to create string from a preprocessor text
`define STRINGIFY(x) `"x`"

// Automation macro to hide boilerplate of checking JSON string to be successfuly parsed.
// If `GOLDEN_VAL` is provided, then parsed value is compared with the golden one.
// Otherwise, only parsing status (err/ok) is evaluated.
`define EXPECT_OK_LOAD_STR(RAW_STR, GOLDEN_VAL=null)\
  begin \
    string err_msg = test_utils_pkg::expect_ok_load_str(RAW_STR, GOLDEN_VAL);\
    `FAIL_IF_LOG(err_msg.len() > 0, {"\n", err_msg, "\n"})\
  end

// Automation macro to hide boilerplate of checking JSON file to be successfuly parsed.
// If `GOLDEN_VAL` is provided, then parsed value is compared with the golden one.
// Otherwise, only parsing status (err/ok) is evaluated.
`define EXPECT_OK_LOAD_FILE(PATH, GOLDEN_VAL=null)\
  begin \
    string err_msg = test_utils_pkg::expect_ok_load_file(PATH, GOLDEN_VAL);\
    `FAIL_IF_LOG(err_msg.len() > 0, {"\n", err_msg, "\n"})\
  end

// Automation macro to hide boilerplate of checking JSON string to be parsed with error.
// If `GOLDEN_ERR` is provided, then parsed error is compared with the golden error.
// Otherwise, only parsing status (err/ok) is evaluated.
`define EXPECT_ERR_LOAD_STR(RAW_STR, GOLDEN_ERR=null)\
  begin \
    string err_msg = test_utils_pkg::expect_err_load_str(RAW_STR, GOLDEN_ERR);\
    `FAIL_IF_LOG(err_msg.len() > 0, {"\n", err_msg, "\n"})\
  end

// Automation macro to hide boilerplate of checking JSON file to be parsed with error.
// If `GOLDEN_ERR` is provided, then parsed error is compared with the golden error.
// Otherwise, only parsing status (err/ok) is evaluated.
`define EXPECT_ERR_LOAD_FILE(PATH, GOLDEN_ERR=null)\
  begin \
    string err_msg = test_utils_pkg::expect_err_load_file(PATH, GOLDEN_ERR);\
    `FAIL_IF_LOG(err_msg.len() > 0, {"\n", err_msg, "\n"})\
  end

// Automation macro to hide boilerplate of checking JSON string to be successfuly dumped.
// Dumped value is compared with the golden one.
`define EXPECT_OK_DUMP_STR(OBJ, GOLDEN_VAL)\
  begin\
    json_result#(string) res = json_encoder::dump_string(OBJ);\
    `FAIL_IF(res.is_err())\
    `FAIL_UNLESS_STR_EQUAL(res.unwrap(), GOLDEN_VAL)\
  end

`define TEST_UTILS_MACROS_SVH
`endif // !TEST_UTILS_MACROS_SVH