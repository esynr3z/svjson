class json_null extends json_value;

  // Normal constructor
  extern function new();

  // Static constructor using type
  extern static function json_null create();

  // Get current instance
  extern virtual function json_result#(json_null) as_json_null();

  // Check for current instance class type
  extern virtual function bit is_json_null();

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get kind of current instance
  extern virtual function json_value_e kind();
endclass : json_null


function json_null::new();
endfunction : new


function json_null json_null::create();
  json_null obj = new();
  return obj;
endfunction : create


function json_result#(json_null) json_null::as_json_null();
  return json_result#(json_null)::ok(this);
endfunction : as_json_null


function json_value json_null::clone();
  return json_null::create();
endfunction : clone


function bit json_null::compare(json_value value);
  return value.is_json_null();
endfunction : compare


function json_value_e json_null::kind();
  return JSON_VALUE_NULL;
endfunction : kind


function bit json_null::is_json_null();
  return 1;
endfunction : is_json_null
