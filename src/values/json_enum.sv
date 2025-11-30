// JSON enum.
// This wrapper class represents SV enum value as standard JSON string.
// Purpose of this class is to facilitate using SV enum with JSON decoder/encoder.
class json_enum #(type ENUM_T) extends json_string;
  // Internal raw value of enum
  protected ENUM_T enum_value;

  // Normal constructor
  extern function new(ENUM_T value);

  // Create `json_enum` from enum
  static function json_enum#(ENUM_T) from(ENUM_T value);
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    json_enum#(ENUM_T) obj = new(value);
    return obj;
  endfunction : from

  // Try to create `json_enum` from string
  static function json_result#(json_enum#(ENUM_T)) try_from(string value);
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    for (ENUM_T e = e.first();; e = e.next()) begin
      if (e.name() == value) begin
        return json_result#(json_enum#(ENUM_T))::ok(json_enum#(ENUM_T)::from(e));
      end
      if (e == e.last()) begin
        break;
      end
    end

    return json_result#(json_enum#(ENUM_T))::err(json_error::create(json_error::TYPE_CONVERSION));
  endfunction : try_from

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get internal string value
  extern virtual function string get();

  // Set internal string value.
  // Important: error propagation is not expected here, so if string cannot be converted to valid enum,
  // fatal error is thrown.
  extern virtual function void set(string value);

  // Get internal enum value
  virtual function ENUM_T get_enum();
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    return this.enum_value;
  endfunction : get_enum

  // Set internal enum value
  extern virtual function void set_enum(ENUM_T value);
endclass : json_enum


function json_enum::new(ENUM_T value);
  super.new("");
  this.enum_value = value;
endfunction : new


function json_value json_enum::clone();
  return json_enum#(ENUM_T)::from(get_enum());
endfunction : clone


function bit json_enum::compare(json_value value);
  json_enum#(ENUM_T) rhs;

  if (value == null) begin
    return 0;
  end else if ($cast(rhs, value)) begin
    return get_enum() == rhs.get_enum();
  end else begin
    return 0;
  end
endfunction : compare


function string json_enum::get();
  return get_enum().name();
endfunction : get


function void json_enum::set(string value);
  set_enum(json_enum#(ENUM_T)::try_from(value).unwrap().get_enum());
endfunction : set


function void json_enum::set_enum(ENUM_T value);
  this.enum_value = value;
endfunction : set_enum
