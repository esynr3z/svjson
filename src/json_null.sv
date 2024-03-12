class json_null extends json_value;

  // Normal constructor
  extern function new();

  // Static constructor using type
  extern static function json_null create();

  // Get native type (returns null)
  extern virtual function json_value to_native();

  // Create full copy of a value
  extern virtual function json_value clone();

  // Compare with value
  extern virtual function bit compare(json_value value);

  // Get kind of current value
  extern virtual function json_value_e kind();
endclass : json_null


function json_null::new();
endfunction : new


function json_null json_null::create();
  json_null obj = new();
  return obj;
endfunction : create


function json_value json_null::to_native();
  return null;
endfunction : to_native


function json_value json_null::clone();
  return json_null::create();
endfunction : clone


function bit json_null::compare(json_value value);
  return value.is_json_null();
endfunction : compare


function json_value_e json_null::kind();
  return JSON_VALUE_NULL;
endfunction : kind
