class json_string extends json_value;
  string value;

  // Normal constructor
  extern function new(string value);

  // Create `json_string` from string
  extern static function json_string from(string value);

  // Get current instance
  extern virtual function json_result#(json_string) as_json_string();

  // Check for current instance class type
  extern virtual function bit is_json_string();

  // Get current value
  extern virtual function json_result#(string) to_string();

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get kind of current instance
  extern virtual function json_value_e kind();
endclass : json_string


function json_string::new(string value);
  this.value = value;
endfunction : new


function json_string json_string::from(string value);
  json_string obj = new(value);
  return obj;
endfunction : from


function json_result#(json_string) json_string::as_json_string();
  return json_result#(json_string)::ok(this);
endfunction : as_json_string


function json_result#(string) json_string::to_string();
  return json_result#(string)::ok(this.value);
endfunction : to_string


function json_value json_string::clone();
  return json_string::from(this.value);
endfunction : clone


function bit json_string::compare(json_value value);
  json_result#(json_string) casted;
  json_error err;
  json_string rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.as_json_string();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return this.value == rhs.value;
  endcase
endfunction : compare


function json_value_e json_string::kind();
  return JSON_VALUE_STRING;
endfunction : kind


function bit json_string::is_json_string();
  return 1;
endfunction : is_json_string
