class json_string extends json_value;
  protected string value;

  // Normal constructor
  extern function new(string value);

  // Static constructor using type
  extern static function json_string create(string value);

  // Get native string type
  extern virtual function string to_native();

  // Create full copy of a value
  extern virtual function json_value clone();

  // Compare with value
  extern virtual function bit compare(json_value value);

  // Get kind of current value
  extern virtual function json_value_e kind();
endclass : json_string


function json_string::new(string value);
  this.value = value;
endfunction : new


function json_string json_string::create(string value);
  json_string obj = new(value);
  return obj;
endfunction : create


function string json_string::to_native();
  return this.value;
endfunction : to_native


function json_value json_string::clone();
  return json_string::create(this.value);
endfunction : clone


function bit json_string::compare(json_value value);
  return value.is_json_string() && (value.as_json_string().unwrap().to_native() == this.value);
endfunction : compare


function json_value_e json_string::kind();
  return JSON_VALUE_STRING;
endfunction : kind
