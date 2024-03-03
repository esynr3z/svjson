class json_object extends json_value;
  protected json_value_map_t values;

  // Normal constructor
  extern function new(json_value_map_t values);

  // Static constructor using type
  extern static function json_object create(json_value_map_t values);
  
  // Get native map type
  extern virtual function json_value_map_t unwrap();
endclass : json_object


function json_object::new(json_value_map_t values);
  this.values = values;
endfunction : new


function json_object json_object::create(json_value_map_t values);
  json_object obj = new(values);
  return obj;
endfunction : create


function json_value_map_t json_object::unwrap();
  return this.values;
endfunction : unwrap