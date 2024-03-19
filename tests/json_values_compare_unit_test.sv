`include "svunit_defines.svh"

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

  `SVTEST(compare_int_test)
  begin
    json_int jint_a = json_int::from(42);
    json_int jint_b = json_int::from(42);
    // OK
    `FAIL_UNLESS(jint_a.compare(jint_b))
    jint_a.value = -123213213;
    jint_b.value = -123213213;
    `FAIL_UNLESS(jint_a.compare(jint_b))
    // Fail
    jint_a.value = 1232;
    jint_b.value = 12333;
    `FAIL_IF(jint_a.compare(jint_b))
    jint_a.value = -8232;
    jint_b.value = 123;
    `FAIL_IF(jint_a.compare(jint_b))
  end
  `SVTEST_END


  `SVTEST(compare_int_with_others_test)
  begin
    json_int jint = json_int::from(1);
    json_real jreal = json_real::from(1.0);
    json_bool jbool = json_bool::from(1);
    json_array jarray = json_array::from('{json_int::from(1)});
    json_object jobject = json_object::from('{"int": json_int::from(1)});
    json_null jnull = json_null::create();
    // Comparsion is strict
    `FAIL_IF(jint.compare(jreal))
    `FAIL_IF(jint.compare(jbool))
    `FAIL_IF(jint.compare(jarray))
    `FAIL_IF(jint.compare(jobject))
    `FAIL_IF(jint.compare(jnull))
    `FAIL_IF(jint.compare(null))
  end
  `SVTEST_END


  `SVTEST(compare_real_ok_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_real_fail_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_real_with_any_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_real_with_null_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_bool_ok_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_bool_fail_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_bool_with_any_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_bool_with_null_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_string_ok_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_string_fail_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_string_with_any_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_string_with_null_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_object_ok_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_object_fail_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_object_with_any_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_object_with_null_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_object_with_null_items_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_array_ok_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_array_fail_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_array_with_any_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_array_with_null_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_array_with_null_items_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_null_ok_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_null_with_any_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_null_with_native_null_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_values_compare_unit_test
