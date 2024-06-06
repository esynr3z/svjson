`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `json_bool`
module json_bool_unit_test;
  import svunit_pkg::svunit_testcase;
  import test_utils_pkg::*;
  import json_pkg::*;

  string name = "json_bool_ut";
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

  // Create json_bool using constructor
  `SVTEST(create_new_test) begin
    json_bool jbool;
    jbool = new(1);
    `FAIL_UNLESS(jbool.get() == 1)
  end `SVTEST_END


  // Create json_bool using static method
  `SVTEST(create_static_test) begin
    json_bool jbool;
    jbool = json_bool::from(0);
    `FAIL_UNLESS(jbool.get() == 0)
  end `SVTEST_END


  // Clone json_bool instance
  `SVTEST(clone_test) begin
    json_bool orig = json_bool::from(1);
    json_bool clone = orig.clone().into_bool();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.get() == clone.get())
  end `SVTEST_END


  // Compare json_bool instances
  `SVTEST(compare_test) begin
    json_bool jbool_a = json_bool::from(1);
    json_bool jbool_b = json_bool::from(1);
    // OK
    `FAIL_UNLESS(jbool_a.compare(jbool_a))
    `FAIL_UNLESS(jbool_a.compare(jbool_b))
    jbool_a.set(0);
    jbool_b.set(0);
    `FAIL_UNLESS(jbool_a.compare(jbool_b))
    // Fail
    jbool_a.set(1);
    jbool_b.set(0);
    `FAIL_IF(jbool_a.compare(jbool_b))
    jbool_a.set(0);
    jbool_b.set(1);
    `FAIL_IF(jbool_a.compare(jbool_b))
  end `SVTEST_END


  // Compare jsom_int with other JSON values
  `SVTEST(compare_with_others_test) begin
    json_string jstring = json_string::from("1");
    json_int jint = json_int::from(1);
    json_real jreal = json_real::from(1.0);
    json_bool jbool = json_bool::from(1);
    json_array jarray = json_array::from('{json_int::from(1)});
    json_object jobject = json_object::from('{"int": json_int::from(1)});

    `FAIL_IF(jbool.compare(jstring))
    `FAIL_IF(jbool.compare(jreal))
    `FAIL_IF(jbool.compare(jint))
    `FAIL_IF(jbool.compare(jarray))
    `FAIL_IF(jbool.compare(jobject))
    `FAIL_IF(jbool.compare(null))
  end `SVTEST_END


  // Access internal value of json_bool
  `SVTEST(getter_setter_test) begin
    json_bool jbool = json_bool::from(1);
    `FAIL_UNLESS(jbool.get() == 1)
    jbool.set(0);
    `FAIL_UNLESS(jbool.get() == 0)
  end `SVTEST_END


  // Test json_bool_encodable interface
  `SVTEST(encodable_test) begin
    json_bool jbool = json_bool::from(1);
    // Should be the same as get - returns internal value
    `FAIL_UNLESS(jbool.to_json_encodable() == jbool.get())
  end `SVTEST_END


  // Test is_* methods
  `SVTEST(is_something_test) begin
    json_bool jbool = json_bool::from(1);
    json_value jvalue = jbool;

    `FAIL_IF(jvalue.is_object())
    `FAIL_IF(jvalue.is_array())
    `FAIL_IF(jvalue.is_string())
    `FAIL_IF(jvalue.is_int())
    `FAIL_IF(jvalue.is_real())
    `FAIL_UNLESS(jvalue.is_bool())
  end `SVTEST_END


  // Test match_* methods
  `SVTEST(matches_something_test) begin
    json_object jobject;
    json_array jarray;
    json_string jstring;
    json_int jint;
    json_real jreal;
    json_bool jbool;

    json_bool orig_jbool = json_bool::from(0);
    json_value jvalue = orig_jbool;

    `FAIL_IF(jvalue.matches_object(jobject))
    `FAIL_IF(jvalue.matches_array(jarray))
    `FAIL_IF(jvalue.matches_string(jstring))
    `FAIL_IF(jvalue.matches_int(jint))
    `FAIL_IF(jvalue.matches_real(jreal))
    `FAIL_UNLESS(jvalue.matches_bool(jbool))

    `FAIL_UNLESS(jbool == orig_jbool)
  end `SVTEST_END


  // Test try_into_* methods
  `SVTEST(try_into_something_test) begin
    json_result#(json_object) res_jobject;
    json_result#(json_array) res_jarray;
    json_result#(json_string) res_jstring;
    json_result#(json_int) res_jint;
    json_result#(json_real) res_jreal;
    json_result#(json_bool) res_jbool;

    json_bool orig_jbool = json_bool::from(1);
    json_value jvalue = orig_jbool;

    res_jobject = jvalue.try_into_object();
    res_jarray = jvalue.try_into_array();
    res_jstring = jvalue.try_into_string();
    res_jint = jvalue.try_into_int();
    res_jreal = jvalue.try_into_real();
    res_jbool = jvalue.try_into_bool();

    `FAIL_IF(res_jobject.is_ok())
    `FAIL_IF(res_jarray.is_ok())
    `FAIL_IF(res_jstring.is_ok())
    `FAIL_IF(res_jint.is_ok())
    `FAIL_IF(res_jreal.is_ok())
    `FAIL_UNLESS(res_jbool.is_ok())

    `FAIL_UNLESS(res_jbool.unwrap() == orig_jbool)
  end `SVTEST_END


  // Test into_* method
  `SVTEST(into_something_test) begin
    json_bool res_jbool;
    json_bool orig_jbool = json_bool::from(1);
    json_value jvalue = orig_jbool;

    res_jbool = jvalue.into_bool();
  end `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_bool_unit_test
