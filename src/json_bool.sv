class json_bool extends json_value;
  bit value;

  // Normal constructor
  extern function new(bit value);

  // Create json_bool from 1-bit value
  extern static function json_bool from(bit value);

  // Get current instance
  extern virtual function json_result#(json_bool) as_json_bool();

  // Check for current instance class type
  extern virtual function bit is_json_bool();

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);
endclass : json_bool


function json_bool::new(bit value);
  this.value = value;
endfunction : new


function json_bool json_bool::from(bit value);
  json_bool obj = new(value);
  return obj;
endfunction : from


function json_result#(json_bool) json_bool::as_json_bool();
  return json_result#(json_bool)::ok(this);
endfunction : as_json_bool


function json_value json_bool::clone();
  return json_bool::from(this.value);
endfunction : clone


function bit json_bool::compare(json_value value);
  json_result#(json_bool) casted;
  json_error err;
  json_bool rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.as_json_bool();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return this.value == rhs.value;
  endcase
endfunction : compare


function bit json_bool::is_json_bool();
  return 1;
endfunction : is_json_bool
