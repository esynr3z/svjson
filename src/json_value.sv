// Base JSON value
virtual class json_value;
  // Create full copy of a value
  pure virtual function json_value clone();

  // Compare with value
  pure virtual function bit compare(json_value value);

  // Get kind of current value
  pure virtual function json_value_e kind();

  // Cast current value to `json_value`
  extern function json_result#(json_value) as_json_value();

  // Cast current value to `json_object`
  extern function json_result#(json_object) as_json_object();

  // Cast current value to `json_array`
  extern function json_result#(json_array) as_json_array();

  // Cast current value to `json_string`
  extern function json_result#(json_string) as_json_string();

  // Cast current value to `json_int`
  extern function json_result#(json_int) as_json_int();

  // Cast current value to `json_real`
  extern function json_result#(json_real) as_json_real();

  // Cast current value to `json_bool`
  extern function json_result#(json_bool) as_json_bool();

  // Cast current value to `json_null`
  extern function json_result#(json_null) as_json_null();

  // Check if current value is `json_object`
  extern function bit is_json_object();

  // Check if current value is `json_array`
  extern function bit is_json_array();

  // Check if current value is `json_string`
  extern function bit is_json_string();

  // Check if current value is `json_int`
  extern function bit is_json_int();

  // Check if current value is `json_real`
  extern function bit is_json_real();

  // Check if current value is `json_bool`
  extern function bit is_json_bool();

  // Check if current value is `json_null`
  extern function bit is_json_null();
endclass : json_value


function json_result#(json_value) json_value::as_json_value();
  return json_result#(json_value)::ok(this);
endfunction : as_json_value


function json_result#(json_object) json_value::as_json_object();
  json_object val;
  if ($cast(val, this)) begin
    return json_result#(json_object)::ok(val);
  end else begin
    return json_result#(json_object)::err(json_error::create(json_error::CAST_FAILED));
  end
endfunction : as_json_object


function json_result#(json_array) json_value::as_json_array();
  json_array val;
  if ($cast(val, this)) begin
    return json_result#(json_array)::ok(val);
  end else begin
    return json_result#(json_array)::err(json_error::create(json_error::CAST_FAILED));
  end
endfunction : as_json_array


function json_result#(json_string) json_value::as_json_string();
  json_string val;
  if ($cast(val, this)) begin
    return json_result#(json_string)::ok(val);
  end else begin
    return json_result#(json_string)::err(json_error::create(json_error::CAST_FAILED));
  end
endfunction : as_json_string


function json_result#(json_int) json_value::as_json_int();
  json_int val;
  if ($cast(val, this)) begin
    return json_result#(json_int)::ok(val);
  end else begin
    return json_result#(json_int)::err(json_error::create(json_error::CAST_FAILED));
  end
endfunction : as_json_int


function json_result#(json_real) json_value::as_json_real();
  json_real val;
  if ($cast(val, this)) begin
    return json_result#(json_real)::ok(val);
  end else begin
    return json_result#(json_real)::err(json_error::create(json_error::CAST_FAILED));
  end
endfunction : as_json_real


function json_result#(json_bool) json_value::as_json_bool();
  json_bool val;
  if ($cast(val, this)) begin
    return json_result#(json_bool)::ok(val);
  end else begin
    return json_result#(json_bool)::err(json_error::create(json_error::CAST_FAILED));
  end
endfunction : as_json_bool


function json_result#(json_null) json_value::as_json_null();
  json_null val;
  if ($cast(val, this)) begin
    return json_result#(json_null)::ok(val);
  end else begin
    return json_result#(json_null)::err(json_error::create(json_error::CAST_FAILED));
  end
endfunction : as_json_null


function bit json_value::is_json_object();
  return (this.kind() == JSON_VALUE_OBJECT);
endfunction : is_json_object


function bit json_value::is_json_array();
  return (this.kind() == JSON_VALUE_ARRAY);
endfunction : is_json_array


function bit json_value::is_json_string();
  return (this.kind() == JSON_VALUE_STRING);
endfunction : is_json_string


function bit json_value::is_json_int();
  return (this.kind() == JSON_VALUE_INT);
endfunction : is_json_int


function bit json_value::is_json_real();
  return (this.kind() == JSON_VALUE_REAL);
endfunction : is_json_real


function bit json_value::is_json_bool();
  return (this.kind() == JSON_VALUE_BOOL);
endfunction : is_json_bool


function bit json_value::is_json_null();
  return (this.kind() == JSON_VALUE_NULL);
endfunction : is_json_null
