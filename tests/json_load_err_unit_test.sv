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


  `SVTEST(value_err_test) begin
    `EXPECT_ERR_LOAD_STR("bar", json_error::create(json_error::EXPECTED_VALUE, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("  bar", json_error::create(json_error::EXPECTED_VALUE, .json_pos(2)))
    `EXPECT_ERR_LOAD_STR("False", json_error::create(json_error::EXPECTED_VALUE, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("True", json_error::create(json_error::EXPECTED_VALUE, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("Null", json_error::create(json_error::EXPECTED_VALUE, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR(" ", json_error::create(json_error::EOF_VALUE, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("\n \n ", json_error::create(json_error::EOF_VALUE, .json_pos(3)))
  end `SVTEST_END


  `SVTEST(literal_err_test) begin
    `EXPECT_ERR_LOAD_STR("t", json_error::create(json_error::EOF_LITERAL, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR(" tru", json_error::create(json_error::EOF_LITERAL, .json_pos(1)))
    `EXPECT_ERR_LOAD_STR("f ", json_error::create(json_error::EOF_LITERAL, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("fals", json_error::create(json_error::EOF_LITERAL, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("n\n", json_error::create(json_error::EOF_LITERAL, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("nul", json_error::create(json_error::EOF_LITERAL, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("folse", json_error::create(json_error::INVALID_LITERAL, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("falsed", json_error::create(json_error::TRAILING_CHARS, .json_pos(5)))
    `EXPECT_ERR_LOAD_STR("truee", json_error::create(json_error::TRAILING_CHARS, .json_pos(4)))
    `EXPECT_ERR_LOAD_STR("ttrue", json_error::create(json_error::INVALID_LITERAL, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("nill", json_error::create(json_error::INVALID_LITERAL, .json_pos(0)))
  end `SVTEST_END


  `SVTEST(number_err_test) begin
    `EXPECT_ERR_LOAD_STR("8'h23", json_error::create(json_error::INVALID_NUMBER, .json_pos(1)))
    `EXPECT_ERR_LOAD_STR("0x1", json_error::create(json_error::INVALID_NUMBER, .json_pos(1)))
    `EXPECT_ERR_LOAD_STR("0b11", json_error::create(json_error::INVALID_NUMBER, .json_pos(1)))
    `EXPECT_ERR_LOAD_STR("0,1", json_error::create(json_error::TRAILING_CHARS, .json_pos(1)))
    `EXPECT_ERR_LOAD_STR("212  122", json_error::create(json_error::TRAILING_CHARS, .json_pos(5)))
    `EXPECT_ERR_LOAD_STR("2f5e", json_error::create(json_error::INVALID_NUMBER, .json_pos(1)))
  end `SVTEST_END


  `SVTEST(string_err_test) begin
    `EXPECT_ERR_LOAD_STR("\"", json_error::create(json_error::EOF_STRING, .json_pos(0)))
    `EXPECT_ERR_LOAD_STR("\"  1221 ", json_error::create(json_error::EOF_STRING, .json_pos(7)))
    `EXPECT_ERR_LOAD_STR("\"  [] ", json_error::create(json_error::EOF_STRING, .json_pos(5)))
    `EXPECT_ERR_LOAD_STR("\"}", json_error::create(json_error::EOF_STRING, .json_pos(1)))
    `EXPECT_ERR_LOAD_STR("\" \\z \"", json_error::create(json_error::INVALID_ESCAPE, .json_pos(3)))
    `EXPECT_ERR_LOAD_STR("\" \n \"", json_error::create(json_error::INVALID_CHAR, .json_pos(2)))
  end `SVTEST_END


  `SVTEST(array_err_test) begin
    `EXPECT_ERR_LOAD_STR(" [", json_error::create(json_error::EOF_VALUE, .json_pos(1)))
    `EXPECT_ERR_LOAD_STR("[ a", json_error::create(json_error::EXPECTED_VALUE, .json_pos(2)))
    `EXPECT_ERR_LOAD_STR("[null,", json_error::create(json_error::EOF_VALUE, .json_pos(5)))
    `EXPECT_ERR_LOAD_STR("[ true, 1.2, ] ", json_error::create(json_error::TRAILING_COMMA, .json_pos(13)))
    `EXPECT_ERR_LOAD_STR("[ 42, , false] ", json_error::create(json_error::EXPECTED_VALUE, .json_pos(6)))
    `EXPECT_ERR_LOAD_STR("[ , ] ", json_error::create(json_error::EXPECTED_VALUE, .json_pos(2)))
    `EXPECT_ERR_LOAD_STR("[ \"123\"; 456 ] ", json_error::create(json_error::EXPECTED_ARRAY_COMMA_OR_END, .json_pos(7)))
  end `SVTEST_END


  `SVTEST(object_err_test) begin
    `EXPECT_ERR_LOAD_STR(" {", json_error::create(json_error::EOF_STRING, .json_pos(1)))
    `EXPECT_ERR_LOAD_STR("{ a", json_error::create(json_error::EXPECTED_DOUBLE_QUOTE, .json_pos(2)))
    `EXPECT_ERR_LOAD_STR("{ \"foo\"", json_error::create(json_error::EOF_OBJECT, .json_pos(6)))
    `EXPECT_ERR_LOAD_STR("{ \"foo\", \"bar\"", json_error::create(json_error::EXPECTED_COLON, .json_pos(7)))
    `EXPECT_ERR_LOAD_STR("{ \"foo\"}", json_error::create(json_error::EXPECTED_COLON, .json_pos(7)))
    `EXPECT_ERR_LOAD_STR("{ \"foo\":  ", json_error::create(json_error::EOF_VALUE, .json_pos(9)))
    `EXPECT_ERR_LOAD_STR("{ \"foo\":,", json_error::create(json_error::EXPECTED_VALUE, .json_pos(8)))
    `EXPECT_ERR_LOAD_STR("{ \"foo\": } ", json_error::create(json_error::EXPECTED_VALUE, .json_pos(9)))
    `EXPECT_ERR_LOAD_STR("{ \"foo\": true, ", json_error::create(json_error::EOF_STRING, .json_pos(14)))
    `EXPECT_ERR_LOAD_STR("{ \"foo\": true,}", json_error::create(json_error::TRAILING_COMMA, .json_pos(14)))
    `EXPECT_ERR_LOAD_STR("{ : true}", json_error::create(json_error::EXPECTED_DOUBLE_QUOTE, .json_pos(2)))
    `EXPECT_ERR_LOAD_STR("{ 2345: 32}", json_error::create(json_error::EXPECTED_DOUBLE_QUOTE, .json_pos(2)))
    `EXPECT_ERR_LOAD_STR("{ true: true}", json_error::create(json_error::EXPECTED_DOUBLE_QUOTE, .json_pos(2)))
  end `SVTEST_END


  `SVUNIT_TESTS_END

endmodule : json_load_err_unit_test
