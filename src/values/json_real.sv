// JSON real number.
// This wrapper class represents standard JSON number value type using SV real.
// JSON does not specify requirements for number types, but it is more
// convenient to operate with integers and real numbers separately.
// This class covers real numbers.
class json_real extends json_value implements json_real_encodable;
  // Internal raw value
  protected real value;

  // Normal constructor
  extern function new(real value);

  // Create json_real from real
  extern static function json_real from(real value);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance.
  // Return 1 if instances are equal and 0 otherwise.
  extern virtual function bit compare(json_value value);

  // Get internal real value
  extern virtual function real get();

  // Set internal real value
  extern virtual function void set(real value);

  // Get value encodable as JSON real number (for interface json_real_encodable)
  extern virtual function real to_json_encodable();
endclass : json_real


function json_real::new(real value);
  this.value = value;
endfunction : new


function json_real json_real::from(real value);
  json_real obj = new(value);
  return obj;
endfunction : from


function json_value json_real::clone();
  return json_real::from(get());
endfunction : clone


function bit json_real::compare(json_value value);
  json_result#(json_real) casted;
  json_error err;
  json_real rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.try_into_real();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return get() == rhs.get();
  endcase
endfunction : compare


function real json_real::get();
  return this.value;
endfunction : get


function void json_real::set(real value);
  this.value = value;
endfunction : set


function real json_real::to_json_encodable();
  return get();
endfunction : to_json_encodable
