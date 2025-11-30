// JSON bool.
// This wrapper class represents standard JSON bool value type using SV bit.
class json_bool extends json_value implements json_bool_encodable;
  // Internal raw value
  protected bit value;

  // Normal constructor
  extern function new(bit value);

  // Create json_bool from 1-bit value
  extern static function json_bool from(bit value);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance.
  // Return 1 if instances are equal and 0 otherwise.
  extern virtual function bit compare(json_value value);

  // Get internal 1-bit value
  extern virtual function bit get();

  // Set internal 1-bit value
  extern virtual function void set(bit value);

  // Get value encodable as JSON bool (for interface json_bool_encodable)
  extern virtual function bit to_json_encodable();
endclass : json_bool


function json_bool::new(bit value);
  this.value = value;
endfunction : new


function json_bool json_bool::from(bit value);
  json_bool obj = new(value);
  return obj;
endfunction : from


function json_value json_bool::clone();
  return json_bool::from(get());
endfunction : clone


function bit json_bool::compare(json_value value);
  json_result#(json_bool) casted;
  json_error err;
  json_bool rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.try_into_bool();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return get() == rhs.get();
  endcase
endfunction : compare


function bit json_bool::get();
  return this.value;
endfunction : get


function void json_bool::set(bit value);
  this.value = value;
endfunction : set


function bit json_bool::to_json_encodable();
  return get();
endfunction : to_json_encodable
