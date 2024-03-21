`include "svunit_defines.svh"

// Tests of `json_error` class
module json_error_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_error_ut";
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
    `FAIL_IF(1)
  end
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule : json_error_unit_test
