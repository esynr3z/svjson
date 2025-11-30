// JSON string.
// This wrapper class represents standard JSON string value type using SV string.
class json_string extends json_value implements json_string_encodable;
  // Internal raw value
  protected string value;

  // Normal constructor
  extern function new(string value);

  // Create `json_string` from string
  extern static function json_string from(string value);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance.
  // Return 1 if instances are equal and 0 otherwise.
  extern virtual function bit compare(json_value value);

  // Get internal string value
  extern virtual function string get();

  // Set internal string value
  extern virtual function void set(string value);

  // Get value encodable as JSON string (for interface json_string_encodable)
  extern virtual function string to_json_encodable();
endclass : json_string


function json_string::new(string value);
  this.value = value;
endfunction : new


function json_string json_string::from(string value);
  json_string obj = new(value);
  return obj;
endfunction : from


function json_value json_string::clone();
  return json_string::from(get());
endfunction : clone


function bit json_string::compare(json_value value);
  json_result#(json_string) casted;
  json_error err;
  json_string rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.try_into_string();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return get() == rhs.get();
  endcase
endfunction : compare


function string json_string::get();
  return this.value;
endfunction : get


function void json_string::set(string value);
  this.value = value;
endfunction : set


function string json_string::to_json_encodable();
  return get();
endfunction : to_json_encodable
