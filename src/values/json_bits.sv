// JSON bit vector value
class json_bits #(type BITS_T) extends json_string;
  typedef enum {
    RADIX_DEC,  // Base 10, no prefix
    RADIX_BIN,  // Base 2, 0b prefix
    RADIX_HEX   // Base 16, 0x prefix
  } radix_e;

  BITS_T bit_vector;
  radix_e preferred_radix;

  // Normal constructor
  extern function new(BITS_T value, radix_e preferred_radix=RADIX_DEC);

  // Create `json_bits` from enum
  static function json_bits#(BITS_T) from(BITS_T value, radix_e preferred_radix=RADIX_DEC);
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    json_bits#(BITS_T) obj = new(value, preferred_radix);
    return obj;
  endfunction : from

  // Try to create `json_bits` from string
  static function json_result#(json_bits#(BITS_T)) from_string(string value);
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    BITS_T bit_vector;
    radix_e preferred_radix;

    if ($sscanf(value, "0x%x", bit_vector) == 1) begin
      preferred_radix = RADIX_HEX;
    end else if ($sscanf(value, "0b%b", bit_vector) == 1) begin
      preferred_radix = RADIX_BIN;
    end else if ($sscanf(value, "%d", bit_vector) == 1) begin
      preferred_radix = RADIX_DEC;
    end else begin
      return json_result#(json_bits#(BITS_T))::err(json_error::create(json_error::TYPE_CONVERSION));
    end

    return json_result#(json_bits#(BITS_T))::ok(json_bits#(BITS_T)::from(bit_vector, preferred_radix));
  endfunction : from_string

  // Create string from bit vector
  extern static function string to_string(BITS_T value, radix_e preferred_radix=RADIX_DEC);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Interface json_string_encodable
  extern virtual function string get_value();
endclass : json_bits


function json_bits::new(BITS_T value, radix_e preferred_radix=RADIX_DEC);
  super.new(json_bits#(BITS_T)::to_string(value, preferred_radix));
  this.bit_vector = value;
endfunction : new


function string json_bits::to_string(BITS_T value, radix_e preferred_radix=RADIX_DEC);
  case (preferred_radix)
    RADIX_DEC  : return $sformatf("%0d", value);
    RADIX_BIN  : return $sformatf("0b%0b", value);
    RADIX_HEX  : return $sformatf("0x%0x", value);
  endcase
endfunction : to_string


function json_value json_bits::clone();
  return json_bits#(BITS_T)::from(this.bit_vector, this.preferred_radix);
endfunction : clone


function bit json_bits::compare(json_value value);
  json_bits#(BITS_T) rhs;
  bit res = super.compare(value);

  if (value == null) begin
    res = 0;
  end else if ($cast(rhs, value)) begin
    res &= this.bit_vector == rhs.bit_vector;
  end else begin
    res = 0;
  end

  return res;
endfunction : compare


function string json_bits::get_value();
  return json_bits#(BITS_T)::to_string(this.bit_vector, this.preferred_radix);
endfunction : get_value
