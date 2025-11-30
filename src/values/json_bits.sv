// JSON bit vector.
// This wrapper class represents SV bit vector value as standard JSON string.
// Purpose of this class is to facilitate using SV bit vectors of arbitrary size
// with JSON decoder/encoder. As a result, any number, that cannot be represented
// as JSON number using longint or real, can be represented as a string.
class json_bits #(type BITS_T=bit) extends json_string;
  typedef enum {
    RADIX_DEC,  // Base 10, no prefix
    RADIX_BIN,  // Base 2, 0b prefix
    RADIX_HEX   // Base 16, 0x prefix
  } radix_e;

  // Internal raw value of a bit vector
  protected BITS_T bits_value;

  // Preferred radix for conversion into string
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
  static function json_result#(json_bits#(BITS_T)) try_from(string value);
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    BITS_T bits_value;
    radix_e preferred_radix;

    if ($sscanf(value, "0x%x", bits_value) == 1) begin
      preferred_radix = RADIX_HEX;
    end else if ($sscanf(value, "0b%b", bits_value) == 1) begin
      preferred_radix = RADIX_BIN;
    end else if ($sscanf(value, "%d", bits_value) == 1) begin
      preferred_radix = RADIX_DEC;
    end else begin
      return json_result#(json_bits#(BITS_T))::err(json_error::create(json_error::TYPE_CONVERSION));
    end

    return json_result#(json_bits#(BITS_T))::ok(json_bits#(BITS_T)::from(bits_value, preferred_radix));
  endfunction : try_from

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get internal string value
  extern virtual function string get();

  // Set internal string value.
  // Important: error propagation is not expected here, so if string cannot be converted to valid bit vector,
  // fatal error is thrown.
  extern virtual function void set(string value);

  // Get internal bit vector value
  virtual function BITS_T get_bits();
    // FIXME: extern is not used here, because verilator does not work well with parametrized return type
    return this.bits_value;
  endfunction : get_bits

  // Set internal bit vector value
  extern virtual function void set_bits(BITS_T value);
endclass : json_bits


function json_bits::new(BITS_T value, radix_e preferred_radix=RADIX_DEC);
  super.new("");
  this.bits_value = value;
endfunction : new


function json_value json_bits::clone();
  return json_bits#(BITS_T)::from(get_bits(), this.preferred_radix);
endfunction : clone


function bit json_bits::compare(json_value value);
  json_bits#(BITS_T) rhs;

  if (value == null) begin
    return 0;
  end else if ($cast(rhs, value)) begin
    return get_bits() == rhs.get_bits();
  end else begin
    return 0;
  end
endfunction : compare


function string json_bits::get();
  case (this.preferred_radix)
    RADIX_DEC  : return $sformatf("%0d", get_bits());
    RADIX_BIN  : return $sformatf("0b%0b", get_bits());
    RADIX_HEX  : return $sformatf("0x%0x", get_bits());
  endcase
endfunction : get


function void json_bits::set(string value);
  set_bits(json_bits#(BITS_T)::try_from(value).unwrap().get_bits());
endfunction : set


function void json_bits::set_bits(BITS_T value);
  this.bits_value = value;
endfunction : set_bits
