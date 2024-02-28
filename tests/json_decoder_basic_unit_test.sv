`include "svunit_defines.svh"

module json_decoder_basic_unit_test;
  import svunit_pkg::svunit_testcase;

  import json_pkg::json_decoder;
  import json_pkg::json_result;
  import json_pkg::json_value;
  import json_pkg::json_object;

  string name = "json_decoder_basic_ut";
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
    string test = "{}";
    json_object jobject;
    json_result#(json_value) result = json_decoder::try_load_string(test);
    `FAIL_UNLESS(result.is_ok())
    `FAIL_UNLESS($cast(jobject, result.value))
    `FAIL_IF(jobject.values.num() > 0)
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_decoder_basic_unit_test
