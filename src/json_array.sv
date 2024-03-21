class json_array extends json_value;
  json_value_queue_t values;

  // Normal constructor
  extern function new(json_value_queue_t values);

  // Create `json_array` from queue
  extern static function json_array from(json_value_queue_t values);

  // Get current instance
  extern virtual function json_result#(json_array) as_json_array();

  // Check for current instance class type
  extern virtual function bit is_json_array();

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get kind of current instance
  extern virtual function json_value_e kind();
endclass : json_array


function json_array::new(json_value_queue_t values);
  foreach (values[i]) begin
    json_value value = values[i];
    if (value == null) begin
      value = json_null::create();
    end
    this.values.push_back(value);
  end
endfunction : new


function json_array json_array::from(json_value_queue_t values);
  json_array obj = new(values);
  return obj;
endfunction : from


function json_result#(json_array) json_array::as_json_array();
  return json_result#(json_array)::ok(this);
endfunction : as_json_array


function json_value json_array::clone();
  json_value new_values[$];

  foreach (this.values[i]) begin
    new_values.push_back(this.values[i].clone());
  end

  return json_array::from(new_values);
endfunction : clone


function bit json_array::compare(json_value value);
  json_result#(json_array) casted;
  json_error err;
  json_array rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.as_json_array();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): begin
      if (rhs.values.size() != this.values.size()) begin
        return 0;
      end
      foreach (this.values[i]) begin
        if (!this.values[i].compare(rhs.values[i])) begin
          return 0;
        end
      end
      return 1;
    end
  endcase
endfunction : compare


function json_value_e json_array::kind();
  return JSON_VALUE_ARRAY;
endfunction : kind


function bit json_array::is_json_array();
  return 1;
endfunction : is_json_array
