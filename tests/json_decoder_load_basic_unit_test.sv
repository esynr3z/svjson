`include "svunit_defines.svh"

// Basic tests of `json_decoder::load_string()` method
module json_decoder_load_string_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_decoder_load_basic_ut";
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

  `SVTEST(empty_object_test)
  begin
    string raw = "{}";
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_object().unwrap().size() == 0)
    `FAIL_UNLESS(result.unwrap().as_json_object().unwrap().compare(json_object::create('{})))
  end
  `SVTEST_END

  `SVTEST(empty_array_test)
  begin
    string raw = "[]";
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_array().unwrap().size() == 0)
    `FAIL_UNLESS(result.unwrap().as_json_array().unwrap().compare(json_array::create('{})))
  end
  `SVTEST_END

  `SVTEST(empty_string_test)
  begin
    string raw = "\"\"";
    string golden = "";
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_string().unwrap().size() == 0)
    `FAIL_UNLESS(result.unwrap().as_json_string().unwrap().compare(json_string::create(golden)))
  end
  `SVTEST_END

  `SVTEST(some_string_test)
  begin
    string raw = "\"foo {bar} [baz]\"";
    string golden = "foo {bar} [baz]";
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_string().unwrap().compare(json_string::create(golden)))
  end
  `SVTEST_END

  `SVTEST(some_positive_int_test)
  begin
    string raw = "42";
    longint golden = 42;
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_int().unwrap().compare(json_int::create(golden)))
  end
  `SVTEST_END

  `SVTEST(some_negative_int_test)
  begin
    string raw = "-777";
    longint golden = -777;
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_int().unwrap().compare(json_int::create(golden)))
  end
  `SVTEST_END

  `SVTEST(some_positive_real_test)
  begin
    string raw = "3.14";
    real golden = 3.14;
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_real().unwrap().compare(json_real::create(golden)))
  end
  `SVTEST_END

  `SVTEST(some_negative_real_test)
  begin
    string raw = "-0.1234567";
    real golden = -0.1234567;
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_real().unwrap().compare(json_real::create(golden)))
  end
  `SVTEST_END

  `SVTEST(true_bool_test)
  begin
    string raw = "true";
    bit golden = 1;
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_bool().unwrap().compare(json_bool::create(golden)))
  end
  `SVTEST_END

  `SVTEST(false_bool_test)
  begin
    string raw = "false";
    bit golden = 0;
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_bool().unwrap().compare(json_bool::create(golden)))
  end
  `SVTEST_END

  `SVTEST(null_test)
  begin
    string raw = "null";
    json_result result = json_decoder::load_string(raw);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_null().unwrap().compare(json_null::create()))
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_decoder_load_string_unit_test
