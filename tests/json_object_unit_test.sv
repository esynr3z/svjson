`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `json_object`
module json_object_unit_test;
  import svunit_pkg::svunit_testcase;
  import test_utils_pkg::*;
  import json_pkg::*;

  string name = "json_object_ut";
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

  // Create json_object using constructor
  `SVTEST(create_new_test) begin
    string key = "foo";
    json_object jobject;
    jobject = new('{"foo": json_bool::from(0)});
    `FAIL_UNLESS(jobject.get(key).into_bool().get() == 0)
  end `SVTEST_END


  // Create json_object using static method
  `SVTEST(create_static_test) begin
    string key = "foo";
    json_object jobject;
    jobject = json_object::from('{"foo": json_bool::from(0)});
    `FAIL_UNLESS(jobject.get(key).into_bool().get() == 0)
  end `SVTEST_END


  // Clone json_object instance
  `SVTEST(clone_object_test) begin
    string str = "foo";
    json_object orig = json_object::from('{"foo": json_int::from(12345)});
    json_object clone = orig.clone().into_object();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 1)
    `FAIL_UNLESS(clone.get(str).into_int().get() == 12345)
  end `SVTEST_END


  // Clone object with null items
  `SVTEST(clone_object_with_nulls_test) begin
    json_value jvalue;
    json_object orig = json_object::from('{"foo": json_string::from("blabla"), "bar": null});
    json_object clone = orig.clone().into_object();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 2)
     jvalue = clone.get("foo");
    `FAIL_UNLESS_STR_EQUAL(jvalue.into_string().get(), "blabla")
    jvalue = clone.get("bar");
    `FAIL_UNLESS(jvalue == null)
  end `SVTEST_END


  // Clone complex object
  `SVTEST(clone_object_complex_test) begin
    string str = "bar";
    json_real jreal;
    json_array jarray;
    json_object jobject;
    json_object orig = json_object::from('{
      "real": json_real::from(0.002),
      "array": json_array::from('{
        json_array::from('{}),
        json_object::from('{"bar": json_bool::from(1)})
      })
    });
    json_object clone = orig.clone().into_object();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 2)

    jreal = clone.get("real").into_real();
    `FAIL_UNLESS(jreal.get() == 0.002)

    jarray = clone.get("array").into_array();
    `FAIL_UNLESS(jarray.size() == 2)
    `FAIL_UNLESS(jarray.get(0).into_array().size() == 0)

    jobject = jarray.get(1).into_object();
    `FAIL_UNLESS(jobject.size() == 1)
    `FAIL_UNLESS(jobject.get(str).into_bool().get() == 1)
  end `SVTEST_END


  // Compare object instances
  `SVTEST(compare_object_test) begin
    json_object jobject_a = json_object::from('{"key": json_int::from(42)});
    json_object jobject_b = jobject_a.clone().into_object();
    // OK
    `FAIL_UNLESS(jobject_a.compare(jobject_a))
    `FAIL_UNLESS(jobject_a.compare(jobject_b))
    jobject_a.set("bar", json_bool::from(0));
    jobject_b.set("bar", json_bool::from(0));
    `FAIL_UNLESS(jobject_a.compare(jobject_b))
    // Fail
    jobject_a = json_object::from('{"key": json_int::from(41)});
    jobject_b = json_object::from('{"key": json_int::from(43)});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{"key": json_int::from(41)});
    jobject_b = json_object::from('{"keyy": json_int::from(41)});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{"key": json_int::from(41)});
    jobject_b = json_object::from(empty_jvalue_map);
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from(empty_jvalue_map);
    jobject_b = json_object::from('{"key": json_int::from(42)});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{"key": json_int::from(42)});
    jobject_b = json_object::from('{"key": null});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{"key": null});
    jobject_b = json_object::from('{"key": json_int::from(42)});
    `FAIL_IF(jobject_a.compare(jobject_b))
  end `SVTEST_END


  // Compare nested objects
  `SVTEST(compare_object_nested_test) begin
    json_object jobject_a = json_object::from('{
      "key1": json_int::from(42),
      "key2": json_object::from(empty_jvalue_map),
      "key3": json_object::from('{
        "bar": json_string::from("hello"),
        "baz": json_array::from('{null, json_int::from(0)})
      })
    });
    json_object jobject_b = jobject_a.clone().into_object();

    // OK
    `FAIL_UNLESS(jobject_a.compare(jobject_b))

    // Fail
    jobject_b.set("key2", null);
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_b = jobject_a.clone().into_object();

    jobject_b.get("key3").into_object().set("baz", json_int::from(42));
    `FAIL_IF(jobject_a.compare(jobject_b))
  end `SVTEST_END

  // Compare object with other JSON values
  `SVTEST(compare_object_with_others_test) begin
    json_string jstring = json_string::from("1");
    json_real jreal = json_real::from(1.0);
    json_int jint = json_int::from(1);
    json_bool jbool = json_bool::from(1);
    json_array jarray = json_array::from('{json_int::from(1)});
    json_object jobject = json_object::from('{"int": json_int::from(1)});
    // Comparsion is strict
    `FAIL_IF(jobject.compare(jreal))
    `FAIL_IF(jobject.compare(jint))
    `FAIL_IF(jobject.compare(jbool))
    `FAIL_IF(jobject.compare(jarray))
    `FAIL_IF(jobject.compare(jstring))
    `FAIL_IF(jobject.compare(null))
  end `SVTEST_END


  // Access internal values by key
  `SVTEST(getter_setter_test) begin
    json_int jint0 = json_int::from(42);
    json_int jint1 = json_int::from(-113);
    json_int jint2 = json_int::from(512);
    json_int jint_temp;
    json_value jvalue;
    json_object jobject = json_object::from('{"aaa": jint0, "bbb": jint1});

    jint_temp = jobject.get("aaa").into_int();
    `FAIL_UNLESS(jint_temp == jint0)
    jint_temp = jobject.get("bbb").into_int();
    `FAIL_UNLESS(jint_temp == jint1)
    jobject.set("aaa", jint2);
    jint_temp = jobject.get("aaa").into_int();
    `FAIL_UNLESS(jint_temp == jint2)
    jobject.set("ccc", null);
    jvalue = jobject.get("ccc");
    `FAIL_UNLESS(jvalue == null)
  end `SVTEST_END


  // Test json_object_encodable interface
  `SVTEST(encodable_test) begin
    json_value_encodable val0;
    json_value_encodable val1;
    json_object::values_t values = '{"foo": json_int::from(42), "bar": json_int::from(-113)};
    json_object_encodable::values_t enc_values;
    json_object jobject = json_object::from(values);

    enc_values = jobject.to_json_encodable();
    `FAIL_UNLESS(enc_values.size() == 2)
    val0 = values["foo"];
    val1 = enc_values["foo"];
    `FAIL_UNLESS(val0 == val1)
    val0 = values["bar"];
    val1 = enc_values["bar"];
    `FAIL_UNLESS(val0 == val1)
  end `SVTEST_END


  // Test is_* methods
  `SVTEST(is_something_test) begin
    json_object jobject = json_object::from(empty_jvalue_map);
    json_value jvalue = jobject;

    `FAIL_UNLESS(jvalue.is_object())
    `FAIL_IF(jvalue.is_array())
    `FAIL_IF(jvalue.is_string())
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

    json_object orig_jobject = json_object::from(empty_jvalue_map);
    json_value jvalue = orig_jobject;

    `FAIL_UNLESS(jvalue.matches_object(jobject))
    `FAIL_IF(jvalue.matches_array(jarray))
    `FAIL_IF(jvalue.matches_string(jstring))
    `FAIL_IF(jvalue.matches_int(jint))
    `FAIL_IF(jvalue.matches_real(jreal))
    `FAIL_IF(jvalue.matches_bool(jbool))

    `FAIL_UNLESS(jobject == orig_jobject)
  end `SVTEST_END


  // Test try_into_* methods
  `SVTEST(try_into_something_test) begin
    json_result#(json_object) res_jobject;
    json_result#(json_array) res_jarray;
    json_result#(json_string) res_jstring;
    json_result#(json_int) res_jint;
    json_result#(json_real) res_jreal;
    json_result#(json_bool) res_jbool;

    json_object orig_jobject = json_object::from(empty_jvalue_map);
    json_value jvalue = orig_jobject;

    res_jobject = jvalue.try_into_object();
    res_jarray = jvalue.try_into_array();
    res_jstring = jvalue.try_into_string();
    res_jint = jvalue.try_into_int();
    res_jreal = jvalue.try_into_real();
    res_jbool = jvalue.try_into_bool();

    `FAIL_UNLESS(res_jobject.is_ok())
    `FAIL_IF(res_jarray.is_ok())
    `FAIL_IF(res_jstring.is_ok())
    `FAIL_IF(res_jint.is_ok())
    `FAIL_IF(res_jreal.is_ok())
    `FAIL_IF(res_jbool.is_ok())

    `FAIL_UNLESS(res_jobject.unwrap() == orig_jobject)
  end `SVTEST_END


  // Test into_* method
  `SVTEST(into_something_test) begin
    json_object res_jobject;
    json_object orig_jobject = json_object::from(empty_jvalue_map);
    json_value jvalue = orig_jobject;

    res_jobject = jvalue.into_object();
  end `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_object_unit_test
