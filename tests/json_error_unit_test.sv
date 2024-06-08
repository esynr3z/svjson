`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `json_error` class
module json_error_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_error_ut";
  svunit_testcase svunit_ut;

  function void build();
    svunit_ut = new(name);
  endfunction

  task setup();
    svunit_ut.setup();
  endtask

  task teardown();
    svunit_ut.teardown();
  endtask

  `SVUNIT_TESTS_BEGIN


  `SVTEST(plain_msg_test)
  begin
    json_error err = json_error::create(json_error::INTERNAL);
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error:\nINTERNAL: Unspecified internal error")
  end
  `SVTEST_END


  `SVTEST(file_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::INTERNAL),
      .source_file("/path/to/some/file.sv")
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error raised from /path/to/some/file.sv:\n",
      "INTERNAL: Unspecified internal error"
    })
  end
  `SVTEST_END


  `SVTEST(file_line_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::INTERNAL),
      .source_file("/path/to/some/file.sv"),
      .source_line(20)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error raised from /path/to/some/file.sv:20:\n",
      "INTERNAL: Unspecified internal error"
    })
  end
  `SVTEST_END


  `SVTEST(description_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::INTERNAL),
      .description("Additional description message")
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error:\n",
      "INTERNAL: Unspecified internal error\n",
      "Additional description message"
    })
  end
  `SVTEST_END


  `SVTEST(file_line_descr_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::INTERNAL),
      .description("Additional description message"),
      .source_file("/path/to/some/file.sv"),
      .source_line(20)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error raised from /path/to/some/file.sv:20:\n",
      "INTERNAL: Unspecified internal error\n",
      "Additional description message"
    })
  end
  `SVTEST_END


  `SVTEST(single_line_short1_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::TRAILING_COMMA),
      .json_str("[[],]"),
      .json_pos(3)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error:\n",
      "TRAILING_COMMA: Unexpected comma after the last value\n",
      "JSON string line 1 symbol 4:\n",
      "[[],]\n",
      "   ^\n",
      "   |"
    })
  end
  `SVTEST_END


    `SVTEST(single_line_short2_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str("a"),
      .json_pos(0)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error:\n",
      "EXPECTED_VALUE: Current character should start some JSON value\n",
      "JSON string line 1 symbol 1:\n",
      "a\n",
      "^\n",
      "|"
    })
  end
  `SVTEST_END


  `SVTEST(single_line_short3_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str("[[],a"),
      .json_pos(4)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error:\n",
      "EXPECTED_VALUE: Current character should start some JSON value\n",
      "JSON string line 1 symbol 5:\n",
      "[[],a\n",
      "    ^\n",
      "    |"
    })
  end
  `SVTEST_END


  `SVTEST(single_line_long1_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str("[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,abc,24,25,26,27,28,29,30]"),
      .json_pos(60)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error:\n",
      "EXPECTED_VALUE: Current character should start some JSON value\n",
      "JSON string line 1 symbol 61:\n",
      "...11,12,13,14,15,16,17,18,19,20,21,22,abc,24,25,26,27,28,29,30]\n",
      "                                       ^\n",
      "                                       |"
    })
  end
  `SVTEST_END


  `SVTEST(single_line_long2_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str("[0,1,abc,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33]"),
      .json_pos(5)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error:\n",
      "EXPECTED_VALUE: Current character should start some JSON value\n",
      "JSON string line 1 symbol 6:\n",
      "[0,1,abc,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27...\n",
      "     ^\n",
      "     |"
    })
  end
  `SVTEST_END


  `SVTEST(single_line_long3_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str("[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,abc,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48]"),
      .json_pos(60)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error:\n",
      "EXPECTED_VALUE: Current character should start some JSON value\n",
      "JSON string line 1 symbol 61:\n",
      "...11,12,13,14,15,16,17,18,19,20,21,22,abc,24,25,26,27,28,29,30,31,32,33,34,...\n",
      "                                       ^\n",
      "                                       |"
    })
  end
  `SVTEST_END


  `SVTEST(multi_line_short_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str({
        "[\n",
        "    42,\n",
        "    abc\n",
        "]"
      }),
      .json_pos(14)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, {
      "JSON error:\n",
      "EXPECTED_VALUE: Current character should start some JSON value\n",
      "JSON string line 3 symbol 5:\n",
      "    abc\n",
      "    ^\n",
      "    |"
    })
  end
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule : json_error_unit_test