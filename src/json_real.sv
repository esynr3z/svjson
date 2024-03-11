class json_real extends json_value;
  protected real value;

  // Normal constructor
  extern function new(real value);

  // Static constructor using type
  extern static function json_real create(real value);

  // Get native real type
  extern virtual function real unwrap();
endclass : json_real


function json_real::new(real value);
  this.value = value;
endfunction : new


function json_real json_real::create(real value);
  json_real obj = new(value);
  return obj;
endfunction : create


function real json_real::unwrap();
  return this.value;
endfunction : unwrap
