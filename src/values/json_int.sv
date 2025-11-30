// JSON integer number.
// This wrapper class represents standard JSON number value using SV longint.
// JSON does not specify requirements for number types, but it is more
// convenient to operate with integers and real numbers separately.
// This class covers integers.
class json_int extends json_value implements json_int_encodable;
  // Internal raw value
  protected longint value;

  // Normal constructor
  extern function new(longint value);

  // Create json_int from longint
  extern static function json_int from(longint value);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance.
  // Return 1 if instances are equal and 0 otherwise.
  extern virtual function bit compare(json_value value);

  // Get internal longint value
  extern virtual function longint get();

  // Set internal longint value
  extern virtual function void set(longint value);

  // Get value encodable as JSON integer number (for interface json_int_encodable)
  extern virtual function longint to_json_encodable();
endclass : json_int


function json_int::new(longint value);
  this.value = value;
endfunction : new


function json_int json_int::from(longint value);
  json_int obj = new(value);
  return obj;
endfunction : from


function json_value json_int::clone();
  return json_int::from(get());
endfunction : clone


function bit json_int::compare(json_value value);
  json_result#(json_int) casted;
  json_error err;
  json_int rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.try_into_int();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return get() == rhs.get();
  endcase
endfunction : compare


function longint json_int::get();
  return this.value;
endfunction : get


function void json_int::set(longint value);
  this.value = value;
endfunction : set


function longint json_int::to_json_encodable();
  return get();
endfunction : to_json_encodable
