// Result class to facilitate error handling.
// Inspired by Result<T, E> enumeration in Rust.
//
// FIXME: Verilator does not allow to create extern with parameterized result (verilator#4924),
// that's why some methods are not externs.
class json_result#(type VALUE_T=int);
  typedef enum {
    OK,
    ERR
  } status_e;

  status_e status;
  VALUE_T value;
  string err_message;

  // Is result OK?
  extern function bit is_ok();
  // Is result ERR?
  extern function bit is_err();



  // Create OK result
  static function json_result#(VALUE_T) ok(VALUE_T value);
    json_result#(VALUE_T) result = new();

    result.status = OK;
    result.value = value;

    return result;
  endfunction : ok

  // Create ERR result
  static function json_result#(VALUE_T) err(string message);
    json_result#(VALUE_T) result = new();

    result.status = ERR;
    result.err_message = message;

    return result;
  endfunction : err
endclass : json_result


function bit json_result::is_ok();
  return this.status == OK;
endfunction : is_ok


function bit json_result::is_err();
  return this.status == ERR;
endfunction : is_err
