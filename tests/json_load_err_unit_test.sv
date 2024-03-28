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
    `EXPECT_ERR_LOAD_STR("False", json_error::create(json_error::EXPECTED_VALUE, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("True", json_error::create(json_error::EXPECTED_VALUE, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("Null", json_error::create(json_error::EXPECTED_VALUE, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR(" ", json_error::create(json_error::EOF_VALUE, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("\n \n ", json_error::create(json_error::EOF_VALUE, .json_idx(3)))
  end
  `SVTEST_END


  `SVTEST(literal_err_test)
  begin
    `EXPECT_ERR_LOAD_STR("t", json_error::create(json_error::EOF_LITERAL, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR(" tru", json_error::create(json_error::EOF_LITERAL, .json_idx(1)))
    `EXPECT_ERR_LOAD_STR("f ", json_error::create(json_error::EOF_LITERAL, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("fals", json_error::create(json_error::EOF_LITERAL, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("n\n", json_error::create(json_error::EOF_LITERAL, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("nul", json_error::create(json_error::EOF_LITERAL, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("folse", json_error::create(json_error::INVALID_LITERAL, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("falsed", json_error::create(json_error::TRAILING_CHARS, .json_idx(5)))
    `EXPECT_ERR_LOAD_STR("truee", json_error::create(json_error::TRAILING_CHARS, .json_idx(4)))
    `EXPECT_ERR_LOAD_STR("ttrue", json_error::create(json_error::INVALID_LITERAL, .json_idx(0)))
    `EXPECT_ERR_LOAD_STR("nill", json_error::create(json_error::INVALID_LITERAL, .json_idx(0)))
  end
  `SVTEST_END


  `SVTEST(number_err_test)
  begin
    `EXPECT_ERR_LOAD_STR("8'h23", json_error::create(json_error::INVALID_NUMBER, .json_idx(1)))
    `EXPECT_ERR_LOAD_STR("0x1", json_error::create(json_error::INVALID_NUMBER, .json_idx(1)))
    `EXPECT_ERR_LOAD_STR("0b11", json_error::create(json_error::INVALID_NUMBER, .json_idx(1)))
    `EXPECT_ERR_LOAD_STR("0,1", json_error::create(json_error::TRAILING_CHARS, .json_idx(1)))
    `EXPECT_ERR_LOAD_STR("212  122", json_error::create(json_error::TRAILING_CHARS, .json_idx(5)))
    `EXPECT_ERR_LOAD_STR("2f5e", json_error::create(json_error::INVALID_NUMBER, .json_idx(1)))
  end
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule : json_load_err_unit_test
