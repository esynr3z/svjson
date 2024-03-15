class json_int extends json_value;
  protected longint value;

  // Normal constructor
  extern function new(longint value);

  // Static constructor using type
  extern static function json_int create(longint value);

  // Get native longint type
  extern virtual function longint to_native();

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


function json_int json_int::create(longint value);
  json_int obj = new(value);
  return obj;
endfunction : create


function longint json_int::to_native();
  return this.value;
endfunction : to_native


function json_value json_int::clone();
  return json_int::create(this.value);
endfunction : clone


function bit json_int::compare(json_value value);
  return value.is_json_int() && (value.as_json_int().unwrap().to_native() == this.value);
endfunction : compare


function json_value_e json_int::kind();
  return JSON_VALUE_INT;
endfunction : kind
