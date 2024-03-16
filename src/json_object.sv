class json_object extends json_value;
  json_value_map_t values;

  // Normal constructor
  extern function new(json_value_map_t values);

  // Create `json_object` from associative array
  extern static function json_object from(json_value_map_t values);

  // Get current instance
  extern virtual function json_result#(json_object) as_json_object();

  // Check for current instance class type
  extern virtual function bit is_json_object();

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get kind of current instance
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


function json_value json_object::clone();
  json_value new_values [string];

  foreach (this.values[key]) begin
    new_values[key] = this.values[key].clone();
  end

  return json_object::from(new_values);
endfunction : clone


function bit json_object::compare(json_value value);
  json_result#(json_object) casted = value.as_json_object();
  json_error err;
  json_object rhs;
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): begin
      if (rhs.values.size() != this.values.size()) begin
        return 0;
      end
      foreach (this.values[key]) begin
        if ((rhs.values.exists(key) == 0) || !this.values[key].compare(rhs.values[key])) begin
          return 0;
        end
      end
      return 1;
    end
  endcase
endfunction : compare


function json_value_e json_object::kind();
  return JSON_VALUE_OBJECT;
endfunction : kind


function bit json_object::is_json_object();
  return 1;
endfunction : is_json_object
