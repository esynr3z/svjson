// JSON array value
class json_array extends json_value implements json_array_encodable;
  typedef json_value values_t[$];

  values_t values;

  // Normal constructor
  extern function new(values_t values);

  // Create `json_array` from queue
  extern static function json_array from(values_t values);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Interface json_array_encodable
  extern virtual function json_array_encodable::values_t get_values();
endclass : json_array


function json_array::new(values_t values);
  foreach (values[i]) begin
    this.values.push_back(values[i]);
  end
endfunction : new


function json_array json_array::from(values_t values);
  json_array obj = new(values);
  return obj;
endfunction : from


function json_value json_array::clone();
  json_value new_values[$];

  foreach (this.values[i]) begin
    if (this.values[i] == null) begin
      new_values.push_back(null);
    end else begin
      new_values.push_back(this.values[i].clone());
    end
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
        if ((this.values[i] != null) && (rhs.values[i] != null)) begin
          if (!this.values[i].compare(rhs.values[i])) begin
            return 0;
          end
        end else if ((this.values[i] == null) && (rhs.values[i] == null)) begin
          continue;
        end else begin
          return 0;
        end
      end
      return 1;
    end
  endcase
endfunction : compare


function json_array_encodable::values_t json_array::get_values();
  json_array_encodable::values_t values;

  foreach(this.values[i]) begin
    values.push_back(this.values[i]);
  end

  return values;
endfunction : get_values
