// JSON encoder
class json_encoder;
  //----------------------------------------------------------------------------
  // Public methods
  //----------------------------------------------------------------------------
  // Encode provided JSON value to string
  extern static function json_result#(string) dump_string(
    json_value_encodable obj,
    int unsigned indent_spaces = 0
  );

  // Encode provided JSON value to string and try to dump to file.
  // Encoded string is returned.
  extern static function json_result#(string) dump_file(
    json_value_encodable obj,
    string path,
    int unsigned indent_spaces = 0
  );

  //----------------------------------------------------------------------------
  // Private properties
  //----------------------------------------------------------------------------
  int unsigned indent_spaces;

  //----------------------------------------------------------------------------
  // Private methods
  //----------------------------------------------------------------------------
  // Private constructor
  extern local function new();

  // Encode generic JSON value
  extern protected function json_result#(string) convert_value(json_value_encodable obj, int unsigned nesting_lvl);

  // Encode JSON object
  extern protected function json_result#(string) convert_object(json_object_encodable obj, int unsigned nesting_lvl);

  // Encode JSON array
  extern protected function json_result#(string) convert_array(json_array_encodable obj, int unsigned nesting_lvl);

  // Encode JSON string
  extern protected function string convert_string(json_string_encodable obj);

  // Encode JSON number (int)
  extern protected function string convert_int(json_int_encodable obj);

  // Encode JSON number (real)
  extern protected function string convert_real(json_real_encodable obj);

  // Encode JSON nool
  extern protected function string convert_bool(json_bool_encodable obj);

  // Convert indentation level to string of spaces
  extern protected function string level_to_spaces(int unsigned lvl);

  // Check if compact mode is enabled
  extern protected function bit is_compact();
endclass : json_encoder


function json_encoder::new();
endfunction : new


function json_result#(string) json_encoder::dump_string(
  json_value_encodable obj,
  int unsigned indent_spaces = 0
);
endfunction : dump_string


function json_result#(string) json_encoder::dump_file(
  json_value_encodable obj,
  string path,
  int unsigned indent_spaces = 0
);
endfunction : dump_file


function json_result#(string) json_encoder::convert_value(json_value_encodable obj, int unsigned nesting_lvl);
  json_object_encodable jobject;
  json_array_encodable jarray;
  json_string_encodable jstring;
  json_int_encodable jint;
  json_real_encodable jreal;
  json_bool_encodable jbool;

  case(1)
    obj == null: return json_result#(string)::ok("null");
    $cast(jobject, obj): return convert_object(jobject, nesting_lvl);
    $cast(jarray, obj): return convert_array(jarray, nesting_lvl);
    $cast(jstring, obj): return json_result#(string)::ok(convert_string(jstring));
    $cast(jint, obj): return json_result#(string)::ok(convert_int(jint));
    $cast(jreal, obj): return json_result#(string)::ok(convert_real(jreal));
    $cast(jbool, obj): return json_result#(string)::ok(convert_bool(jbool));
    default: return json_result#(string)::err(json_error::create(
      json_error::TYPE_CONVERSION,
      $sformatf("Provided object has unsupported JSON encodable interface implemented")
    ));
  endcase
endfunction : convert_value


function json_result#(string) json_encoder::convert_object(json_object_encodable obj, int unsigned nesting_lvl);
  string converted = "{";
  json_object_encodable::values_t values = obj.get_values();
  string last_key;

  values.last(last_key);
  foreach(values[key]) begin
    json_error err;
    string ok;
    json_result#(string) nested_conv = convert_value(values[key], nesting_lvl + 1);

    case(1)
      nested_conv.matches_err(err): return nested_conv;

      nested_conv.matches_ok(ok): begin
        converted = {converted, level_to_spaces(nesting_lvl + 1), key, ":", this.is_compact() ? "" : " ", ok};
        if (key == last_key) begin
          converted = {converted, ","};
        end
        converted = {converted, this.is_compact() ? "" : "\n"};
      end
    endcase

  end
  converted = {converted, level_to_spaces(nesting_lvl), "}"};

  return json_result#(string)::ok(converted);
endfunction : convert_object


function json_result#(string) json_encoder::convert_array(json_array_encodable obj, int unsigned nesting_lvl);
  string converted = "[";
  json_array_encodable::values_t values = obj.get_values();
  int unsigned values_num = values.size();

  foreach(values[i]) begin
    json_error err;
    string ok;
    json_result#(string) nested_conv = convert_value(values[i], nesting_lvl + 1);

    case(1)
      nested_conv.matches_err(err): return nested_conv;

      nested_conv.matches_ok(ok): begin
        converted = {converted, level_to_spaces(nesting_lvl + 1), ok};
        if (i < (values_num - 1)) begin
          converted = {converted, ","};
        end
        converted = {converted, this.is_compact() ? "\n" : ""};
      end
    endcase

  end
  converted = {converted, level_to_spaces(nesting_lvl), "]"};

  return json_result#(string)::ok(converted);
endfunction : convert_array


function string json_encoder::convert_string(json_string_encodable obj);
  string orig = obj.get_value();
  string converted = "";

  foreach (orig[i]) begin
    string sym;
    case (orig[i])
      "\"" : sym = "\\\"";
      "\\" : sym = "\\\\";
      "\/" : sym = "\\/";
      "\f" : sym = "\\f";
      "\n" : sym = "\\n";
      "\r" : sym = "\\r";
      "\t" : sym = "\\t";
      default: sym = orig[i];
    endcase
    converted = {converted, sym};
  end

  return converted;
endfunction : convert_string


function string json_encoder::convert_int(json_int_encodable obj);
  return $sformatf("%0d", obj.get_value());
endfunction : convert_int


function string json_encoder::convert_real(json_real_encodable obj);
  return $sformatf("%0f", obj.get_value());
endfunction : convert_real


function string json_encoder::convert_bool(json_bool_encodable obj);
  return obj.get_value() ? "true" : "false";
endfunction : convert_bool


function string json_encoder::level_to_spaces(int unsigned lvl);
  string spaces = "";
  repeat(lvl * this.indent_spaces) begin
    spaces = {spaces, " "};
  end
  return spaces;
endfunction : level_to_spaces


function bit json_encoder::is_compact();
  return this.indent_spaces > 0;
endfunction : is_compact
