`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Basic tests of `json_decoder` is used to parse JSON with error
module json_load_err_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_load_err_ut";
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


  `SVTEST(value_err_test)
  begin
    `EXPECT_ERR_LOAD_STR("bar", json_error::create(json_error::EXPECTED_VALUE, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("  bar", json_error::create(json_error::EXPECTED_VALUE, .json_idx(2)))
    `EXPECT_ERR_LOAD_STR(" ", json_error::create(json_error::EOF_VALUE, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR(" \n \t ", json_error::create(json_error::EOF_VALUE, .json_idx(0)))
  end
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule : json_load_err_unit_test
