// JSON decoder to extract JSON values recursively from string or file.
virtual class json_decoder;
  // Create JSON value from string
  extern static function json_value load_string(const ref string str);

  // Create JSON value from file
  extern static function json_value load_file(string path);

  // Scan string symbol by symbol to encounter and extract JSON value
  extern protected static function json_result#(json_value) scan_until_value(
    // Input string that won't be modified. Reference is used to avoid copying large strings.
    const ref string str,
    // Position of character to start scanning
    input int unsigned start_idx=0,
    // Position of the last character used to end JSON value extraction
    output int unsigned end_idx
  );

  // Parse JSON object from provided string
  extern protected static function json_result#(json_value) parse_object(
    // Input string that won't be modified. Reference is used to avoid copying large strings.
    const ref string str,
    // Position of character to start scanning - must be '{'
    input int unsigned start_idx=0,
    // Position of the last character used to end JSON object parsing ('}')
    output int unsigned end_idx
  );

  // Parse JSON array from provided string
  extern protected static function json_result#(json_value) parse_array(
    // Input string that won't be modified. Reference is used to avoid copying large strings.
    const ref string str,
    // Position of character to start scanning - must be '['
    input int unsigned start_idx=0,
    // Position of the last character used to end JSON array parsing (']')
    output int unsigned end_idx
  );

  // Parse JSON string from provided string
  extern protected static function json_result#(json_value) parse_string(
    // Input string that won't be modified. Reference is used to avoid copying large strings.
    const ref string str,
    // Position of character to start scanning - must be '"'
    input int unsigned start_idx=0,
    // Position of the last character used to end JSON string parsing ('"')
    output int unsigned end_idx
  );

  // Parse JSON number from provided string
  extern protected static function json_result#(json_value) parse_number(
    // Input string that won't be modified. Reference is used to avoid copying large strings.
    const ref string str,
    // Position of character to start scanning
    input int unsigned start_idx=0,
    // Position of the last character used to end JSON number parsing
    output int unsigned end_idx
  );

  // Parse JSON bool from provided string
  extern protected static function json_result#(json_value) parse_bool(
    // Input string that won't be modified. Reference is used to avoid copying large strings.
    const ref string str,
    // Position of character to start scanning
    input int unsigned start_idx=0,
    // Position of the last character used to end JSON bool parsing
    output int unsigned end_idx
  );

  // Parse JSON null from provided string
  extern protected static function json_result#(json_value) parse_null(
    // Input string that won't be modified. Reference is used to avoid copying large strings.
    const ref string str,
    // Position of character to start scanning
    input int unsigned start_idx=0,
    // Position of the last character used to end JSON null parsing
    output int unsigned end_idx
  );

  // Utility method to find first non-whitespace symbol
  extern protected static function json_result#(int unsigned) find_first_non_whitespace(
    // Input string that won't be modified. Reference is used to avoid copying large strings.
    const ref string str,
    // Position of character to start search
    input int unsigned start_idx
  );
endclass : json_decoder


function json_value json_decoder::load_string(const ref string str);
  int unsigned dummy_end_idx;
  json_result#(json_value) result;

  // Start recursive process of string scanning
  result = this.scan_until_value(str, .end_idx(dummy_end_idx));
  if (result.is_err()) begin
    $fatal(result.err_message);
  end

  return result.value;
endfunction : load_string


function json_value json_decoder::load_file(string path);
  int file_descr;
  string file_text;

  // Try to open file
  file_descr = $fopen(path, "r");
  if (file_descr == 0) begin
    $fatal("Failed to open the file '%s'", path);
  end

  // Read lines until the end of the file
  while (!$feof(file_descr)) begin
    string line;
    $fgets(line, file_descr);
    file_text = {file_text, line};
  end

  return load_string(file_text);
endfunction : load_file


function json_result#(json_value) json_decoder::scan_until_value(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  json_result#(int unsigned) char_search_result;

  int unsigned str_len = str.len();
  int unsigned idx = start_idx;

  // Skip all whitespaces
  char_search_result = find_first_non_whitespace(str, idx);
  if (char_search_result.is_err()) begin
    end_idx = str_len - 1;
    return json_result#(json_value)::err("String is empty or consists only of whitespace characters!");
  end else begin
    idx = char_search_result.value;
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
      end_idx = idx;
      return json_result#(json_value)::err(
        $sformatf("Unexpected symbol '%s' is not allowed here!", str[idx])
      );
    end
  endcase
endfunction : scan_until_value


function json_result#(json_value) json_decoder::parse_object(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);

endfunction : parse_object


function json_result#(json_value) json_decoder::parse_array(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);

endfunction : parse_array


function json_result#(json_value) json_decoder::parse_string(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);

endfunction : parse_string


function json_result#(json_value) json_decoder::parse_number(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);

endfunction : parse_number


function json_result#(json_value) json_decoder::parse_bool(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);

endfunction : parse_bool


function json_result#(json_value) json_decoder::parse_null(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
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
    return json_result#(int unsigned)::err("Cannot find any non whitespace symbol!");
  end else begin
    return json_result#(int unsigned)::ok(idx);
  end
endfunction : find_first_non_whitespace