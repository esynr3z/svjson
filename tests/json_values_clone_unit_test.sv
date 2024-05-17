`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `clone()` method implementations within JSON values
module json_values_clone_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_values_clone_ut";
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

  `SVTEST(clone_int_test)
  begin
    json_int orig = json_int::from(42);
    json_int clone = orig.clone().as_json_int().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.value == clone.value)
  end
  `SVTEST_END


  `SVTEST(clone_real_test)
  begin
    json_real orig = json_real::from(-3.14);
    json_real clone = orig.clone().as_json_real().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.value == clone.value)
  end
  `SVTEST_END


  `SVTEST(clone_bool_test)
  begin
    json_bool orig = json_bool::from(1);
    json_bool clone = orig.clone().as_json_bool().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.value == clone.value)
  end
  `SVTEST_END


  `SVTEST(clone_string_test)
  begin
    json_string orig = json_string::from("Hello world");
    json_string clone = orig.clone().as_json_string().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.value == clone.value)
  end
  `SVTEST_END


  `SVTEST(clone_array_test)
  begin
    json_array orig = json_array::from('{json_bool::from(0), json_int::from(-13)});
    json_array clone = orig.clone().as_json_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.values.size() == 2)
    `FAIL_UNLESS(clone.values[0].as_json_bool().unwrap().value == 0)
    `FAIL_UNLESS(clone.values[1].as_json_int().unwrap().value == -13)
  end
  `SVTEST_END


  `SVTEST(clone_empty_array_test)
  begin
    json_array orig = json_array::from('{});
    json_array clone = orig.clone().as_json_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.values.size() == 0)
  end
  `SVTEST_END


  `SVTEST(clone_array_with_nulls_test)
  begin
    string str = "foo";
    json_array orig = json_array::from('{null, json_string::from(str), null});
    json_array clone = orig.clone().as_json_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.values.size() == 3)
    `FAIL_UNLESS(clone.values[0] == null)
    `FAIL_UNLESS(clone.values[1].as_json_string().unwrap().value == str)
    `FAIL_UNLESS(clone.values[2] == null)
  end
  `SVTEST_END


  `SVTEST(clone_array_complex_test)
  begin
    string str = "bar";
    json_array orig = json_array::from('{
      json_real::from(0.008),
      json_array::from('{json_int::from(0), json_array::from('{})}),
      json_object::from('{"bar": json_bool::from(1)})
    });
    json_array clone = orig.clone().as_json_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.values.size() == 3)
    `FAIL_UNLESS(clone.values[0].as_json_real().unwrap().value == 0.008)
    `FAIL_UNLESS(clone.values[1].is_json_array())
    `FAIL_UNLESS(clone.values[1].as_json_array().unwrap().values.size() == 2)
    `FAIL_UNLESS(clone.values[1].as_json_array().unwrap().values[0].as_json_int().unwrap().value == 0)
    `FAIL_UNLESS(clone.values[1].as_json_array().unwrap().values[1].as_json_array().unwrap().values.size() == 0)
    `FAIL_UNLESS(clone.values[2].is_json_object())
    `FAIL_UNLESS(clone.values[2].as_json_object().unwrap().values.size() == 1)
    `FAIL_UNLESS(clone.values[2].as_json_object().unwrap().values[str].as_json_bool().unwrap().value == 1)
  end
  `SVTEST_END


  `SVTEST(clone_object_test)
  begin
    string str = "foo";
    json_object orig = json_object::from('{"foo": json_int::from(12345)});
    json_object clone = orig.clone().as_json_object().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.values.size() == 1)
    `FAIL_UNLESS(clone.values[str].as_json_int().unwrap().value == 12345)
  end
  `SVTEST_END


  `SVTEST(clone_object_with_nulls_test)
  begin
    json_value jvalue;
    json_object orig = json_object::from('{"foo": json_string::from("blabla"), "bar": null});
    json_object clone = orig.clone().as_json_object().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.values.size() == 2)
     jvalue = clone.values["foo"];
    `FAIL_UNLESS_STR_EQUAL(jvalue.as_json_string().unwrap().value, "blabla")
    jvalue = clone.values["bar"];
    `FAIL_UNLESS(jvalue == null)
  end
  `SVTEST_END


  `SVTEST(clone_object_complex_test)
  begin
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
    json_object clone = orig.clone().as_json_object().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.values.size() == 2)

    jreal = clone.values["real"].as_json_real().unwrap();
    `FAIL_UNLESS(jreal.value == 0.002)

    jarray = clone.values["array"].as_json_array().unwrap();
    `FAIL_UNLESS(jarray.values.size() == 2)
    `FAIL_UNLESS(jarray.values[0].as_json_array().unwrap().values.size() == 0)

    jobject = jarray.values[1].as_json_object().unwrap();
    `FAIL_UNLESS(jobject.values.size() == 1)
    `FAIL_UNLESS(jobject.values[str].as_json_bool().unwrap().value == 1)
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_values_clone_unit_test
