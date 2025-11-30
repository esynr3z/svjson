// Result class to facilitate error handling.
// Inspired by Result<T, E> enumeration and a common way to propagate errors in Rust.
// However, error type is hardcoded for `json_error`.
class json_result#(type VAL_T=json_value);
  protected VAL_T value;
  protected json_error error;

  // Private constructor to force using `ok()` or `err()`
  extern local function new();

  // Is result OK?
  extern virtual function bit is_ok();

  // Is result error?
  extern virtual function bit is_err();

  // Match result with any OK value and return value item and 1 on success
  extern virtual function bit matches_ok(output VAL_T value);

  // Match result with any error and return error item and 1 on success
  extern virtual function bit matches_err(output json_error error);

  // Match result with specific error and return error item and 1 on success
  extern virtual function bit matches_err_eq(input json_error::kind_e kind, output json_error error);

  // Create OK result
  static function json_result#(VAL_T) ok(VAL_T value);
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    json_result#(VAL_T) result = new();
    result.value = value;
    return result;
  endfunction : ok

  // Create error result
  static function json_result#(VAL_T) err(json_error error);
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    json_result#(VAL_T) result = new();
    result.error = error;
    return result;
  endfunction : err

  // Create error result
  virtual function VAL_T unwrap();
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    if (this.is_err()) begin
      this.error.throw_fatal();
    end
    return this.value;
  endfunction : unwrap
endclass : json_result


function json_result::new();
endfunction : new


function bit json_result::is_ok();
  return this.error == null;
endfunction : is_ok


function bit json_result::is_err();
  return !this.is_ok();
endfunction : is_err


function bit json_result::matches_ok(output VAL_T value);
  if (this.is_ok()) begin
    value = this.value;
    return 1;
  end else begin
    return 0;
  end
endfunction : matches_ok


function bit json_result::matches_err(output json_error error);
  if (this.is_err()) begin
    error = this.error;
    return 1;
  end else begin
    return 0;
  end
endfunction : matches_err


function bit json_result::matches_err_eq(input json_error::kind_e kind, output json_error error);
  if (this.is_err() && (this.error.kind == kind)) begin
    error = this.error;
    return 1;
  end else begin
    return 0;
  end
endfunction : matches_err_eq
