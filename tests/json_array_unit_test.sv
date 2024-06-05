`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `json_array`
module json_array_unit_test;
  import svunit_pkg::svunit_testcase;
  import test_utils_pkg::*;
  import json_pkg::*;

  string name = "json_array_ut";
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

  // Create json_array using constructor
  `SVTEST(create_new_test) begin
    json_array jarray;
    jarray = new('{json_bool::from(0)});
    `FAIL_UNLESS(jarray.get(0).as_bool().unwrap().get() == 0)
  end `SVTEST_END


  // Create json_array using static method
  `SVTEST(create_static_test) begin
    json_array jarray;
    jarray = json_array::from('{json_bool::from(0)});
    `FAIL_UNLESS(jarray.get(0).as_bool().unwrap().get() == 0)
  end `SVTEST_END


  // Clone json_array instance
  `SVTEST(clone_array_test) begin
    json_array orig = json_array::from('{json_bool::from(0), json_int::from(-13)});
    json_array clone = orig.clone().as_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 2)
    `FAIL_UNLESS(clone.get(0).as_bool().unwrap().get() == 0)
    `FAIL_UNLESS(clone.get(1).as_int().unwrap().get() == -13)
  end `SVTEST_END


  // Clone empty array
  `SVTEST(clone_empty_array_test) begin
    json_array orig = json_array::from('{});
    json_array clone = orig.clone().as_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 0)
  end `SVTEST_END


  // Clone array, where some items are nulls
  `SVTEST(clone_array_with_nulls_test) begin
    string str = "foo";
    json_array orig = json_array::from('{null, json_string::from(str), null});
    json_array clone = orig.clone().as_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 3)
    `FAIL_UNLESS(clone.get(0) == null)
    `FAIL_UNLESS(clone.get(1).as_string().unwrap().value == str)
    `FAIL_UNLESS(clone.get(2) == null)
  end `SVTEST_END


  // Clone complex structure array
  `SVTEST(clone_array_complex_test) begin
    string str = "bar";
    json_array orig = json_array::from('{
      json_real::from(0.008),
      json_array::from('{json_int::from(0), json_array::from('{})}),
      json_object::from('{"bar": json_bool::from(1)})
    });
    json_array clone = orig.clone().as_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 3)
    `FAIL_UNLESS(clone.get(0).as_real().unwrap().get() == 0.008)
    `FAIL_UNLESS(clone.get(1).is_array())
    `FAIL_UNLESS(clone.get(1).as_array().unwrap().size() == 2)
    `FAIL_UNLESS(clone.get(1).as_array().unwrap().get(0).as_int().unwrap().get() == 0)
    `FAIL_UNLESS(clone.get(1).as_array().unwrap().get(1).as_array().unwrap().size() == 0)
    `FAIL_UNLESS(clone.get(2).is_object())
    `FAIL_UNLESS(clone.get(2).as_object().unwrap().size() == 1)
    `FAIL_UNLESS(clone.get(2).as_object().unwrap().get(str).as_bool().unwrap().get() == 1)
  end `SVTEST_END


  // Compare json_array instances
  `SVTEST(compare_array_test) begin
    json_array jarray_a = json_array::from('{json_int::from(42), json_string::from("verilog")});
    json_array jarray_b = jarray_a.clone().as_array().unwrap();
    // OK
    `FAIL_UNLESS(jarray_a.compare(jarray_a))
    `FAIL_UNLESS(jarray_a.compare(jarray_b))
    jarray_a.push_back(json_bool::from(0));
    jarray_b.push_back(json_bool::from(0));
    `FAIL_UNLESS(jarray_a.compare(jarray_b))
    // Fail
    jarray_a = json_array::from('{json_int::from(41)});
    jarray_b = json_array::from('{json_int::from(43)});
    `FAIL_IF(jarray_a.compare(jarray_b))
    jarray_a = json_array::from('{json_int::from(41)});
    jarray_b = json_array::from('{json_int::from(41), json_int::from(42)});
    `FAIL_IF(jarray_a.compare(jarray_b))
    jarray_a = json_array::from('{json_int::from(41), json_int::from(42)});
    jarray_b = json_array::from('{json_int::from(41)});
    `FAIL_IF(jarray_a.compare(jarray_b))
    jarray_a = json_array::from('{json_int::from(41)});
    jarray_b = json_array::from('{});
    `FAIL_IF(jarray_a.compare(jarray_b))
    jarray_a = json_array::from('{});
    jarray_b = json_array::from('{json_int::from(42)});
    `FAIL_IF(jarray_a.compare(jarray_b))
    jarray_a = json_array::from('{json_int::from(42)});
    jarray_b = json_array::from('{null});
    `FAIL_IF(jarray_a.compare(jarray_b))
    jarray_a = json_array::from('{null});
    jarray_b = json_array::from('{json_int::from(42)});
    `FAIL_IF(jarray_a.compare(jarray_b))
  end `SVTEST_END


  // Compare nested arrays
  `SVTEST(compare_array_nested_test) begin
    json_array jarray_a = json_array::from('{
      json_int::from(42),
      json_object::from('{}),
      json_object::from('{
        "bar": json_string::from("hello"),
        "baz": json_array::from('{null, json_int::from(0)})
      })
    });
    json_array jarray_b = jarray_a.clone().as_array().unwrap();

    // OK
    `FAIL_UNLESS(jarray_a.compare(jarray_b))

    // Fail
    jarray_b.set(1, null);
    `FAIL_IF(jarray_a.compare(jarray_b))
    jarray_b = jarray_a.clone().as_array().unwrap();

    jarray_b.get(2).as_object().unwrap().set("baz", json_int::from(42));
    `FAIL_IF(jarray_a.compare(jarray_b))
  end `SVTEST_END


  // Compare json_array with other JSON values
  `SVTEST(compare_array_with_others_test) begin
    json_string jstring = json_string::from("1");
    json_real jreal = json_real::from(1.0);
    json_int jint = json_int::from(1);
    json_bool jbool = json_bool::from(1);
    json_array jarray = json_array::from('{json_int::from(1)});
    json_object jobject = json_object::from('{"int": json_int::from(1)});
    // Comparsion is strict
    `FAIL_IF(jarray.compare(jreal))
    `FAIL_IF(jarray.compare(jint))
    `FAIL_IF(jarray.compare(jbool))
    `FAIL_IF(jarray.compare(jobject))
    `FAIL_IF(jarray.compare(jstring))
    `FAIL_IF(jarray.compare(null))
  end `SVTEST_END


  // Access internal values by index
  `SVTEST(getter_setter_test) begin
    json_int jint0 = json_int::from(42);
    json_int jint1 = json_int::from(-113);
    json_int jint2 = json_int::from(512);
    json_array jarray = json_array::from('{jint0, jint1});
    `FAIL_UNLESS(jarray.get(0).as_int().unwrap() == jint0)
    `FAIL_UNLESS(jarray.get(1).as_int().unwrap() == jint1)
    jarray.set(0, jint2);
    `FAIL_UNLESS(jarray.get(0).as_int().unwrap() == jint2)
    jarray.set(1, null);
    `FAIL_UNLESS(jarray.get(1) == null)
  end `SVTEST_END


  // Test json_array_encodable interface
  `SVTEST(encodable_test) begin
    json_array::values_t values = '{json_int::from(42), json_int::from(-113)};
    json_array_encodable::values_t enc_values;
    json_array jarray = json_array::from(values);

    enc_values = jarray.to_json_encodable();
    `FAIL_UNLESS(enc_values.size() == 2)
    `FAIL_UNLESS(enc_values[0] == values[0])
    `FAIL_UNLESS(enc_values[1] == values[1])
  end `SVTEST_END


  // Test is_* methods
  `SVTEST(is_something_test) begin
    json_array jarray = json_array::from('{});
    json_value jvalue = jarray;

    `FAIL_IF(jvalue.is_object())
    `FAIL_UNLESS(jvalue.is_array())
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

    json_array orig_jarray = json_array::from('{});
    json_value jvalue = orig_jarray;

    `FAIL_IF(jvalue.matches_object(jobject))
    `FAIL_UNLESS(jvalue.matches_array(jarray))
    `FAIL_IF(jvalue.matches_string(jstring))
    `FAIL_IF(jvalue.matches_int(jint))
    `FAIL_IF(jvalue.matches_real(jreal))
    `FAIL_IF(jvalue.matches_bool(jbool))

    `FAIL_UNLESS(jarray == orig_jarray)
  end `SVTEST_END


  // Test as_* methods
  `SVTEST(as_something_test) begin
    json_result#(json_object) res_jobject;
    json_result#(json_array) res_jarray;
    json_result#(json_string) res_jstring;
    json_result#(json_int) res_jint;
    json_result#(json_real) res_jreal;
    json_result#(json_bool) res_jbool;

    json_array orig_jarray = json_array::from('{});
    json_value jvalue = orig_jarray;

    res_jobject = jvalue.as_object();
    res_jarray = jvalue.as_array();
    res_jstring = jvalue.as_string();
    res_jint = jvalue.as_int();
    res_jreal = jvalue.as_real();
    res_jbool = jvalue.as_bool();

    `FAIL_IF(res_jobject.is_ok())
    `FAIL_UNLESS(res_jarray.is_ok())
    `FAIL_IF(res_jstring.is_ok())
    `FAIL_IF(res_jint.is_ok())
    `FAIL_IF(res_jreal.is_ok())
    `FAIL_IF(res_jbool.is_ok())

    `FAIL_UNLESS(res_jarray.unwrap() == orig_jarray)
  end `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_array_unit_test
