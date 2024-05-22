`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `compare()` method implementations within JSON values
module json_values_compare_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_values_compare_ut";
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


  `SVTEST(compare_object_test)
  begin
    json_object jobject_a = json_object::from('{"key": json_int::from(42)});
    json_object jobject_b = jobject_a.clone().as_json_object().unwrap();
    // OK
    `FAIL_UNLESS(jobject_a.compare(jobject_a))
    `FAIL_UNLESS(jobject_a.compare(jobject_b))
    jobject_a.values["bar"] = json_bool::from(0);
    jobject_b.values["bar"] = json_bool::from(0);
    `FAIL_UNLESS(jobject_a.compare(jobject_b))
    // Fail
    jobject_a = json_object::from('{"key": json_int::from(41)});
    jobject_b = json_object::from('{"key": json_int::from(43)});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{"key": json_int::from(41)});
    jobject_b = json_object::from('{"keyy": json_int::from(41)});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{"key": json_int::from(41)});
    jobject_b = json_object::from('{});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{});
    jobject_b = json_object::from('{"key": json_int::from(42)});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{"key": json_int::from(42)});
    jobject_b = json_object::from('{"key": null});
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_a = json_object::from('{"key": null});
    jobject_b = json_object::from('{"key": json_int::from(42)});
    `FAIL_IF(jobject_a.compare(jobject_b))
  end
  `SVTEST_END


  `SVTEST(compare_object_nested_test)
  begin
    json_object jobject_a = json_object::from('{
      "key1": json_int::from(42),
      "key2": json_object::from('{}),
      "key3": json_object::from('{
        "bar": json_string::from("hello"),
        "baz": json_array::from('{null, json_int::from(0)})
      })
    });
    json_object jobject_b = jobject_a.clone().as_json_object().unwrap();

    // OK
    `FAIL_UNLESS(jobject_a.compare(jobject_b))

    // Fail
    jobject_b.values["key2"] = null;
    `FAIL_IF(jobject_a.compare(jobject_b))
    jobject_b = jobject_a.clone().as_json_object().unwrap();

    jobject_b.values["key3"].as_json_object().unwrap().values["baz"] = json_int::from(42);
    `FAIL_IF(jobject_a.compare(jobject_b))
  end
  `SVTEST_END


  `SVTEST(compare_object_with_others_test)
  begin
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
  end
  `SVTEST_END


  `SVTEST(compare_array_test)
  begin
    json_array jarray_a = json_array::from('{json_int::from(42), json_string::from("verilog")});
    json_array jarray_b = jarray_a.clone().as_json_array().unwrap();
    // OK
    `FAIL_UNLESS(jarray_a.compare(jarray_a))
    `FAIL_UNLESS(jarray_a.compare(jarray_b))
    jarray_a.values.push_back(json_bool::from(0));
    jarray_b.values.push_back(json_bool::from(0));
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
  end
  `SVTEST_END


  `SVTEST(compare_array_nested_test)
  begin
    json_array jarray_a = json_array::from('{
      json_int::from(42),
      json_object::from('{}),
      json_object::from('{
        "bar": json_string::from("hello"),
        "baz": json_array::from('{null, json_int::from(0)})
      })
    });
    json_array jarray_b = jarray_a.clone().as_json_array().unwrap();

    // OK
    `FAIL_UNLESS(jarray_a.compare(jarray_b))

    // Fail
    jarray_b.values[1] = null;
    `FAIL_IF(jarray_a.compare(jarray_b))
    jarray_b = jarray_a.clone().as_json_array().unwrap();

    jarray_b.values[2].as_json_object().unwrap().values["baz"] = json_int::from(42);
    `FAIL_IF(jarray_a.compare(jarray_b))
  end
  `SVTEST_END


  `SVTEST(compare_array_with_others_test)
  begin
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
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_values_compare_unit_test
