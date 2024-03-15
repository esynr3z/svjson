class json_bool extends json_value;
  bit value;

  // Normal constructor
  extern function new(bit value);

  // Create json_bool from 1-bit value
  extern static function json_bool from(bit value);

  // Return current object (override default implementation)
  extern virtual function json_result#(json_bool) as_json_bool();

  // Return current value (override default implementation)
  extern virtual function json_result#(bit) to_bit();

  // Create full copy of a value
  extern virtual function json_value clone();

  // Compare with value
  extern virtual function bit compare(json_value value);

  // Get kind of current value
  extern virtual function json_value_e kind();
endclass : json_bool


function json_bool::new(bit value);
  this.value = value;
endfunction : new


function json_bool json_bool::from(bit value);
  json_bool obj = new(value);
  return obj;
endfunction : from


function json_result#(json_bool) json_bool::as_json_bool();
  return json_result#(json_bool)::ok(this);
endfunction : as_json_bool


function json_result#(bit) json_bool::to_bit();
  return json_result#(bit)::ok(this.value);
endfunction : to_bit


function json_value json_bool::clone();
  return json_bool::from(this.value);
endfunction : clone


function bit json_bool::compare(json_value value);
  return value.is_json_bool() && (value.as_json_bool().unwrap().value == this.value);
endfunction : compare


function json_value_e json_bool::kind();
  return JSON_VALUE_BOOL;
endfunction : kind
