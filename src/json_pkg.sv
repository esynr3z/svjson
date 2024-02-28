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
    JSON_ERR_EMPTY_STRING,
    JSON_ERR_DECODE,
    JSON_ERR_OPEN_FILE,
    JSON_ERR_NOT_IMPLEMENTED
  } json_err_e;
  `include "json_result.sv"

  typedef enum {
    JSON_VALUE_OBJECT,
    JSON_VALUE_ARRAY,
    JSON_VALUE_STRING,
    JSON_VALUE_NUMBER,
    JSON_VALUE_BOOL,
    JSON_VALUE_NULL
  } json_value_e;
  `include "json_value.sv"

  `include "json_object.sv"
  `include "json_array.sv"
  `include "json_string.sv"
  `include "json_number.sv"
  `include "json_bool.sv"
  `include "json_null.sv"

  `include "json_decoder.sv"
endpackage : json_pkg
