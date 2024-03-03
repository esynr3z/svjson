class json_string extends json_value;
  protected string value;

  // Normal constructor
  extern function new(string value);

  // Static constructor using type
  extern static function json_string create(string value);
  
  // Get native string type
  extern virtual function string unwrap();
endclass : json_string


function json_string::new(string value);
  this.value = value;
endfunction : new


function json_string json_string::create(string value);
  json_string obj = new(value);
  return obj;
endfunction : create


function string json_string::unwrap();
  return this.value;
endfunction : unwrap
