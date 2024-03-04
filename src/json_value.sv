// Base JSON value
virtual class json_value;
  pure virtual function json_value clone();
  pure virtual function bit compare(json_value value);
  pure virtual function json_value_e kind();

  extern function json_value as_json_value();
  extern function json_object as_json_object();
  //extern function json_array as_json_array();
  extern function json_string as_json_string();
  //extern function json_int as_json_int();
  //extern function json_real as_json_real();
  //extern function json_bool as_json_bool();
  //extern function json_null as_json_null();

  extern function bit is_json_object();
  //extern function bit is_json_array();
  extern function bit is_json_string();
  //extern function bit is_json_int();
  //extern function bit is_json_real();
  //extern function bit is_json_bool();
  //extern function bit is_json_null();

endclass : json_value


function json_value json_value::as_json_value();
  return this;
endfunction : as_json_value


function json_object json_value::as_json_object();
  $cast(as_json_object, this);
endfunction : as_json_object


function json_string json_value::as_json_string();
  $cast(as_json_string, this);
endfunction : as_json_string


function bit json_value::is_json_object();
  return (this.kind() == JSON_VALUE_OBJECT);
endfunction : is_json_object


function bit json_value::is_json_string();
  return (this.kind() == JSON_VALUE_STRING);
endfunction : is_json_string
