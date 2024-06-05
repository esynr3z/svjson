// Generic JSON value
virtual class json_value implements json_value_encodable;
  // Create deep copy of a value
  pure virtual function json_value clone();

  // Compare with value
  pure virtual function bit compare(json_value value);

  // Try to cast current value to `json_object`
  extern virtual function bit matches_object(output json_object value);

  // Try to cast current value to `json_array`
  extern virtual function bit matches_array(output json_array value);

  // Try to cast current value to `json_string`
  extern virtual function bit matches_string(output json_string value);

  // Try to cast current value to `json_int`
  extern virtual function bit matches_int(output json_int value);

  // Try to cast current value to `json_real`
  extern virtual function bit matches_real(output json_real value);

  // Try to cast current value to `json_bool`
  extern virtual function bit matches_bool(output json_bool value);

  // Try to represent current value as `json_object`
  extern virtual function json_result#(json_object) as_object();

  // Try to represent current value as `json_array`
  extern virtual function json_result#(json_array) as_array();

  // Try to represent current value as `json_string`
  extern virtual function json_result#(json_string) as_string();

  // Try to represent current value as `json_int`
  extern virtual function json_result#(json_int) as_int();

  // Try to represent current value as `json_real`
  extern virtual function json_result#(json_real) as_real();

  // Try to represent current value as `json_bool`
  extern virtual function json_result#(json_bool) as_bool();

  // Check if current value is `json_object`
  extern virtual function bit is_object();

  // Check if current value is `json_array`
  extern virtual function bit is_array();

  // Check if current value is `json_string`
  extern virtual function bit is_string();

  // Check if current value is `json_int`
  extern virtual function bit is_int();

  // Check if current value is `json_real`
  extern virtual function bit is_real();

  // Check if current value is `json_bool`
  extern virtual function bit is_bool();
endclass : json_value


function bit json_value::matches_object(output json_object value);
  return $cast(value, this);
endfunction : matches_object


function bit json_value::matches_array(output json_array value);
  return $cast(value, this);
endfunction : matches_array


function bit json_value::matches_string(output json_string value);
  return $cast(value, this);
endfunction : matches_string


function bit json_value::matches_int(output json_int value);
  return $cast(value, this);
endfunction : matches_int


function bit json_value::matches_real(output json_real value);
  return $cast(value, this);
endfunction : matches_real


function bit json_value::matches_bool(output json_bool value);
  return $cast(value, this);
endfunction : matches_bool


function json_result#(json_object) json_value::as_object();
  json_object value;
  if (this.matches_object(value)) begin
    return json_result#(json_object)::ok(value);
  end else begin
    return json_result#(json_object)::err(json_error::create(json_error::TYPE_CONVERSION));
  end
endfunction : as_object


function json_result#(json_array) json_value::as_array();
  json_array value;
  if (this.matches_array(value)) begin
    return json_result#(json_array)::ok(value);
  end else begin
    return json_result#(json_array)::err(json_error::create(json_error::TYPE_CONVERSION));
  end
endfunction : as_array


function json_result#(json_string) json_value::as_string();
  json_string value;
  if (this.matches_string(value)) begin
    return json_result#(json_string)::ok(value);
  end else begin
    return json_result#(json_string)::err(json_error::create(json_error::TYPE_CONVERSION));
  end
endfunction : as_string


function json_result#(json_int) json_value::as_int();
  json_int value;
  if (this.matches_int(value)) begin
    return json_result#(json_int)::ok(value);
  end else begin
    return json_result#(json_int)::err(json_error::create(json_error::TYPE_CONVERSION));
  end
endfunction : as_int


function json_result#(json_real) json_value::as_real();
  json_real value;
  if (this.matches_real(value)) begin
    return json_result#(json_real)::ok(value);
  end else begin
    return json_result#(json_real)::err(json_error::create(json_error::TYPE_CONVERSION));
  end
endfunction : as_real


function json_result#(json_bool) json_value::as_bool();
  json_bool value;
  if (this.matches_bool(value)) begin
    return json_result#(json_bool)::ok(value);
  end else begin
    return json_result#(json_bool)::err(json_error::create(json_error::TYPE_CONVERSION));
  end
endfunction : as_bool


function bit json_value::is_object();
  json_object value;
  return this.matches_object(value);
endfunction : is_object


function bit json_value::is_array();
  json_array value;
  return this.matches_array(value);
endfunction : is_array


function bit json_value::is_string();
  json_string value;
  return this.matches_string(value);
endfunction : is_string


function bit json_value::is_int();
  json_int value;
  return this.matches_int(value);
endfunction : is_int


function bit json_value::is_real();
  json_real value;
  return this.matches_real(value);
endfunction : is_real


function bit json_value::is_bool();
  json_bool value;
  return this.matches_bool(value);
endfunction : is_bool
