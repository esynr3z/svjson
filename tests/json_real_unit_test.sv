`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `json_real`
module json_real_unit_test;
  import svunit_pkg::svunit_testcase;
  import test_utils_pkg::*;
  import json_pkg::*;

  string name = "json_real_ut";
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

  // Create json_real using constructor
  `SVTEST(create_new_test) begin
    json_real jreal;
    jreal = new(1.0);
    `FAIL_UNLESS(jreal.get() == 1.0)
  end `SVTEST_END


  // Create json_real using static method
  `SVTEST(create_static_test) begin
    json_real jreal;
    jreal = json_real::from(-3.14);
    `FAIL_UNLESS(jreal.get() == -3.14)
  end `SVTEST_END


  // Clone json_real instance
  `SVTEST(clone_test) begin
    json_real orig = json_real::from(0.234);
    json_real clone = orig.clone().as_real().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.get() == clone.get())
  end `SVTEST_END


  // Compare json_real instances
  `SVTEST(compare_test) begin
    json_real jreal_a = json_real::from(1.0);
    json_real jreal_b = json_real::from(1.0);
    // OK
    `FAIL_UNLESS(jreal_a.compare(jreal_a))
    `FAIL_UNLESS(jreal_a.compare(jreal_b))
    jreal_a.set(-123213213.987654);
    jreal_b.set(-123213213.987654);
    `FAIL_UNLESS(jreal_a.compare(jreal_b))
    // Fail
    jreal_a.set(1.2);
    jreal_b.set(1.3);
    `FAIL_IF(jreal_a.compare(jreal_b))
    jreal_a.set(-10.6);
    jreal_b.set(10.6);
    `FAIL_IF(jreal_a.compare(jreal_b))
  end `SVTEST_END


  // Compare jsom_real with other JSON values
  `SVTEST(compare_with_others_test) begin
    json_string jstring = json_string::from("1");
    json_int jint = json_int::from(1);
    json_real jreal = json_real::from(1.0);
    json_bool jbool = json_bool::from(1);
    json_array jarray = json_array::from('{json_int::from(1)});
    json_object jobject = json_object::from('{"int": json_int::from(1)});

    `FAIL_IF(jreal.compare(jstring))
    `FAIL_IF(jreal.compare(jint))
    `FAIL_IF(jreal.compare(jbool))
    `FAIL_IF(jreal.compare(jarray))
    `FAIL_IF(jreal.compare(jobject))
    `FAIL_IF(jreal.compare(null))
  end `SVTEST_END


  // Access internal value of json_real
  `SVTEST(getter_setter_test) begin
    json_real jreal = json_real::from(42.2);
    `FAIL_UNLESS(jreal.get() == 42.2)
    jreal.set(-36.6);
    `FAIL_UNLESS(jreal.get() == -36.6)
  end `SVTEST_END


  // Test json_real_encodable interface
  `SVTEST(encodable_test) begin
    json_real jreal = json_real::from(0.0002);
    // Should be the same as get - returns internal value
    `FAIL_UNLESS(jreal.to_json_encodable() == jreal.get())
  end `SVTEST_END


  // Test is_* methods
  `SVTEST(is_something_test) begin
    json_real jreal = json_real::from(42.0);
    json_value jvalue = jreal;

    `FAIL_IF(jvalue.is_object())
    `FAIL_IF(jvalue.is_array())
    `FAIL_IF(jvalue.is_string())
    `FAIL_IF(jvalue.is_int())
    `FAIL_UNLESS(jvalue.is_real())
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

    json_real orig_jreal = json_real::from(2.71);
    json_value jvalue = orig_jreal;

    `FAIL_IF(jvalue.matches_object(jobject))
    `FAIL_IF(jvalue.matches_array(jarray))
    `FAIL_IF(jvalue.matches_string(jstring))
    `FAIL_IF(jvalue.matches_int(jint))
    `FAIL_UNLESS(jvalue.matches_real(jreal))
    `FAIL_IF(jvalue.matches_bool(jbool))

    `FAIL_UNLESS(jreal == orig_jreal)
  end `SVTEST_END


  // Test as_* methods
  `SVTEST(as_something_test) begin
    json_result#(json_object) res_jobject;
    json_result#(json_array) res_jarray;
    json_result#(json_string) res_jstring;
    json_result#(json_int) res_jint;
    json_result#(json_real) res_jreal;
    json_result#(json_bool) res_jbool;

    json_real orig_jreal = json_real::from(-3e5);
    json_value jvalue = orig_jreal;

    res_jobject = jvalue.as_object();
    res_jarray = jvalue.as_array();
    res_jstring = jvalue.as_string();
    res_jint = jvalue.as_int();
    res_jreal = jvalue.as_real();
    res_jbool = jvalue.as_bool();

    `FAIL_IF(res_jobject.is_ok())
    `FAIL_IF(res_jarray.is_ok())
    `FAIL_IF(res_jstring.is_ok())
    `FAIL_IF(res_jint.is_ok())
    `FAIL_UNLESS(res_jreal.is_ok())
    `FAIL_IF(res_jbool.is_ok())

    `FAIL_UNLESS(res_jreal.unwrap() == orig_jreal)
  end `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_real_unit_test
