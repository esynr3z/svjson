`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Basic tests of `json_encoder` is used to dump JSON succesfuly
module json_dump_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_dump_ut";
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


  `SVTEST(dump_literal_test)
  begin
    `EXPECT_OK_DUMP_STR(null, "null")
    `EXPECT_OK_DUMP_STR(json_bool::from(1), "true")
    `EXPECT_OK_DUMP_STR(json_bool::from(0), "false")
  end
  `SVTEST_END


  `SVTEST(dump_int_test)
  begin
    `EXPECT_OK_DUMP_STR(json_int::from(0), "0")
    `EXPECT_OK_DUMP_STR(json_int::from(42), "42")
    `EXPECT_OK_DUMP_STR(json_int::from(-123213), "-123213")
  end
  `SVTEST_END


  `SVTEST(dump_real_test)
  begin
    `EXPECT_OK_DUMP_STR(json_real::from(0.000002), "0.000002")
    `EXPECT_OK_DUMP_STR(json_real::from(-123213292.0), "-123213292.000000")
    `EXPECT_OK_DUMP_STR(json_real::from(123302.123876), "123302.123876")
  end
  `SVTEST_END


  `SVTEST(dump_string_test)
  begin
    `EXPECT_OK_DUMP_STR(json_string::from(""), "\"\"")
    `EXPECT_OK_DUMP_STR(json_string::from("  "), "\"  \"")
    `EXPECT_OK_DUMP_STR(json_string::from("hello world"), "\"hello world\"")
    `EXPECT_OK_DUMP_STR(json_string::from("hello\nworld"), "\"hello\\nworld\"")
  end
  `SVTEST_END


  `SVTEST(dump_array_test)
  begin
    `EXPECT_OK_DUMP_STR(json_array::from('{}), "[]")
    `EXPECT_OK_DUMP_STR(json_array::from('{json_int::from(42)}), "[42]")
    `EXPECT_OK_DUMP_STR(json_array::from('{json_bool::from(1), json_bool::from(0)}), "[true,false]")
    `EXPECT_OK_DUMP_STR(json_array::from('{json_array::from('{}), json_string::from("foo")}), "[[],\"foo\"]")
    `EXPECT_OK_DUMP_STR(json_array::from('{json_object::from('{})}), "[{}]")
  end
  `SVTEST_END


  `SVTEST(dump_object_test)
  begin
    `EXPECT_OK_DUMP_STR(json_object::from('{}), "{}")
    `EXPECT_OK_DUMP_STR(json_object::from('{"bar" : json_int::from(42)}), "{\"bar\":42}")
    `EXPECT_OK_DUMP_STR(
      json_object::from('{"bar": json_int::from(42), "foo" : json_int::from(-1)}),
      "{\"bar\":42,\"foo\":-1}"
    )
    `EXPECT_OK_DUMP_STR(json_object::from('{"arr": json_array::from('{})}), "{\"arr\":[]}")
  end
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule : json_dump_unit_test
