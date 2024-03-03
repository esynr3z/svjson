class json_array extends json_value;
  protected json_value values[$];

  // Normal construtor
  extern function new(json_value values[$]);
  // Static constructor using type
  extern static function json_array create(json_value values[$]);
endclass : json_array


function json_array::new(json_value values[$]);
  this.values = values;
endfunction : new


function json_array json_array::create(json_value values[$]);
  json_array obj = new(values);
  return obj;
endfunction : create
