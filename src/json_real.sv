class json_real extends json_value;
  real value;

  // Normal constructor
  extern function new(real value);

  // Create json_real from real
  extern static function json_real from(real value);

  // Return current object (override default implementation)
  extern virtual function json_result#(json_real) as_json_real();

  // Return current value (override default implementation)
  extern virtual function json_result#(real) to_real();

  // Create full copy of a value
  extern virtual function json_value clone();

  // Compare with value
  extern virtual function bit compare(json_value value);

  // Get kind of current value
  extern virtual function json_value_e kind();
endclass : json_real


function json_real::new(real value);
  this.value = value;
endfunction : new


function json_real json_real::from(real value);
  json_real obj = new(value);
  return obj;
endfunction : from


function json_result#(json_real) json_real::as_json_real();
  return json_result#(json_real)::ok(this);
endfunction : as_json_real


function json_result#(real) json_real::to_real();
  return json_result#(real)::ok(this.value);
endfunction : to_real


function json_value json_real::clone();
  return json_real::from(this.value);
endfunction : clone


function bit json_real::compare(json_value value);
  return value.is_json_real() && (value.as_json_real().unwrap().value == this.value);
endfunction : compare


function json_value_e json_real::kind();
  return JSON_VALUE_REAL;
endfunction : kind
