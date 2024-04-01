class json_real extends json_value;
  real value;

  // Normal constructor
  extern function new(real value);

  // Create json_real from real
  extern static function json_real from(real value);

  // Get current instance
  extern virtual function json_result#(json_real) as_json_real();

  // Check for current instance class type
  extern virtual function bit is_json_real();

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);
endclass : json_real


function json_real::new(real value);
  this.value = value;
endfunction : new


function json_real json_real::from(real value);
  json_real obj = new(value);
  return obj;
endfunction : from


function json_result#(json_real) json_real::as_json_real();
  return json_result#(json_real)::ok(this);
endfunction : as_json_real


function json_value json_real::clone();
  return json_real::from(this.value);
endfunction : clone


function bit json_real::compare(json_value value);
  json_result#(json_real) casted;
  json_error err;
  json_real rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.as_json_real();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return this.value == rhs.value;
  endcase
endfunction : compare


function bit json_real::is_json_real();
  return 1;
endfunction : is_json_real
