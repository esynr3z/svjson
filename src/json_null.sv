class json_null extends json_value;
  // Normal construtor
  extern function new();

  // Static constructor using type
  extern static function json_null create();
endclass : json_null


function json_null::new();
  // Nothing to do
endfunction : new


function json_null json_null::create();
  json_null obj = new();
  return obj;
endfunction : create
