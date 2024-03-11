class json_real extends json_value;
  protected real value;

  // Normal constructor
  extern function new(real value);

  // Static constructor using type
  extern static function json_real create(real value);

  // Get native real type
  extern virtual function real to_native();

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


function json_real json_real::create(real value);
  json_real obj = new(value);
  return obj;
endfunction : create


function real json_real::to_native();
  return this.value;
endfunction : to_native


function json_value json_real::clone();
  return json_real::create(this.value);
endfunction : clone


function bit json_real::compare(json_value value);
  return value.is_json_real() && (value.as_json_real().unwrap().to_native() == this.value);
endfunction : compare


function json_value_e json_real::kind();
  return JSON_VALUE_REAL;
endfunction : kind
