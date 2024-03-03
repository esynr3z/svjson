`include "svunit_defines.svh"

module json_load_unit_test;
  import svunit_pkg::svunit_testcase;

  import json_pkg::json_result;
  import json_pkg::json_value;
  import json_pkg::json_object;

  string name = "json_load_ut";
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
    `FAIL_IF(0)
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_load_unit_test
