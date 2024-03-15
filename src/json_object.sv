class json_object extends json_value;
  json_value_map_t values;

  // Normal constructor
  extern function new(json_value_map_t values);

  // Create json_object from associative array
  extern static function json_object from(json_value_map_t values);

  // Return current value (override default implementation)
  extern virtual function json_result#(json_object) as_json_object();

  // Get number of items within object
  extern virtual function int unsigned size();

  // Check if key exists
  extern virtual function bit exists(string key);

  // Get value using the key
  extern virtual function json_value get(string key);

  // Create full copy of a value
  extern virtual function json_value clone();

  // Compare with value
  extern virtual function bit compare(json_value value);

  // Get kind of current value
  extern virtual function json_value_e kind();
endclass : json_object


function json_object::new(json_value_map_t values);
  this.values = values;
endfunction : new


function json_object json_object::from(json_value_map_t values);
  json_object obj = new(values);
  return obj;
endfunction : from


function json_result#(json_object) json_object::as_json_object();
  return json_result#(json_object)::ok(this);
endfunction : as_json_object


function int unsigned json_object::size();
  return this.values.num();
endfunction : size


function bit json_object::exists(string key);
  return bit'(this.values.exists(key));
endfunction : exists


function json_value json_object::get(string key);
  return this.values[key];
endfunction : get


function json_value json_object::clone();
  json_value new_values [string];

  foreach (this.values[key]) begin
    new_values[key] = this.values[key].clone();
  end

  return json_object::from(new_values);
endfunction : clone


function bit json_object::compare(json_value value);
  json_object rhs;
  if (value.is_json_object()) begin
    rhs = value.as_json_object().unwrap();
  end else begin
    return 0;
  end

  foreach (this.values[key]) begin
    if (!rhs.exists(key) || !this.get(key).compare(rhs.get(key))) begin
      return 0;
    end
  end

  return 1;
endfunction : compare


function json_value_e json_object::kind();
  return JSON_VALUE_OBJECT;
endfunction : kind
