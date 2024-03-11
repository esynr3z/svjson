class json_real extends json_value;
  protected real value;

  // Normal constructor
  extern function new(real value);

  // Static constructor using type
  extern static function json_real create(real value);

  // Get native real type
  extern virtual function real to_native();
endclass : json_real


function json_real::new(real value);
  this.value = value;
endfunction : new


function json_real json_real::create(real value);
  json_real obj = new(value);
  return obj;
endfunction : create


function real json_real::to_native();
  return this.value;
endfunction : to_native
