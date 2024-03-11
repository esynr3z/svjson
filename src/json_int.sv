class json_int extends json_value;
  protected longint value;

  // Normal constructor
  extern function new(longint value);

  // Static constructor using type
  extern static function json_int create(longint value);

  // Get native longint type
  extern virtual function real to_native();
endclass : json_int


function json_int::new(longint value);
  this.value = value;
endfunction : new


function json_int json_int::create(longint value);
  json_int obj = new(value);
  return obj;
endfunction : create


function real json_int::to_native();
  return this.value;
endfunction : to_native
