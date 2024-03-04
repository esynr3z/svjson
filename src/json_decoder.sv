// JSON decoder
class json_decoder;

  //----------------------------------------------------------------------------
  // Private properties
  //----------------------------------------------------------------------------

  local const byte escape_chars[] = '{"\"", "\\", "/", "b", "f", "n", "r", "t"};

  local const byte hex_chars[] = '{
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "a", "b", "c", "d", "e", "f", "A", "B", "C", "D", "E", "F"
  };

  local const byte value_start_chars[] = '{
    "{", "[", "\"", "n", "t", "f", "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
  };

  //----------------------------------------------------------------------------
  // Public methods
  //----------------------------------------------------------------------------

  // Load and decode string into JSON value
  extern static function json_result load_string(string str);

  // Load and decode file into JSON value
  extern static function json_result load_file(string path);

  //----------------------------------------------------------------------------
  // Private methods
  //----------------------------------------------------------------------------

  // Private constructor
  extern local function new();

  // Scan string symbol by symbol to encounter and extract JSON values recursively.
  extern local function json_result parse_value(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  // Parse JSON object from provided string.
  // String must start from '{' (`start_idx`) and consist a pair symbol '}' (`end_idx`).
  extern local function json_result parse_object(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  extern local function json_result parse_array(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  extern local function json_result parse_string(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  extern local function json_result parse_number(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  extern local function json_result parse_bool(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  extern local function json_result parse_null(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  // Scan input string char by char ignoring any whitespaces and stop at first non-whitespace char.
  // Return 0 and error code if non-whitespace char was not found or do not match expected ones.
  // Return 1 and position of found char within string otherwise.
  extern local function bit scan_until_token(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx,
    output json_err_e err_kind,
    input byte expected_tokens [] = '{}
  );
endclass : json_decoder


function json_result json_decoder::load_string(string str);
endfunction : load_string


function json_result json_decoder::load_file(string path);
endfunction : load_file


function json_decoder::new();
endfunction : new


function json_result json_decoder::parse_value(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  json_err_e scan_err;
  int unsigned idx = start_idx;

  // Skip all whitespaces until valid token
  if (!scan_until_token(str, idx, idx, scan_err, this.value_start_chars)) begin
    case (scan_err)
      JSON_ERR_EXPECTED_TOKEN: return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_VALUE, str, idx);
      JSON_ERR_EOF_VALUE: return `JSON_SYNTAX_ERR(JSON_ERR_EOF_VALUE, str, idx);
      default: return `JSON_INTERNAL_ERR("Unreachable case branch");
    endcase
  end

  // Current character must start a value
  case (str[idx]) inside
    "{": return parse_value(str, idx, end_idx);
    "[": return parse_array(str, idx, end_idx);
    "\"": return parse_value(str, idx, end_idx);
    "n": return parse_null(str, idx, end_idx);
    "t", "f": return parse_bool(str, idx, end_idx);
    "-", ["0":"9"]: return parse_number(str, idx, end_idx);

    default: return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_VALUE, str, idx);
  endcase
endfunction : parse_value


function json_result json_decoder::parse_object(
  const ref string str,
  input int unsigned start_idx,
  output int unsigned end_idx
);
  enum {
    PARSE_KEY,
    EXPECT_COLON,
    PARSE_VALUE,
    EXPECT_COMMA_OR_RIGHT_CURLY
  } state = PARSE_KEY;

  string key;
  json_value values [string];
  json_err_e scan_err;
  int unsigned idx = start_idx;
  bit trailing_comma = 0;

  forever begin
    case (state)
      PARSE_KEY: begin
        json_result result = parse_string(str, idx, idx);

        if (result.is_err()) begin
          if (result.err_kind == JSON_ERR_EXPECTED_DOUBLE_QUOTE) begin
            if (str[idx] == "}") begin
              if (trailing_comma) begin
                return `JSON_SYNTAX_ERR(JSON_ERR_TRAILING_COMMA, str, idx);
              end
              break; // empty object parsed
            end
          end
          return result;
        end else begin
          key = result.value.as_json_string().unwrap();
          idx++; // move from last string token
          state = EXPECT_COLON;
        end
      end

      EXPECT_COLON: begin
        if (!scan_until_token(str, idx, idx, scan_err, '{":"})) begin
          case (scan_err)
            JSON_ERR_EXPECTED_TOKEN: return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_COLON, str, idx);
            JSON_ERR_EOF_VALUE: return `JSON_SYNTAX_ERR(JSON_ERR_EOF_OBJECT, str, idx);
            default: return `JSON_INTERNAL_ERR("Unreachable case branch");
          endcase
        end
        idx++; // move from colon to next character
        state = PARSE_VALUE;
      end

      PARSE_VALUE: begin
        json_result result = parse_value(str, idx, idx);
        if (result.is_err()) begin
          return result;
        end else begin
          values[key] = result.value;
          idx++; // move from last value token
          state = EXPECT_COMMA_OR_RIGHT_CURLY;
        end
      end

      EXPECT_COMMA_OR_RIGHT_CURLY: begin
        if (!scan_until_token(str, idx, idx, scan_err, '{",", "}"})) begin
          case (scan_err)
            JSON_ERR_EXPECTED_TOKEN: return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_OBJECT_COMMA_OR_END, str, idx);
            JSON_ERR_EOF_VALUE: return `JSON_SYNTAX_ERR(JSON_ERR_EOF_OBJECT, str, idx);
            default: return `JSON_INTERNAL_ERR("Unreachable case branch");
          endcase
        end

        if (str[idx] == "}") begin
          break;
        end else begin
          trailing_comma = 1;
          state = PARSE_KEY;
        end
      end
    endcase
  end

  end_idx = idx;
  return json_result::ok(json_object::create(values));
endfunction : parse_object


function json_result json_decoder::parse_array(
  const ref string str,
  input int unsigned start_idx,
  output int unsigned end_idx
);
  enum {
    PARSE_VALUE,
    EXPECT_COMMA_OR_RIGHT_BRACE
  } state = PARSE_VALUE;

  json_value values[$];
  json_err_e scan_err;
  int unsigned idx = start_idx;
  bit trailing_comma = 0;

  forever begin
    case (state)
      PARSE_VALUE: begin
        json_result result = parse_value(str, idx, idx);

        if (result.is_err()) begin
          case (scan_err)
            JSON_ERR_EXPECTED_VALUE: begin
              if ((str[idx] == "]") && !trailing_comma) begin
                break;
              end else begin
                return result;
              end
            end
            JSON_ERR_EOF_VALUE: return `JSON_SYNTAX_ERR(JSON_ERR_EOF_ARRAY, str, idx);
            default: return `JSON_INTERNAL_ERR("Unreachable case branch");
          endcase
        end else begin
          values.push_back(result.value);
          idx++; // move from last value token
          state = EXPECT_COMMA_OR_RIGHT_BRACE;
        end
      end

      EXPECT_COMMA_OR_RIGHT_BRACE: begin
        if (!scan_until_token(str, idx, idx, scan_err, '{",", "]"})) begin
          case (scan_err)
            JSON_ERR_EXPECTED_TOKEN: return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_OBJECT_COMMA_OR_END, str, idx);
            JSON_ERR_EOF_VALUE: return `JSON_SYNTAX_ERR(JSON_ERR_EOF_ARRAY, str, idx);
            default: return `JSON_INTERNAL_ERR("Unreachable case branch");
          endcase
        end

        if (str[idx] == "]") begin
          break;
        end else begin
          trailing_comma = 1;
          state = PARSE_VALUE;
        end
      end
    endcase
  end

  end_idx = idx;
  return json_result::ok(json_array::create(values));
endfunction : parse_array


function json_result json_decoder::parse_string(
  const ref string str,
  input int unsigned start_idx,
  output int unsigned end_idx
);
  enum {
    EXPECT_DOUBLE_QUOTE,
    SCAN_CHARS,
    PARSE_ESCAPE,
    PARSE_UNICODE
  } state = EXPECT_DOUBLE_QUOTE;

  string value;
  json_err_e scan_err;
  int unsigned idx = start_idx;
  int unsigned len = str.len();

  forever begin
    case (state)
      EXPECT_DOUBLE_QUOTE: begin
        if (!scan_until_token(str, idx, idx, scan_err, '{"\""})) begin
          case (scan_err)
            JSON_ERR_EXPECTED_TOKEN: return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_DOUBLE_QUOTE, str, idx);
            JSON_ERR_EOF_VALUE: return `JSON_SYNTAX_ERR(JSON_ERR_EOF_STRING, str, idx);
            default: return `JSON_INTERNAL_ERR("Unreachable case branch");
          endcase
        end
        idx++;
        state = SCAN_CHARS;
      end

      SCAN_CHARS: begin
        while (idx < len) begin
          if (str[idx] == "\\") begin
            value = {value, str[idx++]};
            state = PARSE_ESCAPE;
            break;
          end else if (str[idx] == "\"") begin
            end_idx = idx;
            return json_result::ok(json_string::create(value));
          end else begin
            value = {value, str[idx++]};
          end
        end
        if (idx == len) begin
          return `JSON_SYNTAX_ERR(JSON_ERR_EOF_STRING, str, idx - 1);
        end
      end

      PARSE_ESCAPE: begin
        if (str[idx] inside {this.escape_chars}) begin
          value = {value, str[idx++]};
          state = SCAN_CHARS;
        end else if (str[idx] == "u") begin
          value = {value, str[idx++]};
          state = PARSE_UNICODE;
        end else begin
          return `JSON_SYNTAX_ERR(JSON_ERR_INVALID_ESCAPE, str, idx);
        end
        if (idx == len) begin
          return `JSON_SYNTAX_ERR(JSON_ERR_EOF_STRING, str, idx - 1);
        end
      end

      PARSE_UNICODE: begin
        int unsigned unicode_char_cnt = 0;
        while ((idx < len) && (unicode_char_cnt < 4)) begin
          if (str[idx] inside {this.hex_chars}) begin
            value = {value, str[idx++]};
          end else begin
            return `JSON_SYNTAX_ERR(JSON_ERR_INVALID_UNICODE, str, idx);
          end
          unicode_char_cnt++;
        end
        if (idx == len) begin
          return `JSON_SYNTAX_ERR(JSON_ERR_EOF_STRING, str, idx - 1);
        end
        state = SCAN_CHARS;
      end
    endcase
  end
endfunction : parse_string


function json_result parse_number(
  const ref string str,
  input int unsigned start_idx,
  output int unsigned end_idx
);
endfunction : parse_number


function json_result parse_bool(
  const ref string str,
  input int unsigned start_idx,
  output int unsigned end_idx
);
endfunction : parse_bool


function json_result parse_null(
  const ref string str,
  input int unsigned start_idx,
  output int unsigned end_idx
);
endfunction : parse_null


function bit json_decoder::scan_until_token(
  const ref string str,
  input int unsigned start_idx,
  output int unsigned end_idx,
  output json_err_e err_kind,
  input byte expected_tokens [] = '{}
);
  const byte whitespaces [] = '{" ", "\t", "\n", "\r"};
  int unsigned len = str.len();
  int unsigned idx = start_idx;

  while ((str[idx] inside {whitespaces}) && (idx < len)) begin
    idx++;
  end

  if (idx == str.len()) begin
    end_idx = idx - 1;
    err_kind = JSON_ERR_EOF_VALUE;
    return 0;
  end else if ((expected_tokens.size() > 0) && !(str[idx] inside {expected_tokens})) begin
    end_idx = idx;
    err_kind = JSON_ERR_EXPECTED_TOKEN;
    return 0;
  end else begin
    end_idx = idx;
    return 1;
  end
endfunction : scan_until_token
