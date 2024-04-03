// JSON bool value
class json_bool extends json_value implements json_bool_encodable;
  bit value;

  // Normal constructor
  extern function new(bit value);

  // Create json_bool from 1-bit value
  extern static function json_bool from(bit value);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Interface json_bool_encodable
  extern virtual function bit get_value();
endclass : json_bool


function json_bool::new(bit value);
  this.value = value;
endfunction : new


function json_bool json_bool::from(bit value);
  json_bool obj = new(value);
  return obj;
endfunction : from


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


function bit json_bool::get_value();
  return this.value;
endfunction : get_value
