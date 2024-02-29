// JSON decoder to extract JSON values recursively from string or file
virtual class json_decoder;
  // Try to create JSON value from string. Error can be handled manually in case of failure.
  extern static function json_result#(json_value) try_load_string(const ref string str);

  // Create JSON value from string.
  // Basicly, wrapper over `try_load_string` that throws a fatal message in case of failure.
  extern static function json_value load_string(const ref string str);

  // Try to create JSON value from file. Error can be handled manually in case of failure.
  extern static function json_result#(json_value) try_load_file(string path);

  // Create JSON value from file.
  // Basicly, wrapper over `try_load_file` that throws a fatal message in case of failure.
  extern static function json_value load_file(string path);

  // Scan string symbol by symbol to encounter and extract JSON value.
  extern protected static function json_result#(json_value) parse_value(
    const ref string str,
    input int unsigned start_idx=0,
    output int unsigned end_idx
  );

  // Parse JSON object from provided string.
  // String must start from '{' (`start_idx`) and consist a pair symbol '}' (`end_idx`).
  extern protected static function json_result#(json_value) parse_object(
    const ref string str,
    input int unsigned start_idx=0,
    output int unsigned end_idx
  );

  // Parse JSON array from provided string.
  // String must start from '[' (`start_idx`) and consist a pair symbol ']' (`end_idx`).
  extern protected static function json_result#(json_value) parse_array(
    const ref string str,
    input int unsigned start_idx=0,
    output int unsigned end_idx
  );

  // Parse JSON string from provided string.
  // String must start from '"' (`start_idx`) and consist a pair symbol '"' (`end_idx`).
  extern protected static function json_result#(json_value) parse_string(
    const ref string str,
    input int unsigned start_idx=0,
    output int unsigned end_idx
  );

  // Parse JSON number from provided string.
  // Number must start from `start_idx` and will end at `end_idx`.
  extern protected static function json_result#(json_value) parse_number(
    const ref string str,
    input int unsigned start_idx=0,
    output int unsigned end_idx
  );

  // Parse JSON bool from provided string.
  // Boolean must start from `start_idx` and will end at `end_idx`.
  extern protected static function json_result#(json_value) parse_bool(
    const ref string str,
    input int unsigned start_idx=0,
    output int unsigned end_idx
  );

  // Parse JSON null from provided string.
  // Mull must start from `start_idx` and will end at `end_idx`.
  extern protected static function json_result#(json_value) parse_null(
    const ref string str,
    input int unsigned start_idx=0,
    output int unsigned end_idx
  );

  // Utility method to find first non-whitespace symbol
  extern protected static function json_result#(int unsigned) find_first_non_whitespace(
    const ref string str,
    input int unsigned start_idx=0
  );
endclass : json_decoder


function json_result#(json_value) json_decoder::try_load_string(const ref string str);
  int unsigned dummy_end_idx;
  // Start recursive process of string scanning
  return parse_value(str, .end_idx(dummy_end_idx));
endfunction : try_load_string


function json_value json_decoder::load_string(const ref string str);
  json_result#(json_value) result;

  // Try to load string and handle possible error
  result = try_load_string(str);
  if (result.is_err()) begin
    $fatal("%s: %s", result.err_kind.name(), result.err_message);
  end

  return result.value;
endfunction : load_string


function json_result#(json_value) json_decoder::try_load_file(string path);
  int file_descr;
  string file_text;

  // Try to open file
  file_descr = $fopen(path, "r");
  if (file_descr == 0) begin
    return json_result#(json_value)::err(
      JSON_ERR_OPEN_FILE,
      $sformatf("Failed to open the file '%s'!", path)
    );
  end

  // Read lines until the end of the file
  while (!$feof(file_descr)) begin
    string line;
    $fgets(line, file_descr);
    file_text = {file_text, line};
  end

  return try_load_string(file_text);
endfunction : try_load_file


function json_value json_decoder::load_file(string path);
  json_result#(json_value) result;

  // Try to load file and handle possible error
  result = try_load_file(path);
  if (result.is_err()) begin
    $fatal("%s: %s", result.err_kind.name(), result.err_message);
  end

  return result.value;
endfunction : load_file


function json_result#(json_value) json_decoder::parse_value(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  json_result#(int unsigned) non_ws_pos;
  int unsigned idx = start_idx;

  // Skip all whitespaces
  non_ws_pos = find_first_non_whitespace(str, idx);
  if (non_ws_pos.is_err()) begin
    return json_result#(json_value)::err(non_ws_pos.err_kind, non_ws_pos.err_message);
  end else begin
    idx = non_ws_pos.value;
  end

  // This non-whitespace character has to begin a JSON value
  case (str[idx]) inside
    "{": return parse_object(str, idx, end_idx);
    "[": return parse_array(str, idx, end_idx);
    "\"": return parse_string(str, idx, end_idx);
    "n": return parse_null(str, idx, end_idx);
    "t", "f": return parse_bool(str, idx, end_idx);
    "-", ["0":"9"]: return parse_number(str, idx, idx);

    default: begin
      return json_result#(json_value)::err(
        JSON_ERR_DECODE,
        $sformatf("Unexpected symbol '%s' is not allowed here!", str[idx])
      );
    end
  endcase
endfunction : parse_value


function json_result#(json_value) json_decoder::parse_object(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  json_result#(int unsigned) non_ws_pos;
  json_result#(json_value) result;
  string key;
  json_value values [string];
  int unsigned idx = start_idx + 1; // start index is '{'

  // Skip all whitespaces
  non_ws_pos = find_first_non_whitespace(str, idx);
  if (non_ws_pos.is_err()) begin
    return json_result#(json_value)::err(non_ws_pos.err_kind, "Can not find pair token '}'!");
  end else begin
    idx = non_ws_pos.value;
  end

  // This non-whitespace character has to begin a JSON string
  result = parse_string(str, idx, idx);
  if (result.is_err()) begin
    return result;
  end else begin
    key = result.value;
  end

  // Skip all whitespaces
  non_ws_pos = find_first_non_whitespace(str, idx);
  if (non_ws_pos.is_err()) begin
    return json_result#(json_value)::err(non_ws_pos.err_kind, "Can not find token ':'!");
  end else begin
    idx = non_ws_pos.value;
  end

  // TODO
  return json_result#(json_value)::err(
    JSON_ERR_NOT_IMPLEMENTED,
    "Method `json_decoder::parse_object` is not implemented!"
  );
endfunction : parse_object


function json_result#(json_value) json_decoder::parse_array(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  return json_result#(json_value)::err(
    JSON_ERR_NOT_IMPLEMENTED,
    "Method `json_decoder::parse_array` is not implemented!"
  );
endfunction : parse_array


function json_result#(json_value) json_decoder::parse_string(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  return json_result#(json_value)::err(
    JSON_ERR_NOT_IMPLEMENTED,
    "Method `json_decoder::parse_string` is not implemented!"
  );
endfunction : parse_string


function json_result#(json_value) json_decoder::parse_number(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  return json_result#(json_value)::err(
    JSON_ERR_NOT_IMPLEMENTED,
    "Method `json_decoder::parse_number` is not implemented!"
  );
endfunction : parse_number


function json_result#(json_value) json_decoder::parse_bool(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  return json_result#(json_value)::err(
    JSON_ERR_NOT_IMPLEMENTED,
    "Method `json_decoder::parse_bool` is not implemented!"
  );
endfunction : parse_bool


function json_result#(json_value) json_decoder::parse_null(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  return json_result#(json_value)::err(
    JSON_ERR_NOT_IMPLEMENTED,
    "Method `json_decoder::parse_null` is not implemented!"
  );
endfunction : parse_null


function json_result#(int unsigned) json_decoder::find_first_non_whitespace(
  const ref string str,
  input int unsigned start_from=0
);
  int unsigned len = str.len();
  int unsigned idx = start_from;

  while ((str[idx] inside {" ", "\t", "\n", "\r"}) && (idx < len)) begin
    idx++;
  end

  if (idx == str.len()) begin
    return json_result#(int unsigned)::err(
      JSON_ERR_EMPTY_STRING,
      "Expected to find non-whitespace character!"
    );
  end else begin
    return json_result#(int unsigned)::ok(idx);
  end
endfunction : find_first_non_whitespace