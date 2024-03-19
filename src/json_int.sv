class json_int extends json_value;
  longint value;

  // Normal constructor
  extern function new(longint value);

  // Create json_int from longint
  extern static function json_int from(longint value);

  // Get current instance
  extern virtual function json_result#(json_int) as_json_int();

  // Check for current instance class type
  extern virtual function bit is_json_int();

  // Get current value
  extern virtual function json_result#(longint) to_longint();

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get kind of current instance
  extern virtual function json_value_e kind();
endclass : json_int


function json_int::new(longint value);
  this.value = value;
endfunction : new


function json_int json_int::from(longint value);
  json_int obj = new(value);
  return obj;
endfunction : from


function json_result#(json_int) json_int::as_json_int();
  return json_result#(json_int)::ok(this);
endfunction : as_json_int


function json_result#(longint) json_int::to_longint();
  return json_result#(longint)::ok(this.value);
endfunction : to_longint


function json_value json_int::clone();
  return json_int::from(this.value);
endfunction : clone


function bit json_int::compare(json_value value);
  json_result#(json_int) casted;
  json_error err;
  json_int rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.as_json_int();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return this.value == rhs.value;
  endcase
endfunction : compare


function json_value_e json_int::kind();
  return JSON_VALUE_INT;
endfunction : kind


function bit json_int::is_json_int();
  return 1;
endfunction : is_json_int
