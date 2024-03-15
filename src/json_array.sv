class json_array extends json_value;
  json_value_queue_t values;

  // Normal constructor
  extern function new(json_value_queue_t values);

  // Create json_array from queue
  extern static function json_array from(json_value_queue_t values);

  // Return current value (override default implementation)
  extern virtual function json_result#(json_array) as_json_array();

  // Get size of the array
  extern virtual function int unsigned size();

  // Get element of the array
  extern virtual function json_value get(int unsigned index);

  // Create full copy of a value
  extern virtual function json_value clone();

  // Compare with value
  extern virtual function bit compare(json_value value);

  // Get kind of current value
  extern virtual function json_value_e kind();
endclass : json_array


function json_array::new(json_value_queue_t values);
  this.values = values;
endfunction : new


function json_array json_array::from(json_value_queue_t values);
  json_array obj = new(values);
  return obj;
endfunction : from


function json_result#(json_array) json_array::as_json_array();
  return json_result#(json_array)::ok(this);
endfunction : as_json_array


function int unsigned json_array::size();
  return this.values.size();
endfunction : size


function json_value json_array::get(int unsigned index);
  return this.values[index];
endfunction : get


function json_value json_array::clone();
  json_value new_values[$];

  foreach (this.values[i]) begin
    new_values[i] = this.values[i].clone();
  end

  return json_array::from(new_values);
endfunction : clone


function bit json_array::compare(json_value value);
  json_array rhs;
  if (value.is_json_array()) begin
    rhs = value.as_json_array().unwrap();
  end else begin
    return 0;
  end

  if (rhs.size() != this.size()) begin
    return 0;
  end

  foreach (this.values[i]) begin
    if (!this.get(i).compare(rhs.get(i))) begin
      return 0;
    end
  end

  return 1;
endfunction : compare


function json_value_e json_array::kind();
  return JSON_VALUE_ARRAY;
endfunction : kind
