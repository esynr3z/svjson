class json_array extends json_value;
  protected json_value_queue_t values;

  // Normal constructor
  extern function new(json_value_queue_t values);

  // Static constructor using type
  extern static function json_array create(json_value_queue_t values);

  // Get native queue type
  extern virtual function json_value_queue_t to_native();

  // Get size of the array
  extern virtual function int unsigned size();
endclass : json_array


function json_array::new(json_value_queue_t values);
  this.values = values;
endfunction : new


function json_array json_array::create(json_value_queue_t values);
  json_array obj = new(values);
  return obj;
endfunction : create


function json_value_queue_t json_array::to_native();
  return this.values;
endfunction : to_native


function int unsigned json_array::size();
  return this.values.size();
endfunction : size
