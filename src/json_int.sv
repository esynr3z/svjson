class json_int extends json_value;
  longint value;

  // Normal constructor
  extern function new(longint value);

  // Create json_int from longint
  extern static function json_int from(longint value);

  // Return current value (override default implementation)
  extern virtual function json_result#(json_int) as_json_int();

  // Create full copy of a value
  extern virtual function json_value clone();

  // Compare with value
  extern virtual function bit compare(json_value value);

  // Get kind of current value
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


function json_value json_int::clone();
  return json_int::from(this.value);
endfunction : clone


function bit json_int::compare(json_value value);
  return value.is_json_int() && (value.as_json_int().unwrap().value == this.value);
endfunction : compare


function json_value_e json_int::kind();
  return JSON_VALUE_INT;
endfunction : kind
