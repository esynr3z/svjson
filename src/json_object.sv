class json_object extends json_value;
  protected json_value values[string];

  // Normal construtor
  extern function new(json_value values[string]);
  // Static constructor using type
  extern static function json_object create(json_value values[string]);
endclass : json_object


function json_object::new(json_value values[string]);
  this.values = values;
endfunction : new


function json_object json_object::create(json_value values[string]);
  json_object obj = new(values);
  return obj;
endfunction : create
