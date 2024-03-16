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

  `SVTEST(compare_int_ok_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_int_fail_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_int_with_any_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(compare_int_with_null_test)
  begin
    `FAIL_IF(1)
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
