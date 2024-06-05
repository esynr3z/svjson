`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `json_int`
module json_int_unit_test;
  import svunit_pkg::svunit_testcase;
  import test_utils_pkg::*;
  import json_pkg::*;

  string name = "json_int_ut";
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

  // Create json_int using constructor
  `SVTEST(create_new_test) begin
    json_int jint;
    jint = new(42);
    `FAIL_UNLESS(jint.get() == 42)
  end `SVTEST_END


  // Create json_int using static method
  `SVTEST(create_static_test) begin
    json_int jint;
    jint = json_int::from(42);
    `FAIL_UNLESS(jint.get() == 42)
  end `SVTEST_END


  // Clone json_int instance
  `SVTEST(clone_test) begin
    json_int orig = json_int::from(42);
    json_int clone = orig.clone().as_int().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.get() == clone.get())
  end `SVTEST_END


  // Compare json_int instances
  `SVTEST(compare_test) begin
    json_int jint_a = json_int::from(42);
    json_int jint_b = json_int::from(42);
    // OK
    `FAIL_UNLESS(jint_a.compare(jint_a))
    `FAIL_UNLESS(jint_a.compare(jint_b))
    jint_a.set(-123213213);
    jint_b.set(-123213213);
    `FAIL_UNLESS(jint_a.compare(jint_b))
    // Fail
    jint_a.set(1232);
    jint_b.set(12333);
    `FAIL_IF(jint_a.compare(jint_b))
    jint_a.set(-8232);
    jint_b.set(123);
    `FAIL_IF(jint_a.compare(jint_b))
  end `SVTEST_END


  // Compare jsom_int with other JSON values
  `SVTEST(compare_with_others_test) begin
    json_string jstring = json_string::from("1");
    json_int jint = json_int::from(1);
    json_real jreal = json_real::from(1.0);
    json_bool jbool = json_bool::from(1);
    json_array jarray = json_array::from('{json_int::from(1)});
    json_object jobject = json_object::from('{"int": json_int::from(1)});

    `FAIL_IF(jint.compare(jstring))
    `FAIL_IF(jint.compare(jreal))
    `FAIL_IF(jint.compare(jbool))
    `FAIL_IF(jint.compare(jarray))
    `FAIL_IF(jint.compare(jobject))
    `FAIL_IF(jint.compare(null))
  end `SVTEST_END


  // Access internal value of json_int
  `SVTEST(getter_setter_test) begin
    json_int jint = json_int::from(42);
    `FAIL_UNLESS(jint.get() == 42)
    jint.set(-12345);
    `FAIL_UNLESS(jint.get() == -12345)
  end `SVTEST_END


  // Test json_int_encodable interface
  `SVTEST(encodable_test) begin
    json_int jint = json_int::from(42);
    // Should be the same as get - returns internal value
    `FAIL_UNLESS(jint.to_json_encodable() == jint.get())
  end `SVTEST_END


  // Test is_* methods
  `SVTEST(is_something_test) begin
    json_int jint = json_int::from(42);
    json_value jvalue = jint;

    `FAIL_IF(jvalue.is_object())
    `FAIL_IF(jvalue.is_array())
    `FAIL_IF(jvalue.is_string())
    `FAIL_UNLESS(jvalue.is_int())
    `FAIL_IF(jvalue.is_real())
    `FAIL_IF(jvalue.is_bool())
  end `SVTEST_END


  // Test match_* methods
  `SVTEST(matches_something_test) begin
    json_object jobject;
    json_array jarray;
    json_string jstring;
    json_int jint;
    json_real jreal;
    json_bool jbool;

    json_int orig_jint = json_int::from(42);
    json_value jvalue = orig_jint;

    `FAIL_IF(jvalue.matches_object(jobject))
    `FAIL_IF(jvalue.matches_array(jarray))
    `FAIL_IF(jvalue.matches_string(jstring))
    `FAIL_UNLESS(jvalue.matches_int(jint))
    `FAIL_IF(jvalue.matches_real(jreal))
    `FAIL_IF(jvalue.matches_bool(jbool))

    `FAIL_UNLESS(jint == orig_jint)
  end `SVTEST_END


  // Test as_* methods
  `SVTEST(as_something_test) begin
    json_result#(json_object) res_jobject;
    json_result#(json_array) res_jarray;
    json_result#(json_string) res_jstring;
    json_result#(json_int) res_jint;
    json_result#(json_real) res_jreal;
    json_result#(json_bool) res_jbool;

    json_int orig_jint = json_int::from(42);
    json_value jvalue = orig_jint;

    res_jobject = jvalue.as_object();
    res_jarray = jvalue.as_array();
    res_jstring = jvalue.as_string();
    res_jint = jvalue.as_int();
    res_jreal = jvalue.as_real();
    res_jbool = jvalue.as_bool();

    `FAIL_IF(res_jobject.is_ok())
    `FAIL_IF(res_jarray.is_ok())
    `FAIL_IF(res_jstring.is_ok())
    `FAIL_UNLESS(res_jint.is_ok())
    `FAIL_IF(res_jreal.is_ok())
    `FAIL_IF(res_jbool.is_ok())

    `FAIL_UNLESS(res_jint.unwrap() == orig_jint)
  end `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_int_unit_test
