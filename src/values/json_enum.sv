// JSON enum value
class json_enum #(type ENUM_T) extends json_string;
  ENUM_T enum_value;

  // Normal constructor
  extern function new(ENUM_T value);

  // Create `json_enum` from enum
  static function json_enum#(ENUM_T) from(ENUM_T value);
    // FIXME: extern is not used here, because verialtor does not work well with parametrized return type
    json_enum#(ENUM_T) obj = new(value);
    return obj;
  endfunction : from

  // Try to create `json_enum` from string
  static function json_result#(json_enum#(ENUM_T)) from_string(string value);
    // FIXME: extern is not used here, because verialtor does not work well with parametrized return type
    for (ENUM_T e = e.first();; e = e.next()) begin
      if (e.name() == value) begin
        return json_result#(json_enum#(ENUM_T))::ok(json_enum#(ENUM_T)::from(e));
      end
      if (e == e.last()) begin
        break;
      end
    end
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
  super.new(value.name());
  this.enum_value = value;
endfunction : new


function json_value json_enum::clone();
  return json_enum#(ENUM_T)::from(this.enum_value);
endfunction : clone


function bit json_enum::compare(json_value value);
  json_enum#(ENUM_T) rhs;
  bit res = super.compare(value);

  if (value == null) begin
    res = 0;
  end else if ($cast(rhs, value)) begin
    res &= this.enum_value == rhs.enum_value;
  end else begin
    res = 0;
  end

  return res;
endfunction : compare


function string json_enum::get_value();
  return this.enum_value.name();
endfunction : get_value
