// JSON number value - integer
class json_int extends json_value implements json_int_encodable;
  longint value;

  // Normal constructor
  extern function new(longint value);

  // Create json_int from longint
  extern static function json_int from(longint value);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Interface json_int_encodable
  extern virtual function longint get_value();
endclass : json_int


function json_int::new(longint value);
  this.value = value;
endfunction : new


function json_int json_int::from(longint value);
  json_int obj = new(value);
  return obj;
endfunction : from


function json_value json_int::clone();
  return json_int::from(this.value);
endfunction : clone


function bit json_int::compare(json_value value);
  json_result#(json_int) casted;
  json_error err;
  json_int rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.as_json_int();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): return this.value == rhs.value;
  endcase
endfunction : compare


function longint json_int::get_value();
  return this.value;
endfunction : get_value
