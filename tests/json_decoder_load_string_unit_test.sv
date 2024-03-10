`include "svunit_defines.svh"

module json_decoder_load_string_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_decoder_load_string_ut";
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

  `SVTEST(empty_object_test)
  begin
    string str = "{}";
    json_result result = json_decoder::load_string(str);
    `FAIL_IF(result.is_err())
    `FAIL_UNLESS(result.unwrap().as_json_object().size() == 0)
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_decoder_load_string_unit_test
