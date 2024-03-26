// Base JSON value
virtual class json_value;
  // Create full copy of a value
  pure virtual function json_value clone();

  // Compare with value
  pure virtual function bit compare(json_value value);

  // Get kind of current value
  pure virtual function json_value_e kind();

  // Try to cast current value to `json_object`
  extern virtual function json_result#(json_object) as_json_object();

  // Try to cast current value to `json_array`
  extern virtual function json_result#(json_array) as_json_array();

  // Try to cast current value to `json_string`
  extern virtual function json_result#(json_string) as_json_string();

  // Try to cast current value to `json_int`
  extern virtual function json_result#(json_int) as_json_int();

  // Try to cast current value to `json_real`
  extern virtual function json_result#(json_real) as_json_real();

  // Try to cast current value to `json_bool`
  extern virtual function json_result#(json_bool) as_json_bool();

  // Try to convert current value to map (associative array). Succesfull only for underlying `json_object`.
  // FIXME: this return type does not work in Verilator currently
  //extern virtual function json_result#(json_value_map_t) to_map();

  // Try to convert current value to queue. Succesfull only for underlying `json_array`.
  // FIXME: this return type does not work in Verilator currently
  //extern virtual function json_result#(json_value_queue_t) to_queue();

  // Try to convert current value to string. Succesfull only for underlying `json_string`.
  extern virtual function json_result#(string) to_string();

  // Try to convert current value to integer. Succesfull only for underlying `json_int`.
  extern virtual function json_result#(longint) to_longint();

  // Try to convert current value to real. Succesfull only for underlying `json_real`.
  extern virtual function json_result#(real) to_real();

  // Try to convert current value to 1-bit (bool). Succesfull only for underlying `json_bool`.
  extern virtual function json_result#(bit) to_bit();

  // Check if current value is `json_object`
  extern virtual function bit is_json_object();

  // Check if current value is `json_array`
  extern virtual function bit is_json_array();

  // Check if current value is `json_string`
  extern virtual function bit is_json_string();

  // Check if current value is `json_int`
  extern virtual function bit is_json_int();

  // Check if current value is `json_real`
  extern virtual function bit is_json_real();

  // Check if current value is `json_bool`
  extern virtual function bit is_json_bool();
endclass : json_value


function json_result#(json_object) json_value::as_json_object();
  return json_result#(json_object)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : as_json_object


function json_result#(json_array) json_value::as_json_array();
  return json_result#(json_array)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : as_json_array


function json_result#(json_string) json_value::as_json_string();
  return json_result#(json_string)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : as_json_string


function json_result#(json_int) json_value::as_json_int();
  return json_result#(json_int)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : as_json_int


function json_result#(json_real) json_value::as_json_real();
  return json_result#(json_real)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : as_json_real


function json_result#(json_bool) json_value::as_json_bool();
  return json_result#(json_bool)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : as_json_bool


function json_result#(string) json_value::to_string();
  return json_result#(string)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : to_string


function json_result#(longint) json_value::to_longint();
  return json_result#(longint)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : to_longint


function json_result#(real) json_value::to_real();
  return json_result#(real)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : to_real


function json_result#(bit) json_value::to_bit();
  return json_result#(bit)::err(json_error::create(json_error::TYPE_CONVERSION));
endfunction : to_bit


function bit json_value::is_json_object();
  return 0;
endfunction : is_json_object


function bit json_value::is_json_array();
  return 0;
endfunction : is_json_array


function bit json_value::is_json_string();
  return 0;
endfunction : is_json_string


function bit json_value::is_json_int();
  return 0;
endfunction : is_json_int


function bit json_value::is_json_real();
  return 0;
endfunction : is_json_real


function bit json_value::is_json_bool();
  return 0;
endfunction : is_json_bool
