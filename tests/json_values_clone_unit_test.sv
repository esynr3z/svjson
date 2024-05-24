`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `clone()` method implementations within JSON values
module json_values_clone_unit_test;
  import svunit_pkg::svunit_testcase;
  import test_utils_pkg::*;
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


  `SVTEST(clone_enum_test)
  begin
    json_dummy_enum orig = json_dummy_enum::from(DUMMY_FOO);
    json_dummy_enum clone;
    $cast(clone, orig.clone());
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.get() == clone.get())
    `FAIL_UNLESS(orig.enum_value == clone.enum_value)
  end
  `SVTEST_END


  `SVTEST(clone_array_test)
  begin
    json_array orig = json_array::from('{json_bool::from(0), json_int::from(-13)});
    json_array clone = orig.clone().as_json_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 2)
    `FAIL_UNLESS(clone.get(0).as_json_bool().unwrap().get() == 0)
    `FAIL_UNLESS(clone.get(1).as_json_int().unwrap().get() == -13)
  end
  `SVTEST_END


  `SVTEST(clone_empty_array_test)
  begin
    json_array orig = json_array::from('{});
    json_array clone = orig.clone().as_json_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 0)
  end
  `SVTEST_END


  `SVTEST(clone_array_with_nulls_test)
  begin
    string str = "foo";
    json_array orig = json_array::from('{null, json_string::from(str), null});
    json_array clone = orig.clone().as_json_array().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 3)
    `FAIL_UNLESS(clone.get(0) == null)
    `FAIL_UNLESS(clone.get(1).as_json_string().unwrap().value == str)
    `FAIL_UNLESS(clone.get(2) == null)
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
    `FAIL_UNLESS(clone.size() == 3)
    `FAIL_UNLESS(clone.get(0).as_json_real().unwrap().get() == 0.008)
    `FAIL_UNLESS(clone.get(1).is_json_array())
    `FAIL_UNLESS(clone.get(1).as_json_array().unwrap().size() == 2)
    `FAIL_UNLESS(clone.get(1).as_json_array().unwrap().get(0).as_json_int().unwrap().get() == 0)
    `FAIL_UNLESS(clone.get(1).as_json_array().unwrap().get(1).as_json_array().unwrap().size() == 0)
    `FAIL_UNLESS(clone.get(2).is_json_object())
    `FAIL_UNLESS(clone.get(2).as_json_object().unwrap().size() == 1)
    `FAIL_UNLESS(clone.get(2).as_json_object().unwrap().get(str).as_json_bool().unwrap().get() == 1)
  end
  `SVTEST_END


  `SVTEST(clone_object_test)
  begin
    string str = "foo";
    json_object orig = json_object::from('{"foo": json_int::from(12345)});
    json_object clone = orig.clone().as_json_object().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 1)
    `FAIL_UNLESS(clone.get(str).as_json_int().unwrap().get() == 12345)
  end
  `SVTEST_END


  `SVTEST(clone_object_with_nulls_test)
  begin
    json_value jvalue;
    json_object orig = json_object::from('{"foo": json_string::from("blabla"), "bar": null});
    json_object clone = orig.clone().as_json_object().unwrap();
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(clone.size() == 2)
     jvalue = clone.get("foo");
    `FAIL_UNLESS_STR_EQUAL(jvalue.as_json_string().unwrap().value, "blabla")
    jvalue = clone.get("bar");
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
    `FAIL_UNLESS(clone.size() == 2)

    jreal = clone.get("real").as_json_real().unwrap();
    `FAIL_UNLESS(jreal.get() == 0.002)

    jarray = clone.get("array").as_json_array().unwrap();
    `FAIL_UNLESS(jarray.size() == 2)
    `FAIL_UNLESS(jarray.get(0).as_json_array().unwrap().size() == 0)

    jobject = jarray.get(1).as_json_object().unwrap();
    `FAIL_UNLESS(jobject.size() == 1)
    `FAIL_UNLESS(jobject.get(str).as_json_bool().unwrap().get() == 1)
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_values_clone_unit_test
