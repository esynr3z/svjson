package json_pkg;

  // Forward declarations
  typedef json_value;
  typedef json_object;
  typedef json_array;
  typedef json_string;
  typedef json_int;
  typedef json_real;
  typedef json_bool;
  typedef json_null;

  // Additional aliases for aggregate types
  typedef json_value json_value_queue_t[$];
  typedef json_value json_value_map_t[string];

  // All types of JSON related errors
  typedef enum {
    // JSON syntax errors
    JSON_ERR_EOF_VALUE,                     // EOF while parsing some JSON value
    JSON_ERR_EOF_OBJECT,                    // EOF while parsing an object
    JSON_ERR_EOF_ARRAY,                     // EOF while parsing an array
    JSON_ERR_EOF_STRING,                    // EOF while parsing a string
    JSON_ERR_EXPECTED_TOKEN,                // Current character should be some expected token
    JSON_ERR_EXPECTED_COLON,                // Current character should be ':'
    JSON_ERR_EXPECTED_OBJECT_COMMA_OR_END,  // Current character should be either ',' or '}'
    JSON_ERR_EXPECTED_ARRAY_COMMA_OR_END,   // Current character should be either ',' or ']'
    JSON_ERR_EXPECTED_DOUBLE_QUOTE,         // Current character should be '"'
    JSON_ERR_EXPECTED_BOOL,                 // Current character should start either 'true' or 'false' sequence
    JSON_ERR_EXPECTED_NULL,                 // Current character should start 'null' sequence
    JSON_ERR_EXPECTED_VALUE,                // Current character should start some JSON value
    JSON_ERR_INVALID_ESCAPE,                // Invaid escape code
    JSON_ERR_INVALID_UNICODE,               // Invaid characters in unicode
    JSON_ERR_INVALID_NUMBER,                // Invaid number
    JSON_ERR_INVALID_OBJECT_KEY,            // String must be used as a key
    JSON_ERR_TRAILING_COMMA,                // Unexpected comma after the last value of object/array
    JSON_ERR_TRAILING_CHARS,                // Unexpected characters after the JSON value
    // IO and generic errors
    JSON_ERR_FILE_NOT_OPENED,               // File opening failed
    JSON_ERR_NOT_IMPLEMENTED,               // Feature is not implemented
    JSON_ERR_INTERNAL                       // Unspecified internal error
  } json_err_e;

  // All kinds of JSON value
  typedef enum {
    JSON_VALUE_OBJECT,
    JSON_VALUE_ARRAY,
    JSON_VALUE_STRING,
    JSON_VALUE_INT,
    JSON_VALUE_REAL,
    JSON_VALUE_BOOL,
    JSON_VALUE_NULL
  } json_value_e;

  // Alias to raise syntax errors in a more compact way
  `define JSON_SYNTAX_ERR(KIND, STR, IDX, DESCR="")\
    json_result::err( \
      .kind(KIND), \
      .description(DESCR), \
      .json_str(STR), \
      .json_str_idx(IDX), \
      .source_file(`__FILE__), \
      .source_line(`__LINE__) \
    )

  // Alias to raise internal error in a more compact way
  `define JSON_INTERNAL_ERR(DESCR="")\
    json_result::err( \
      .kind(JSON_ERR_INTERNAL), \
      .description(DESCR), \
      .source_file(`__FILE__), \
      .source_line(`__LINE__) \
    )

  `include "json_result.sv"
  `include "json_value.sv"
  `include "json_object.sv"
  `include "json_array.sv"
  `include "json_string.sv"
  `include "json_int.sv"
  `include "json_real.sv"
  `include "json_bool.sv"
  `include "json_null.sv"

  `include "json_decoder.sv"

  `undef JSON_SYNTAX_ERR
  `undef JSON_INTERNAL_ERR
endpackage : json_pkg
