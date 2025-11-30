// JSON object.
// This wrapper class represents standard JSON object value using SV associative array.
// The class basically wraps standard SV associative array methods with some additional methods
// required to operate as JSON value.
// No additional checks are implemented for "out-of-range" accesses and similar,
// so you can expect that this class will operate according to behavior of an original underlying SV associative array.
class json_object extends json_value implements json_object_encodable;
  typedef json_value values_t[string];
  typedef string keys_t[$];

  protected values_t values;

  // Normal constructor
  extern function new(values_t values);

  // Create `json_object` from associative array
  extern static function json_object from(values_t values);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get a value at the provided key
  extern virtual function json_value get(string key);

  // Set the given value for the provided key
  extern virtual function void set(string key, json_value value);

  // Get a size of the object (number of items stored)
  extern virtual function int size();

  // Check if a value with the given key already exists in the object.
  // Return 1 if so, and 0 otherwise.
  extern virtual function int exists(string key);

  // Remove a value with the provided key
  extern virtual function void delete(string key);

  // Remove all stored values
  extern virtual function void flush();

  // Assign to the given key variable the value of the first (smallest) key.
  // Return 0 if not entires, otherwise, return 1.
  extern virtual function int first(ref string key);

  // Assign to the given key variable the value of the last (largest) key.
  // Return 0 if not entires, otherwise, return 1.
  extern virtual function int last(ref string key);

  // Find the smallest key whose value is greater than the given key.
  // Return 1 if such key exists, 0 otherwise.
  extern virtual function int next(ref string key);

  // Find the smallest key whose value is smaller than the given key.
  // Return 1 if such key exists, 0 otherwise.
  extern virtual function int prev(ref string key);

  // Get all internal values as associative array
  extern virtual function values_t get_values();

  // Get all keys for internal values as queue
  extern virtual function keys_t get_keys();

  // Get value encodable as JSON object (for interface json_object_encodable)
  extern virtual function json_object_encodable::values_t to_json_encodable();
endclass : json_object


function json_object::new(values_t values);
  foreach (values[key]) begin
    this.values[key] = values[key];
  end
endfunction : new


function json_object json_object::from(values_t values);
  json_object obj = new(values);
  return obj;
endfunction : from


function json_value json_object::clone();
  json_value new_values [string];
  string key;

  if (first(key) == 1) begin
    do begin
      if (this.get(key) == null) begin
        new_values[key] = null;
      end else begin
        new_values[key] = this.get(key).clone();
      end
    end while (next(key) == 1);
  end

  return json_object::from(new_values);
endfunction : clone


function bit json_object::compare(json_value value);
  json_result#(json_object) casted;
  json_error err;
  json_object rhs;

  if (value == null) begin
    return 0;
  end

  casted = value.try_into_object();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): begin
      string key;
      if (rhs.size() != this.size()) begin
        return 0;
      end

      if (first(key) == 1) begin
        do begin
          if ((rhs.exists(key) == 0)) begin
            return 0;
          end else if ((this.get(key) != null) && (rhs.get(key) != null)) begin
            if (!this.get(key).compare(rhs.get(key))) begin
              return 0;
            end
          end else if ((this.get(key) == null) && (rhs.get(key) == null)) begin
            continue;
          end else begin
            return 0;
          end
        end while (next(key) == 1);
      end

      return 1;
    end
  endcase
endfunction : compare


function json_value json_object::get(string key);
  return this.values[key];
endfunction : get


function void json_object::set(string key, json_value value);
  this.values[key] = value;
endfunction : set


function int json_object::size();
  return this.values.size();
endfunction : size


function int json_object::exists(string key);
  return this.values.exists(key);
endfunction : exists


function void json_object::delete(string key);
  this.values.delete(key);
endfunction : delete


function void json_object::flush();
  this.values.delete();
endfunction : flush


function int json_object::first(ref string key);
  return this.values.first(key);
endfunction : first


function int json_object::last(ref string key);
  return this.values.last(key);
endfunction : last


function int json_object::next(ref string key);
  return this.values.next(key);
endfunction : next


function int json_object::prev(ref string key);
  return this.values.prev(key);
endfunction : prev


function json_object::values_t json_object::get_values();
  return this.values;
endfunction : get_values


function json_object::keys_t json_object::get_keys();
  keys_t keys;

  foreach (this.values[key]) begin
    keys.push_back(key);
  end

  return keys;
endfunction : get_keys


function json_object_encodable::values_t json_object::to_json_encodable();
  json_object_encodable::values_t values;
  string key;

  if (first(key) == 1) begin
    do begin
      values[key] = this.get(key);
    end while (next(key) == 1);
  end

  return values;
endfunction : to_json_encodable
