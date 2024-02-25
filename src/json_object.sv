class json_object extends json_value;
  // Create JSON object from string
  extern static function json_object from_string(const ref string str, int unsigned start_from=0);
endclass : json_object

function json_object json_object::from_string(const ref string str, int unsigned start_from=0);
  //return this.scan_string(str, start_from);
endfunction : from_string