class some_config implements json_object_encodable;
  int unsigned max_addr;
  bit is_active;
  string id;

  // Single method has to be implemented for json_object_encodable interface.
  // It has to return associative array of JSON values
  virtual function json_object_encodable::values_t to_json_encodable();
    json_object_encodable::values_t values;
    values["max_addr"] = json_int::from(longint'(this.max_addr));
    values["is_active"] = json_bool::from(this.is_active);
    values["id"] = json_string::from(this.id);
    return values;
  endfunction: to_json_encodable
endclass : some_config

// Then any `config` instance can be passed to encoder
function void dump_config(some_config cfg);
  void'(json_encoder::dump_file(cfg, "config.json"));
endfunction : dump_config