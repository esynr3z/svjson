class json_bool extends json_value;
  protected bit value;

  // Normal constructor
  extern function new(bit value);

  // Static constructor using type
  extern static function json_bool create(bit value);

  // Get native bit type
  extern virtual function bit to_native();

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


function json_bool json_bool::create(bit value);
  json_bool obj = new(value);
  return obj;
endfunction : create


function bit json_bool::to_native();
  return this.value;
endfunction : to_native


function json_value json_bool::clone();
  return json_bool::create(this.value);
endfunction : clone


function bit json_bool::compare(json_value value);
  return value.is_json_bool() && (value.as_json_bool().unwrap().to_native() == this.value);
endfunction : compare


function json_value_e json_bool::kind();
  return JSON_VALUE_BOOL;
endfunction : kind
