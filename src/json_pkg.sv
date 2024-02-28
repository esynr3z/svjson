package json_pkg;

  // Forward declarations
  typedef json_value;
  typedef json_object;
  typedef json_array;
  typedef json_string;
  typedef json_number;
  typedef json_bool;
  typedef json_null;

  typedef enum {
    JSON_ERR_NON_WHITESPACE_NOT_FOUND,
    JSON_ERR_UNEXPECTED_SYMBOL,
    JSON_ERR_OPEN_FILE
  } json_err_e;
  `include "json_result.sv"

  `include "json_value.sv"
  `include "json_object.sv"
  `include "json_array.sv"
  `include "json_string.sv"
  `include "json_number.sv"
  `include "json_bool.sv"
  `include "json_null.sv"

  `include "json_decoder.sv"
endpackage : json_pkg
