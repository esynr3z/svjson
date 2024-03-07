// Result class to facilitate error handling.
// Inspired by Result<T, E> enumeration and a common way to propagate errors in Rust.
// Additional generic K is added to resolve error kind enumeration.
class json_result#(type T=json_value, type E=json_error, type K=json_error::kind_e);
  local T value;
  local E error;

  // Private constructor to force using `ok()` or `err()`
  extern local function new();

  // Is result OK?
  extern function bit is_ok();

  // Is result error?
  extern function bit is_err();

  // Match result with OK and return value object and 1 on success
  extern function bit matches_ok(output T value);

  // Match result with specific error and return error object and 1 on success
  extern function bit matches_err(input K kind, output E error);

  // Match result with any error and return error object and 1 on success
  extern function bit matches_any_err(output E error);

  // Create OK result
  static function json_result#(T, E, K) ok(T value);
    json_result#(T, E, K) result = new();
    result.value = value;
    return result;
  endfunction : ok

  // Create error result
  static function json_result#(T, E, K) err(E error);
    json_result#(T, E, K) result = new();
    result.error = error;
    return result;
  endfunction : err
endclass : json_result


function json_result::new();
endfunction : new


function bit json_result::is_ok();
  return this.error == null;
endfunction : is_ok


function bit json_result::is_err();
  return !this.is_ok();
endfunction : is_err


function bit json_result::matches_ok(output T value);
  if (this.is_ok()) begin
    value = this.value;
    return 1;
  end else begin
    value = null;
    return 0;
  end
endfunction : matches_ok


function bit json_result::matches_err(input K kind, output E error);
  if (this.is_err() && (this.error.kind == kind)) begin
    error = this.error;
    return 1;
  end else begin
    error = null;
    return 0;
  end
endfunction : matches_err


function bit json_result::matches_any_err(output E error);
  if (this.is_err()) begin
    error = this.error;
    return 1;
  end else begin
    error = null;
    return 0;
  end
endfunction : matches_any_err
