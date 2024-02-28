`include "svunit_defines.svh"

module json_decoder_basic_unit_test;
  import svunit_pkg::svunit_testcase;

  import json_pkg::json_decoder;
  import json_pkg::json_result;

  string name = "json_decoder_basic_ut";
  svunit_testcase svunit_ut;

  // Special wrapper to make some private methods public for testing
  virtual class json_decoder_wrp extends json_decoder;
    static function json_result#(int unsigned) find_first_non_whitespace_pub(
      const ref string str,
      input int unsigned start_from=0
    );
      return find_first_non_whitespace(str, start_from);
    endfunction : find_first_non_whitespace_pub
  endclass : json_decoder_wrp

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

  `SVTEST(find_non_whitespace_test)
    string test = "  1";
    json_result#(int unsigned) result = json_decoder_wrp::find_first_non_whitespace_pub(test);
    `FAIL_IF(result.is_err())
    `FAIL_IF(result.value != 2)
  `SVTEST_END

  `SVTEST(find_non_whitespace_variants_test)
    string test = "\t\n\r 1";
    json_result#(int unsigned) result = json_decoder_wrp::find_first_non_whitespace_pub(test);
    `FAIL_IF(result.is_err())
    `FAIL_IF(result.value != 4)
  `SVTEST_END

  `SVTEST(find_non_whitespace_first_test)
    string test = "1";
    json_result#(int unsigned) result = json_decoder_wrp::find_first_non_whitespace_pub(test);
    `FAIL_IF(result.is_err())
    `FAIL_IF(result.value != 0)
  `SVTEST_END

  `SVTEST(find_non_whitespace_from_middle_test)
    string test = "1 2";
    json_result#(int unsigned) result = json_decoder_wrp::find_first_non_whitespace_pub(test, 1);
    `FAIL_IF(result.is_err())
    `FAIL_IF(result.value != 2)
  `SVTEST_END

  `SVTEST(find_non_whitespace_fail_test)
    string test = "\t\n\r \n ";
    json_result#(int unsigned) result = json_decoder_wrp::find_first_non_whitespace_pub(test);
    `FAIL_IF(result.is_ok())
  `SVTEST_END

  `SVTEST(find_non_whitespace_bounds_fail_test)
    string test = "0 1";
    json_result#(int unsigned) result = json_decoder_wrp::find_first_non_whitespace_pub(test, 3);
    `FAIL_IF(result.is_ok())
  `SVTEST_END

  `SVTEST(find_non_whitespace_empty_fail_test)
    string test = "";
    json_result#(int unsigned) result = json_decoder_wrp::find_first_non_whitespace_pub(test);
    `FAIL_IF(result.is_ok())
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_decoder_basic_unit_test
