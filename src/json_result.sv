// Result class to facilitate error handling.
// Inspired by Result<T, E> enumeration and a common way to propagate errors in Rust.
class json_result;
  local typedef enum {
    OK,
    ERR
  } status_e;
  local status_e status;

  json_value value;

  json_err_e err_kind;
  string err_description;
  string err_file;
  int err_line;
  string err_json_str;
  int err_json_str_idx;

  // Is result OK?
  extern function bit is_ok();

  // Is result ERR?
  extern function bit is_err();

  // Construct error message
  extern function string get_err_message();

  // Create OK result
  extern static function json_result ok(json_value value);

  // Create result for generic error
  extern static function json_result err(
    json_err_e kind,
    string description="",
    string json_str="",
    int json_str_idx=-1,
    string source_file="",
    int source_line=-1
  );
endclass : json_result


function bit json_result::is_ok();
  return this.status == OK;
endfunction : is_ok


function bit json_result::is_err();
  return this.status == ERR;
endfunction : is_err


function json_result json_result::ok(json_value value);
  json_result result = new();

  result.status = OK;
  result.value = value;

  return result;
endfunction : ok


function json_result json_result::err(
  json_err_e kind,
  string description="",
  string json_str="",
  int json_str_idx=-1,
  string source_file="",
  int source_line=-1
);
  json_result result = new();

  result.status = ERR;
  result.err_kind = kind;
  result.err_description = description;
  result.err_json_str = json_str;
  result.err_json_str_idx = json_str_idx;
  result.err_file = source_file;
  result.err_line = source_line;

  return result;
endfunction : err


function string json_result::get_err_message();
  return "get_err_message() is not implemented yet";
endfunction : get_err_message
