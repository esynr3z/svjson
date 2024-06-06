`include "svunit_defines.svh"

// Tests of all examples used in docs
module examples_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "examples_ut";
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

  function automatic void write_file(string name, string text);
    int file_descr = $fopen(name, "w");
    $fwrite(file_descr, text);
    $fclose(file_descr);
  endfunction : write_file

  `SVUNIT_TESTS_BEGIN

  `SVTEST(decoder0_test) begin
    `include "decoder0.svh"
  end `SVTEST_END


  `SVTEST(decoder1_test) begin
    write_file(
      "pizza.json",
      {
        "{\n",
        "    \"recipeName\": \"Vegetarian Pizza\",\n",
        "    \"servings\": 4,\n",
        "    \"isVegan\": true\n",
        "}"
      }
    );
    begin
      `include "decoder1.svh"
    end
  end `SVTEST_END


  `SVTEST(encoder0_test) begin
    `include "encoder0.svh"
  end `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : examples_unit_test
