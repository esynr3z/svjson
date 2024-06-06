`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `json_string`
module json_string_unit_test;
  import svunit_pkg::svunit_testcase;
  import test_utils_pkg::*;
  import json_pkg::*;

  string name = "json_string_ut";
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

  // Create json_string using constructor
  `SVTEST(create_new_test) begin
    json_string jstring;
    jstring = new("abc");
    `FAIL_UNLESS_STR_EQUAL(jstring.get(), "abc")
  end `SVTEST_END


  // Create json_string using static method
  `SVTEST(create_static_test) begin
    json_string jstring;
    jstring = json_string::from("xyz");
    `FAIL_UNLESS_STR_EQUAL(jstring.get(), "xyz")
  end `SVTEST_END


  // Clone json_string instance
  `SVTEST(clone_test) begin
    json_string orig = json_string::from("!@#");
    json_string clone = orig.clone().into_string();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.get() == clone.get())
  end `SVTEST_END


  // Compare json_string instances
  `SVTEST(compare_test) begin
    json_string jstring_a = json_string::from("");
    json_string jstring_b = json_string::from("");
    // OK
    `FAIL_UNLESS(jstring_a.compare(jstring_a))
    `FAIL_UNLESS(jstring_a.compare(jstring_b))
    jstring_a.set("foobar");
    jstring_b.set("foobar");
    `FAIL_UNLESS(jstring_a.compare(jstring_b))
    // Fail
    jstring_a.set("foo");
    jstring_b.set("bar");
    `FAIL_IF(jstring_a.compare(jstring_b))
    jstring_a.set("hello");
    jstring_b.set("bye");
    `FAIL_IF(jstring_a.compare(jstring_b))
  end `SVTEST_END


  // Compare jsom_string with other JSON values
  `SVTEST(compare_with_others_test) begin
    json_string jstring = json_string::from("1");
    json_int jint = json_int::from(1);
    json_real jreal = json_real::from(1.0);
    json_bool jbool = json_bool::from(1);
    json_array jarray = json_array::from('{json_int::from(1)});
    json_object jobject = json_object::from('{"int": json_int::from(1)});

    `FAIL_IF(jstring.compare(jint))
    `FAIL_IF(jstring.compare(jreal))
    `FAIL_IF(jstring.compare(jbool))
    `FAIL_IF(jstring.compare(jarray))
    `FAIL_IF(jstring.compare(jobject))
    `FAIL_IF(jstring.compare(null))
  end `SVTEST_END


  // Access internal value of json_string
  `SVTEST(getter_setter_test) begin
    json_string jstring = json_string::from("42");
    `FAIL_UNLESS_STR_EQUAL(jstring.get(), "42")
    jstring.set("-12345");
    `FAIL_UNLESS_STR_EQUAL(jstring.get(), "-12345")
  end `SVTEST_END


  // Test json_string_encodable interface
  `SVTEST(encodable_test) begin
    json_string jstring = json_string::from("foo");
    // Should be the same as get - returns internal value
    `FAIL_UNLESS(jstring.to_json_encodable() == jstring.get())
  end `SVTEST_END


  // Test is_* methods
  `SVTEST(is_something_test) begin
    json_string jstring = json_string::from("42");
    json_value jvalue = jstring;

    `FAIL_IF(jvalue.is_object())
    `FAIL_IF(jvalue.is_array())
    `FAIL_UNLESS(jvalue.is_string())
    `FAIL_IF(jvalue.is_int())
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

    json_string orig_jstring = json_string::from("42");
    json_value jvalue = orig_jstring;

    `FAIL_IF(jvalue.matches_object(jobject))
    `FAIL_IF(jvalue.matches_array(jarray))
    `FAIL_UNLESS(jvalue.matches_string(jstring))
    `FAIL_IF(jvalue.matches_int(jint))
    `FAIL_IF(jvalue.matches_real(jreal))
    `FAIL_IF(jvalue.matches_bool(jbool))

    `FAIL_UNLESS(jstring == orig_jstring)
  end `SVTEST_END


  // Test try_into_* methods
  `SVTEST(try_into_something_test) begin
    json_result#(json_object) res_jobject;
    json_result#(json_array) res_jarray;
    json_result#(json_string) res_jstring;
    json_result#(json_int) res_jint;
    json_result#(json_real) res_jreal;
    json_result#(json_bool) res_jbool;

    json_string orig_jstring = json_string::from("baz");
    json_value jvalue = orig_jstring;

    res_jobject = jvalue.try_into_object();
    res_jarray = jvalue.try_into_array();
    res_jstring = jvalue.try_into_string();
    res_jint = jvalue.try_into_int();
    res_jreal = jvalue.try_into_real();
    res_jbool = jvalue.try_into_bool();

    `FAIL_IF(res_jobject.is_ok())
    `FAIL_IF(res_jarray.is_ok())
    `FAIL_UNLESS(res_jstring.is_ok())
    `FAIL_IF(res_jint.is_ok())
    `FAIL_IF(res_jreal.is_ok())
    `FAIL_IF(res_jbool.is_ok())

    `FAIL_UNLESS(res_jstring.unwrap() == orig_jstring)
  end `SVTEST_END


  // Test into_* method
  `SVTEST(into_something_test) begin
    json_string res_jstring;
    json_string orig_jstring = json_string::from("");
    json_value jvalue = orig_jstring;

    res_jstring = jvalue.into_string();
  end `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_string_unit_test
