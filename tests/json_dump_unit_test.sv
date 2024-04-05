`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Basic tests of `json_encoder` is used to dump JSON succesfuly
module json_dump_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_dump_ut";
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

  // Construct and return full path to a JSON file from `tests/golden_json`
  function automatic string resolve_path(string path);
    return {`STRINGIFY(`GOLDEN_JSON_DIR), "/", path};
  endfunction : resolve_path


  function automatic string read_file(string path);
    int file_descr;
    string file_text;

    file_descr = $fopen(path, "r");
    if (file_descr == 0) begin
      return "File not opened";
    end

    while (!$feof(file_descr)) begin
      string line;
      $fgets(line, file_descr);
      file_text = {file_text, line};
    end
    $fclose(file_descr);

    return file_text;
  endfunction : read_file

  `SVUNIT_TESTS_BEGIN


  `SVTEST(dump_literal_test)
  begin
    `EXPECT_OK_DUMP_STR(null, "null")
    `EXPECT_OK_DUMP_STR(json_bool::from(1), "true")
    `EXPECT_OK_DUMP_STR(json_bool::from(0), "false")
  end
  `SVTEST_END


  `SVTEST(dump_int_test)
  begin
    `EXPECT_OK_DUMP_STR(json_int::from(0), "0")
    `EXPECT_OK_DUMP_STR(json_int::from(42), "42")
    `EXPECT_OK_DUMP_STR(json_int::from(-123213), "-123213")
  end
  `SVTEST_END


  `SVTEST(dump_real_test)
  begin
    `EXPECT_OK_DUMP_STR(json_real::from(0.000002), "0.000002")
    `EXPECT_OK_DUMP_STR(json_real::from(-123213292.0), "-123213292.000000")
    `EXPECT_OK_DUMP_STR(json_real::from(123302.123876), "123302.123876")
  end
  `SVTEST_END


  `SVTEST(dump_string_test)
  begin
    `EXPECT_OK_DUMP_STR(json_string::from(""), "\"\"")
    `EXPECT_OK_DUMP_STR(json_string::from("  "), "\"  \"")
    `EXPECT_OK_DUMP_STR(json_string::from("hello world"), "\"hello world\"")
    `EXPECT_OK_DUMP_STR(json_string::from("hello\nworld"), "\"hello\\nworld\"")
  end
  `SVTEST_END


  `SVTEST(dump_array_test)
  begin
    `EXPECT_OK_DUMP_STR(json_array::from('{}), "[]")
    `EXPECT_OK_DUMP_STR(json_array::from('{json_int::from(42)}), "[42]")
    `EXPECT_OK_DUMP_STR(json_array::from('{json_bool::from(1), json_bool::from(0)}), "[true,false]")
    `EXPECT_OK_DUMP_STR(json_array::from('{json_array::from('{}), json_string::from("foo")}), "[[],\"foo\"]")
    `EXPECT_OK_DUMP_STR(json_array::from('{json_object::from('{})}), "[{}]")
  end
  `SVTEST_END


  `SVTEST(dump_object_test)
  begin
    `EXPECT_OK_DUMP_STR(json_object::from('{}), "{}")
    `EXPECT_OK_DUMP_STR(json_object::from('{"bar" : json_int::from(42)}), "{\"bar\":42}")
    `EXPECT_OK_DUMP_STR(
      json_object::from('{"bar": json_int::from(42), "foo" : json_int::from(-1)}),
      "{\"bar\":42,\"foo\":-1}"
    )
    `EXPECT_OK_DUMP_STR(json_object::from('{"arr": json_array::from('{})}), "{\"arr\":[]}")
  end
  `SVTEST_END


  `SVTEST(dump_indent0_test)
  begin
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("pizza_indent0.json")).unwrap(),
      read_file(resolve_path("pizza_indent0.json"))
    )
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("recipes_indent0.json")).unwrap(),
      read_file(resolve_path("recipes_indent0.json"))
    )
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("video_indent0.json")).unwrap(),
      read_file(resolve_path("video_indent0.json"))
    )
  end
  `SVTEST_END


  `SVTEST(dump_indent2_test)
  begin
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("pizza_indent2.json")).unwrap(),
      read_file(resolve_path("pizza_indent2.json")),
      2
    )
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("recipes_indent2.json")).unwrap(),
      read_file(resolve_path("recipes_indent2.json")),
      2
    )
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("video_indent2.json")).unwrap(),
      read_file(resolve_path("video_indent2.json")),
      2
    )
  end
  `SVTEST_END


  `SVTEST(dump_indent4_test)
  begin
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("pizza_indent4.json")).unwrap(),
      read_file(resolve_path("pizza_indent4.json")),
      4
    )
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("recipes_indent4.json")).unwrap(),
      read_file(resolve_path("recipes_indent4.json")),
      4
    )
    `EXPECT_OK_DUMP_STR(
      json_decoder::load_file(resolve_path("video_indent4.json")).unwrap(),
      read_file(resolve_path("video_indent4.json")),
      4
    )
  end
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule : json_dump_unit_test
