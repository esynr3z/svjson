class json_null extends json_value;

  // Normal constructor
  extern function new();

  // Static constructor using type
  extern static function json_null create();

  // Get native type (returns null)
  extern virtual function json_value to_native();
endclass : json_null


function json_null::new();
endfunction : new


function json_null json_null::create();
  json_null obj = new();
  return obj;
endfunction : create


function json_value json_null::to_native();
  return null;
endfunction : to_native
