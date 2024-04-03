// JSON number value - real
class json_real extends json_value implements json_real_encodable;
  real value;

  // Normal constructor
  extern function new(real value);

  // Create json_real from real
  extern static function json_real from(real value);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Interface json_real_encodable
  extern virtual function real get_value();
endclass : json_real


function json_real::new(real value);
  this.value = value;
endfunction : new


function json_real json_real::from(real value);
  json_real obj = new(value);
  return obj;
endfunction : from


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


function real json_real::get_value();
  return this.value;
endfunction : get_value
