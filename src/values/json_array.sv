// JSON array.
// This wrapper class represents standard JSON array value using SV queue.
// The class basically wraps standard SV queue methods with some additional methods required to operate as JSON value.
// No additional checks are implemented for "out-of-range" accesses and similar,
// so you can expect that this class will operate according to behavior of an original underlying SV queue.
class json_array extends json_value implements json_array_encodable;
  typedef json_value values_t[$];

  protected values_t values;

  // Normal constructor
  extern function new(values_t values);

  // Create `json_array` from queue
  extern static function json_array from(values_t values);

  // Create a deep copy of an instance
  extern virtual function json_value clone();

  // Compare with another instance
  extern virtual function bit compare(json_value value);

  // Get a value at the provided index
  extern virtual function json_value get(int index);

  // Set the given value for the provided index
  extern virtual function void set(int index, json_value value);

  // Get a size of the array (number of items stored)
  extern virtual function int size();

  // Insert the given value at the provided index
  extern virtual function void insert(int index, json_value value);

  // Remove a value from the provided index
  extern virtual function void delete(int index);

  // Remove all values
  extern virtual function void flush();

  // Insert the given value at the back of the array
  extern virtual function void push_back(json_value value);

  // Insert the given value at the front of the array
  extern virtual function void push_front(json_value value);

  // Remove and return the last element in the array
  extern virtual function json_value pop_back();

  // Remove and return the first element in the array
  extern virtual function json_value pop_front();

  // Get all internal values as SV queue
  extern virtual function values_t get_values();

  // Get value encodable as JSON array (for interface json_array_encodable)
  extern virtual function json_array_encodable::values_t to_json_encodable();
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

  for(int i = 0; i < this.size(); i++) begin
    if (this.get(i) == null) begin
      new_values.push_back(null);
    end else begin
      new_values.push_back(this.get(i).clone());
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

  casted = value.try_into_array();
  case (1)
    casted.matches_err(err): return 0;
    casted.matches_ok(rhs): begin
      if (rhs.size() != this.size()) begin
        return 0;
      end

      for(int i = 0; i < this.size(); i++) begin
        if ((this.get(i) != null) && (rhs.get(i) != null)) begin
          if (!this.get(i).compare(rhs.get(i))) begin
            return 0;
          end
        end else if ((this.get(i) == null) && (rhs.get(i) == null)) begin
          continue;
        end else begin
          return 0;
        end
      end
      return 1;
    end
  endcase
endfunction : compare


function json_value json_array::get(int index);
  return this.values[index];
endfunction : get


function void json_array::set(int index, json_value value);
  this.values[index] = value;
endfunction : set


function int json_array::size();
  return this.values.size();
endfunction : size


function void json_array::insert(int index, json_value value);
  this.values.insert(index, value);
endfunction : insert


function void json_array::delete(int index);
  this.values.delete(index);
endfunction : delete


function void json_array::flush();
  this.values.delete();
endfunction : flush


function void json_array::push_back(json_value value);
  this.values.push_back(value);
endfunction : push_back


function void json_array::push_front(json_value value);
  this.values.push_front(value);
endfunction : push_front


function json_value json_array::pop_back();
  return this.values.pop_back();
endfunction : pop_back


function json_value json_array::pop_front();
  return this.values.pop_front();
endfunction : pop_front


function json_array::values_t json_array::get_values();
  return this.values;
endfunction : get_values


function json_array_encodable::values_t json_array::to_json_encodable();
  json_array_encodable::values_t values;

  for(int i = 0; i < this.size(); i++) begin
    values.push_back(this.get(i));
  end

  return values;
endfunction : to_json_encodable
