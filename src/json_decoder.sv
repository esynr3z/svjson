// JSON decoder
class json_decoder;
  //----------------------------------------------------------------------------
  // Private properties
  //----------------------------------------------------------------------------
  local typedef struct {
    json_value   value;
    int unsigned end_pos;
  } parsed_s;

  local typedef json_result#(parsed_s) parser_result;

  local const byte whitespace_chars[] = '{" ", "\t", "\n", "\r"};

  local const byte escape_chars[] = '{"\"", "\\", "/", "b", "f", "n", "r", "t"};

  local const byte hex_chars[] = '{
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "a", "b", "c", "d", "e", "f", "A", "B", "C", "D", "E", "F"
  };

  local const byte value_start_chars[] = '{
    "{", "[", "\"", "n", "t", "f", "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
  };

  local const byte number_chars[] = '{
    ".", "-", "+", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "e", "E"
  };

  //----------------------------------------------------------------------------
  // Public methods
  //----------------------------------------------------------------------------
  // Try to load and decode string into JSON value
  extern static function json_result load_string(const ref string str);

  // Try to load and decode file into JSON value
  extern static function json_result load_file(string path);

  //----------------------------------------------------------------------------
  // Private methods
  //----------------------------------------------------------------------------
  // Private constructor
  extern local function new();

  // Scan string symbol by symbol to encounter and extract JSON values recursively.
  extern local function parser_result parse_value(const ref string str, input int unsigned start_pos);

  extern local function parser_result parse_object(const ref string str, input int unsigned start_pos);

  extern local function parser_result parse_array(const ref string str, input int unsigned start_pos);

  extern local function parser_result parse_string(const ref string str, input int unsigned start_pos);

  extern local function parser_result parse_number(const ref string str, input int unsigned start_pos);

  extern local function parser_result parse_literal(const ref string str, input int unsigned start_pos);

  // Scan input string char by char ignoring any whitespaces and stop at first non-whitespace char.
  // Return error with last char position if non-whitespace char was not found or do not match expected ones.
  // Return OK and position of found char within string otherwise.
  extern local function parser_result scan_until_token(
    const ref string str,
    input int unsigned start_pos,
    input byte expected_tokens [] = '{}
  );
endclass : json_decoder


function json_decoder::new();
endfunction : new


function json_result json_decoder::load_string(const ref string str);
  parsed_s parsed;
  json_error error;
  parser_result result;
  json_decoder decoder = new();

  result = decoder.parse_value(str, 0);
  case (1)
    result.matches_ok(parsed): return json_result#()::ok(parsed.value);
    result.matches_err(error): return json_result#()::err(error);
  endcase
endfunction : load_string


function json_result json_decoder::load_file(string path);
  int file_descr;
  string file_text;

  // Try to open file
  file_descr = $fopen(path, "r");
  if (file_descr == 0) begin
    return `JSON_ERR(json_error::FILE_NOT_OPENED, $sformatf("Failed to open the file '%s'!", path));
  end

  // Read lines until the end of the file
  while (!$feof(file_descr)) begin
    string line;
    $fgets(line, file_descr);
    file_text = {file_text, line};
  end

  return load_string(file_text);
endfunction : load_file


function json_decoder::parser_result json_decoder::parse_value(const ref string str, input int unsigned start_pos);
  parser_result result;
  json_error error;
  parsed_s parsed;

  int unsigned curr_pos = start_pos;

  // Skip all whitespaces until valid token
  result = scan_until_token(str, curr_pos, this.value_start_chars);
  case (1)
    result.matches_err_eq(json_error::EXPECTED_TOKEN, error):
      return `JSON_SYNTAX_ERR(json_error::EXPECTED_VALUE, str, error.json_idx);

    result.matches_err_eq(json_error::EOF_VALUE, error):
      return `JSON_SYNTAX_ERR(json_error::EOF_VALUE, str, error.json_idx);

    result.matches_err(error): return `JSON_INTERNAL_ERR($sformatf("Unexpected error %s", error.kind.name()));

    result.matches_ok(parsed): curr_pos = parsed.end_pos;
  endcase

  // Current character must start a value
  case (str[curr_pos]) inside
    "{": return parse_object(str, curr_pos + 1);
    "[": return parse_array(str, curr_pos + 1);
    "\"": return parse_string(str, curr_pos);
    "n", "t", "f": return parse_literal(str, curr_pos);
    "-", ["0":"9"]: return parse_number(str, curr_pos);

    default: return `JSON_SYNTAX_ERR(json_error::EXPECTED_VALUE, str, curr_pos);
  endcase
endfunction : parse_value


function json_decoder::parser_result json_decoder::parse_object(const ref string str, input int unsigned start_pos);
  enum {
    PARSE_KEY,
    EXPECT_COLON,
    PARSE_VALUE,
    EXPECT_COMMA_OR_RIGHT_CURLY
  } state = PARSE_KEY;

  string key;
  json_value values [string];

  json_error error;
  parser_result result;
  parsed_s parsed;

  int unsigned curr_pos = start_pos;
  bit trailing_comma = 0;
  bit exit_parsing_loop = 0;

  while(!exit_parsing_loop) begin
    case (state)
      PARSE_KEY: begin
        result = parse_string(str, curr_pos);
        case(1)
          result.matches_err_eq(json_error::EXPECTED_DOUBLE_QUOTE, error): begin
            if (str[error.json_idx] == "}") begin
              if (trailing_comma) begin
                return `JSON_SYNTAX_ERR(json_error::TRAILING_COMMA, str, error.json_idx);
              end
              curr_pos = error.json_idx;
              exit_parsing_loop = 1; // empty object parsed
            end else begin
              return result;
            end
          end

          result.matches_err(error): return result;

          result.matches_ok(parsed): begin
            key = parsed.value.as_json_string().unwrap().value;
            curr_pos = parsed.end_pos + 1; // move from last string token
            state = EXPECT_COLON;
          end
        endcase
      end

      EXPECT_COLON: begin
        result = scan_until_token(str, curr_pos, '{":"});
        case(1)
          result.matches_err_eq(json_error::EXPECTED_TOKEN, error):
            return `JSON_SYNTAX_ERR(json_error::EXPECTED_COLON, str, error.json_idx);

          result.matches_err_eq(json_error::EOF_VALUE, error):
            return `JSON_SYNTAX_ERR(json_error::EOF_OBJECT, str, error.json_idx);

          result.matches_err(error): return `JSON_INTERNAL_ERR($sformatf("Unexpected error %s", error.kind.name()));

          result.matches_ok(parsed): begin
            curr_pos = parsed.end_pos + 1; // move from colon to next character
            state = PARSE_VALUE;
          end
        endcase
      end

      PARSE_VALUE: begin
        result = parse_value(str, curr_pos);
        case(1)
          result.matches_err(error): return result;

          result.matches_ok(parsed): begin
            values[key] = parsed.value;
            curr_pos = parsed.end_pos + 1; // move from last value token
            state = EXPECT_COMMA_OR_RIGHT_CURLY;
          end
        endcase
      end

      EXPECT_COMMA_OR_RIGHT_CURLY: begin
        result = scan_until_token(str, curr_pos, '{",", "}"});
        case(1)
          result.matches_err_eq(json_error::EXPECTED_TOKEN, error):
            return `JSON_SYNTAX_ERR(json_error::EXPECTED_OBJECT_COMMA_OR_END, str, error.json_idx);

          result.matches_err_eq(json_error::EOF_VALUE, error):
            return `JSON_SYNTAX_ERR(json_error::EOF_OBJECT, str, error.json_idx);

          result.matches_err(error): return `JSON_INTERNAL_ERR($sformatf("Unexpected error %s", error.kind.name()));

          result.matches_ok(parsed): begin
            curr_pos = parsed.end_pos;
            if (str[curr_pos] == "}") begin
              exit_parsing_loop = 1; // end of object
            end else begin
              trailing_comma = 1;
              curr_pos++; // move to a symbol after comma
              state = PARSE_KEY;
            end
          end
        endcase
      end
    endcase
  end

  parsed.value = json_object::from(values);
  parsed.end_pos = curr_pos;
  return parser_result::ok(parsed);
endfunction : parse_object


function json_decoder::parser_result json_decoder::parse_array(const ref string str, input int unsigned start_pos);
  enum {
    PARSE_VALUE,
    EXPECT_COMMA_OR_RIGHT_BRACE
  } state = PARSE_VALUE;

  json_value values[$];

  json_error error;
  parser_result result;
  parsed_s parsed;

  int unsigned curr_pos = start_pos;
  bit trailing_comma = 0;
  bit exit_parsing_loop = 0;

  while(!exit_parsing_loop) begin
    case (state)
      PARSE_VALUE: begin
        result = parse_value(str, curr_pos);
        case (1)
          result.matches_err_eq(json_error::EXPECTED_VALUE, error): begin
            if (str[error.json_idx] == "]") begin
              if (trailing_comma) begin
                return `JSON_SYNTAX_ERR(json_error::TRAILING_COMMA, str, error.json_idx);
              end
              curr_pos = error.json_idx;
              exit_parsing_loop = 1; // empty array parsed
            end else begin
              return result;
            end
          end

          result.matches_err(error): return result;

          result.matches_ok(parsed): begin
            values.push_back(parsed.value);
            curr_pos = parsed.end_pos + 1; // move from last value token
            state = EXPECT_COMMA_OR_RIGHT_BRACE;
          end
        endcase
      end

      EXPECT_COMMA_OR_RIGHT_BRACE: begin
        result = scan_until_token(str, curr_pos, '{",", "]"});
        case (1)
          result.matches_err_eq(json_error::EXPECTED_TOKEN, error):
            return `JSON_SYNTAX_ERR(json_error::EXPECTED_ARRAY_COMMA_OR_END, str, error.json_idx);

          result.matches_err_eq(json_error::EOF_VALUE, error):
            return `JSON_SYNTAX_ERR(json_error::EOF_ARRAY, str, error.json_idx);

          result.matches_err(error): return `JSON_INTERNAL_ERR($sformatf("Unexpected error %s", error.kind.name()));

          result.matches_ok(parsed): begin
            curr_pos = parsed.end_pos;
            if (str[curr_pos] == "]") begin
              exit_parsing_loop = 1; // end of array
            end else begin
              trailing_comma = 1;
              curr_pos++; // move to a symbol after comma
              state = PARSE_VALUE;
            end
          end
        endcase
      end
    endcase
  end

  parsed.value = json_array::from(values);
  parsed.end_pos = curr_pos;
  return parser_result::ok(parsed);
endfunction : parse_array


function json_decoder::parser_result json_decoder::parse_string(const ref string str, input int unsigned start_pos);
  enum {
    EXPECT_DOUBLE_QUOTE,
    SCAN_CHARS,
    PARSE_ESCAPE,
    PARSE_UNICODE
  } state = EXPECT_DOUBLE_QUOTE;

  string value;

  json_error error;
  parser_result result;
  parsed_s parsed;

  int unsigned curr_pos = start_pos;
  int unsigned str_len = str.len();
  bit exit_parsing_loop = 0;

  while(!exit_parsing_loop) begin
    case (state)
      EXPECT_DOUBLE_QUOTE: begin
        result = scan_until_token(str, curr_pos, '{"\""});
        case (1)
          result.matches_err_eq(json_error::EXPECTED_TOKEN, error):
            return `JSON_SYNTAX_ERR(json_error::EXPECTED_DOUBLE_QUOTE, str, error.json_idx);

          result.matches_err_eq(json_error::EOF_VALUE, error):
            return `JSON_SYNTAX_ERR(json_error::EOF_STRING, str, error.json_idx);

          result.matches_err(error): return `JSON_INTERNAL_ERR($sformatf("Unexpected error %s", error.kind.name()));

          result.matches_ok(parsed): begin
            curr_pos = parsed.end_pos + 1;
            state = SCAN_CHARS;
          end
        endcase
      end

      SCAN_CHARS: begin
        while (curr_pos < str_len) begin
          if (str[curr_pos] == "\\") begin
            value = {value, str[curr_pos++]};
            state = PARSE_ESCAPE;
            break;
          end else if (str[curr_pos] == "\"") begin
            exit_parsing_loop = 1;
            break;
          end else begin
            value = {value, str[curr_pos++]};
          end
        end
        if (curr_pos == str_len) begin
          return `JSON_SYNTAX_ERR(json_error::EOF_STRING, str, curr_pos - 1);
        end
      end

      PARSE_ESCAPE: begin
        if (str[curr_pos] inside {this.escape_chars}) begin
          value = {value, str[curr_pos++]};
          state = SCAN_CHARS;
        end else if (str[curr_pos] == "u") begin
          value = {value, str[curr_pos++]};
          state = PARSE_UNICODE;
        end else begin
          return `JSON_SYNTAX_ERR(json_error::INVALID_ESCAPE, str, curr_pos);
        end
      end

      PARSE_UNICODE: begin
        int unsigned unicode_char_cnt = 0;
        while ((curr_pos < str_len) && (unicode_char_cnt < 4)) begin
          if (str[curr_pos] inside {this.hex_chars}) begin
            value = {value, str[curr_pos++]};
          end else begin
            return `JSON_SYNTAX_ERR(json_error::INVALID_UNICODE, str, curr_pos);
          end
          unicode_char_cnt++;
        end
        if (curr_pos == str_len) begin
          return `JSON_SYNTAX_ERR(json_error::EOF_STRING, str, curr_pos - 1);
        end
        state = SCAN_CHARS;
      end
    endcase
  end

  parsed.value = json_string::from(value);
  parsed.end_pos = curr_pos;
  return parser_result::ok(parsed);
endfunction : parse_string


function json_decoder::parser_result json_decoder::parse_number(const ref string str, input int unsigned start_pos);
  parsed_s parsed;
  real real_value;
  longint int_value;
  string value = "";
  bit is_real = 0;
  int unsigned str_len = str.len();
  int unsigned curr_pos = start_pos;

  while ((str[curr_pos] inside {this.number_chars}) && (curr_pos < str_len)) begin
    value = {value, str[curr_pos]};
    curr_pos++;
    is_real |= (str[curr_pos] inside {".", "e", "E"});
  end

  parsed.end_pos = curr_pos - 1;
  if (is_real && $sscanf(value, "%f", real_value) > 0) begin
    parsed.value = json_real::from(real_value);
    return parser_result::ok(parsed);
  end else if ($sscanf(value, "%d", int_value) > 0) begin
    parsed.value = json_int::from(int_value);
    return parser_result::ok(parsed);
  end else begin
    return `JSON_SYNTAX_ERR(json_error::INVALID_NUMBER, str, parsed.end_pos);
  end
endfunction : parse_number


function json_decoder::parser_result json_decoder::parse_literal(const ref string str, input int unsigned start_pos);
  string literal;
  string literal_expected;
  parsed_s parsed;
  int unsigned curr_pos = start_pos;

  case (str[curr_pos])
    "t": begin
      literal_expected = "true";
      parsed.end_pos = curr_pos + 3;
      parsed.value = json_bool::from(1);
    end

    "f": begin
      literal_expected = "false";
      parsed.end_pos = curr_pos + 4;
      parsed.value = json_bool::from(0);
    end

    "n": begin
      literal_expected = "null";
      parsed.end_pos = curr_pos + 3;
      parsed.value = json_null::create();
    end

    default: return `JSON_INTERNAL_ERR("Unreachable case branch");
  endcase

  literal = str.substr(curr_pos, parsed.end_pos);
  if (literal == "") begin
    return `JSON_SYNTAX_ERR(json_error::EOF_LITERAL, str, curr_pos);
  end else if (literal != literal_expected)begin
    return `JSON_SYNTAX_ERR(json_error::INVALID_LITERAL, str, curr_pos);
  end else begin
    return parser_result::ok(parsed);
  end
endfunction : parse_literal


function json_decoder::parser_result json_decoder::scan_until_token(
  const ref string str,
  input int unsigned start_pos,
  input byte expected_tokens [] = '{}
);
  int unsigned len = str.len();
  int unsigned idx = start_pos;

  while ((str[idx] inside {this.whitespace_chars}) && (idx < len)) begin
    idx++;
  end

  if (idx == str.len()) begin
    return `JSON_SYNTAX_ERR(json_error::EOF_VALUE, "", idx - 1);
  end else if ((expected_tokens.size() > 0) && !(str[idx] inside {expected_tokens})) begin
    return `JSON_SYNTAX_ERR(json_error::EXPECTED_TOKEN, "", idx);
  end else begin
    parsed_s res;
    res.end_pos = idx;
    return parser_result::ok(res);
  end
endfunction : scan_until_token
