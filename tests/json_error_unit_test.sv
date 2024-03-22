`include "svunit_defines.svh"

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
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error INTERNAL: Unspecified internal error")
  end
  `SVTEST_END


  `SVTEST(file_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::INTERNAL),
      .source_file("/path/to/some/file.sv")
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error INTERNAL: Unspecified internal error\
/path/to/some/file.sv")
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
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error INTERNAL: Unspecified internal error\
/path/to/some/file.sv:20")
  end
  `SVTEST_END


  `SVTEST(description_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::INTERNAL),
      .description("Additional description message")
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error INTERNAL: Unspecified internal error\
Additional description message")
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
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error INTERNAL: Unspecified internal error\
/path/to/some/file.sv:20\
Additional description message")
  end
  `SVTEST_END

  `SVTEST(single_line_short1_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::TRAILING_COMMA),
      .json_str("[[],]"),
      .json_idx(3)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error TRAILING_COMMA: Unexpected comma after the last value\
[[],]\
   ^\
   |")
  end
  `SVTEST_END

    `SVTEST(single_line_short2_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str("a"),
      .json_idx(0)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error EXPECTED_VALUE: Current character should start some JSON value\
a\
^\
|")
  end
  `SVTEST_END

  `SVTEST(single_line_short3_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str("[[],a"),
      .json_idx(4)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error EXPECTED_VALUE: Current character should start some JSON value\
[[],a\
    ^\
    |")
  end
  `SVTEST_END

  `SVTEST(single_line_long_context_msg_test)
  begin
    json_error err = json_error::create(
      .kind(json_error::EXPECTED_VALUE),
      .json_str("[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27"),
      .json_idx(62)
    );
    string err_s = err.to_string();
    `FAIL_UNLESS_STR_EQUAL(err_s, "JSON error EXPECTED_VALUE: Current character should start some JSON value\
[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,aaa,24,25,26,27,28,29,30]\
                                                            ^\
                                                            |")
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_error_unit_test
