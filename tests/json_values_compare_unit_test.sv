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

  `SVTEST(dummy_test)
  begin
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_values_compare_unit_test
