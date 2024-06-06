`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Tests of `json_enum`
module json_enum_unit_test;
  import svunit_pkg::svunit_testcase;
  import test_utils_pkg::*;
  import json_pkg::*;

  string name = "json_enum_ut";
  svunit_testcase svunit_ut;

  typedef json_enum#(dummy_e) json_dummy_enum;

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

  `SVTEST(create_new_test) begin
    json_dummy_enum jenum;
    jenum = new(DUMMY_BAR);
    `FAIL_UNLESS(jenum.get_enum() == DUMMY_BAR)
    // it also behaves like json_string
    `FAIL_UNLESS_STR_EQUAL(jenum.get(), "DUMMY_BAR")
  end `SVTEST_END


  `SVTEST(create_from_test) begin
    json_dummy_enum jenum = json_dummy_enum::from(DUMMY_BAR);
    `FAIL_UNLESS(jenum.get_enum() == DUMMY_BAR)
    // it also behaves like json_string
    `FAIL_UNLESS_STR_EQUAL(jenum.get(), "DUMMY_BAR")
  end `SVTEST_END


  `SVTEST(create_try_from_test) begin
    json_dummy_enum jenum;
    json_result#(json_dummy_enum) jres;

    jres = json_dummy_enum::try_from("DUMMY_BAR");
    `FAIL_IF(jres.is_err)
    `FAIL_UNLESS(jres.unwrap().get_enum() == DUMMY_BAR)

    jres = json_dummy_enum::try_from("DUMMY_FOO");
    `FAIL_IF(jres.is_err)
    `FAIL_UNLESS(jres.unwrap().get_enum() == DUMMY_FOO)

    jres = json_dummy_enum::try_from("DUMMY_BAZ");
    `FAIL_IF(jres.is_err)
    `FAIL_UNLESS(jres.unwrap().get_enum() == DUMMY_BAZ)
  end `SVTEST_END


  `SVTEST(create_try_from_err_test) begin
    json_dummy_enum jenum;
    json_result#(json_dummy_enum) jres;
    json_error error;

    jres = json_dummy_enum::try_from("DUMMY_EGGS");
    `FAIL_IF(jres.is_ok)
    `FAIL_UNLESS(jres.matches_err_eq(json_error::TYPE_CONVERSION, error))
  end `SVTEST_END


  `SVTEST(clone_enum_test) begin
    json_dummy_enum orig = json_dummy_enum::from(DUMMY_FOO);
    json_dummy_enum clone;
    $cast(clone, orig.clone());
    `FAIL_IF(orig == clone)
    `FAIL_UNLESS(orig.get() == clone.get())
    `FAIL_UNLESS(orig.enum_value == clone.enum_value)
  end `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_enum_unit_test
