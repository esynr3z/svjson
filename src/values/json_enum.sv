// JSON enum value
class json_enum #(type ENUM_T) extends json_string;
  ENUM_T enum_value;

  // Normal constructor
  extern function new(ENUM_T value);

  // Create `json_enum` from enum
  static function json_enum#(ENUM_T) from(ENUM_T value);
    json_enum#(ENUM_T) obj = new(value);
    return obj;
  endfunction : from

  // Try to create `json_enum` from string
  static function json_result#(json_enum#(ENUM_T)) from_string(string value);
    return json_result#(json_enum#(ENUM_T))::err(json_error::create(json_error::TYPE_CONVERSION));
  endfunction : from_string

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Interface json_string_encodable
  extern virtual function string get_value();
endclass : json_enum


function json_enum::new(ENUM_T value);
  this.enum_value = value;
endfunction : new


function json_value json_enum::clone();
  return json_enum#(ENUM_T)::from(this.value);
endfunction : clone


function bit json_enum::compare(json_value value);
  json_enum#(ENUM_T) rhs;

  if (value == null) begin
    return 0;
  end

  if ($cast(rhs, value)) begin
    return this.value == rhs.value;
  end else begin
    return 0;
  end
endfunction : compare


function string json_enum::get_value();
  return this.enum_value.name();
endfunction : get_value
