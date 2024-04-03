package json_pkg;

  // Forward declarations
  typedef json_value;
  typedef json_object;
  typedef json_array;
  typedef json_string;
  typedef json_int;
  typedef json_real;
  typedef json_bool;

  // Alias to raise syntax errors in a more compact way
  `define JSON_SYNTAX_ERR(KIND, STR, IDX, DESCR="")\
    parser_result::err( \
      json_error::create( \
        .kind(KIND), \
        .description(DESCR), \
        .json_str(STR), \
        .json_pos(IDX), \
        .source_file(`__FILE__), \
        .source_line(`__LINE__) \
      ) \
    )

  // Alias to raise internal error in a more compact way
  `define JSON_INTERNAL_ERR(DESCR="")\
    parser_result::err( \
      json_error::create( \
        .kind(json_error::INTERNAL), \
        .description(DESCR), \
        .source_file(`__FILE__), \
        .source_line(`__LINE__) \
      ) \
    )

  // Alias to raise common error
  `define JSON_ERR(KIND, DESCR="", VAL_T=json_value)\
    json_result#(json_value)::err( \
      json_error::create( \
        .kind(KIND), \
        .description(DESCR), \
        .source_file(`__FILE__), \
        .source_line(`__LINE__) \
      ) \
    )

  `include "json_error.sv"
  `include "json_result.sv"

  `include "json_value_encodable.sv"
  `include "json_object_encodable.sv"
  `include "json_array_encodable.sv"
  `include "json_string_encodable.sv"
  `include "json_int_encodable.sv"
  `include "json_real_encodable.sv"
  `include "json_bool_encodable.sv"

  `include "json_value.sv"
  `include "json_object.sv"
  `include "json_array.sv"
  `include "json_string.sv"
  `include "json_int.sv"
  `include "json_real.sv"
  `include "json_bool.sv"

  `include "json_decoder.sv"
  `include "json_encoder.sv"

  `undef JSON_SYNTAX_ERR
  `undef JSON_INTERNAL_ERR
  `undef JSON_ERR
endpackage : json_pkg
