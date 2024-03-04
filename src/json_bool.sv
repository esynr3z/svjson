class json_bool extends json_value;
  protected bit value;

  // Normal constructor
  extern function new(bit value);

  // Static constructor using type
  extern static function json_bool create(bit value);

  // Get native bit type
  extern virtual function bit unwrap();
endclass : json_bool


function json_bool::new(bit value);
  this.value = value;
endfunction : new


function json_bool json_bool::create(bit value);
  json_bool obj = new(value);
  return obj;
endfunction : create


function bit json_bool::unwrap();
  return this.value;
endfunction : unwrap