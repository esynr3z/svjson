`include "svunit_defines.svh"

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
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_real_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_bool_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END

  `SVTEST(clone_string_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_null_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_array_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_array_with_nulls_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_array_complex_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_object_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_object_with_nulls_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVTEST(clone_object_complex_test)
  begin
    `FAIL_IF(1)
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_values_clone_unit_test
