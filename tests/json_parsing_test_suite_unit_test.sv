`include "svunit_defines.svh"

// Tests based on `contrib/json_test_suite/test_parsing/*.json` files.
// Decoder should accept y_*.json.
// Decoder should reject n_*.json.
// Decoder should either accept or reject i_*.json (implementation defined).
module json_parsing_test_suite_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_parsing_test_suite_ut";
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

  // Construct and return full path to a JSON file from `contrib/json_test_suite`
  function automatic string resolve_path(string file);
    return {`STRINGIFY(`JSON_TEST_SUITE_INSTALL), "/test_parsing/", file};
  endfunction : resolve_path

  `SVUNIT_TESTS_BEGIN

  `SVTEST(accept_test)
  begin
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_arraysWithSpaces.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_empty.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_empty-string.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_ending_with_newline.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_false.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_heterogeneous.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_null.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_with_1_and_newline.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_with_leading_space.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_with_several_null.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_array_with_trailing_space.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_0e+1.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_0e1.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_after_space.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_double_close_to_zero.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_int_with_exp.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_minus_zero.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_negative_int.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_negative_one.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_negative_zero.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_real_capital_e.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_real_capital_e_neg_exp.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_real_capital_e_pos_exp.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_real_exponent.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_real_fraction_exponent.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_real_neg_exp.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_real_pos_exponent.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_simple_int.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_number_simple_real.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_basic.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_duplicated_key_and_value.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_duplicated_key.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_empty.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_empty_key.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_escaped_null_in_key.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_extreme_numbers.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_long_strings.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_simple.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_string_unicode.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_object_with_newlines.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_1_2_3_bytes_UTF-8_sequences.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_accepted_surrogate_pair.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_accepted_surrogate_pairs.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_allowed_escapes.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_backslash_and_u_escaped_zero.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_backslash_doublequotes.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_comments.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_double_escape_a.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_double_escape_n.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_escaped_control_character.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_escaped_noncharacter.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_in_array.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_in_array_with_leading_space.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_last_surrogates_1_and_2.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_nbsp_uescaped.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_nonCharacterInUTF-8_U+10FFFF.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_nonCharacterInUTF-8_U+FFFF.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_null_escape.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_one-byte-utf-8.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_pi.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_reservedCharacterInUTF-8_U+1BFFF.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_simple_ascii.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_space.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_surrogates_U+1D11E_MUSICAL_SYMBOL_G_CLEF.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_three-byte-utf-8.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_two-byte-utf-8.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_u+2028_line_sep.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_u+2029_par_sep.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_uescaped_newline.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_uEscape.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unescaped_char_delete.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode_2.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicodeEscapedBackslash.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode_escaped_double_quote.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode_U+10FFFE_nonchar.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode_U+1FFFE_nonchar.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode_U+200B_ZERO_WIDTH_SPACE.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode_U+2064_invisible_plus.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode_U+FDD0_nonchar.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_unicode_U+FFFE_nonchar.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_utf8.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_string_with_del_character.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_lonely_false.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_lonely_int.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_lonely_negative_real.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_lonely_null.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_lonely_string.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_lonely_true.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_string_empty.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_trailing_newline.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_true_in_array.json"))
    `EXPECT_OK_LOAD_FILE(resolve_path("y_structure_whitespace_array.json"))
  end
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : json_parsing_test_suite_unit_test
