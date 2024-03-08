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

  // Load and decode string into JSON value
  extern static function json_result load_string(string str);

  // Load and decode file into JSON value
  extern static function json_result load_file(string path);

  //----------------------------------------------------------------------------
  // Private methods
  //----------------------------------------------------------------------------

  // Private constructor
  extern function new();

  // Scan string symbol by symbol to encounter and extract JSON values recursively.
  local function parser_result parse_value(const ref string str, input int unsigned start_pos);
    parser_result scan_result;
    json_error scan_error;
    parsed_s scan_value;
    int unsigned idx = start_pos;

    // Skip all whitespaces until valid token
    scan_result = scan_until_token(str, idx, this.value_start_chars);
    case (1)
      scan_result.matches_err_eq(json_error::EXPECTED_TOKEN, scan_error):
        return `JSON_SYNTAX_ERR(json_error::EXPECTED_VALUE, str, scan_error.json_idx);

      scan_result.matches_err_eq(json_error::EOF_VALUE, scan_error):
        return `JSON_SYNTAX_ERR(json_error::EOF_VALUE, str, scan_error.json_idx);

      scan_result.matches_ok(scan_value): idx = scan_value.end_pos;

      default: return `JSON_INTERNAL_ERR("Unreachable case branch");
    endcase

    // Current character must start a value
    case (str[idx]) inside
      "{": return parse_object(str, idx);
      "[": return parse_array(str, idx);
      "\"": return parse_string(str, idx);
      "n", "t", "f": return parse_literal(str, idx);
      "-", ["0":"9"]: return parse_number(str, idx);

      default: return `JSON_SYNTAX_ERR(json_error::EXPECTED_VALUE, str, idx);
    endcase
  endfunction : parse_value


  local function parser_result parse_object(const ref string str, input int unsigned start_pos);
  endfunction : parse_object


  local function parser_result parse_array(const ref string str, input int unsigned start_pos);
  endfunction : parse_array


  local function parser_result parse_string(const ref string str, input int unsigned start_pos);
  endfunction : parse_string


  local function parser_result parse_number(const ref string str, input int unsigned start_pos);
  endfunction : parse_number


  local function parser_result parse_literal(const ref string str, input int unsigned start_pos);
  endfunction : parse_literal

  // Scan input string char by char ignoring any whitespaces and stop at first non-whitespace char.
  // Return error with last char position if non-whitespace char was not found or do not match expected ones.
  // Return OK and position of found char within string otherwise.
  local function parser_result scan_until_token(
    const ref string str,
    int unsigned start_pos,
    byte expected_tokens [] = '{}
  );
    int unsigned len = str.len();
    int unsigned idx = start_pos;

    while ((str[idx] inside {this.whitespace_chars}) && (idx < len)) begin
      idx++;
    end

    if (idx == str.len()) begin
      return parser_result::err(json_error::create(json_error::EOF_VALUE, .json_idx(idx - 1)));
    end else if ((expected_tokens.size() > 0) && !(str[idx] inside {expected_tokens})) begin
      return parser_result::err(json_error::create(json_error::EXPECTED_TOKEN, .json_idx(idx)));
    end else begin
      parsed_s res;
      res.end_pos = idx;
      return parser_result::ok(res);
    end
  endfunction : scan_until_token
endclass : json_decoder


function json_result json_decoder::load_string(string str);
endfunction : load_string


function json_result json_decoder::load_file(string path);
endfunction : load_file


function json_decoder::new();
endfunction : new


/*
function json_result json_decoder::parse_object(
  const ref string str,
  input int unsigned start_pos,
  output int unsigned end_pos
);
  enum {
    PARSE_KEY,
    EXPECT_COLON,
    PARSE_VALUE,
    EXPECT_COMMA_OR_RIGHT_CURLY
  } state = PARSE_KEY;

  string key;
  json_value values [string];
  json_result#(int unsigned) scan_result;
  json_error scan_error;
  int unsigned idx = start_pos;
  bit trailing_comma = 0;

  forever begin
    case (state)
      PARSE_KEY: begin
        json_error error;
        json_string value;
        json_result result = parse_string(str, idx, idx);

        case(1)
          scan_result.matches_err(json_error::EXPECTED_DOUBLE_QUOTE, error): begin
            if (str[error.json_idx] == "}") begin
              if (trailing_comma) begin
                return `JSON_SYNTAX_ERR(json_error::TRAILING_COMMA, str, error.json_idx);
              end
              break; // empty object parsed
            end
          end

          result.matches_any_err(error): return result;

          result.matches_ok(error): begin
            key = result.value.as_json_string().unwrap();
            idx++; // move from last string token
            state = EXPECT_COLON;
          end

        endcase

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

  end_pos = idx;
  return json_result::ok(json_object::create(values));
endfunction : parse_object


function json_result json_decoder::parse_array(
  const ref string str,
  input int unsigned start_pos,
  output int unsigned end_pos
);
  enum {
    PARSE_VALUE,
    EXPECT_COMMA_OR_RIGHT_BRACE
  } state = PARSE_VALUE;

  json_value values[$];
  json_err_e scan_err;
  int unsigned idx = start_pos;
  bit trailing_comma = 0;

  forever begin
    case (state)
      PARSE_VALUE: begin
        json_result result = parse_value(str, idx, idx);

        if (result.is_err()) begin
          case (scan_err)
            JSON_ERR_EXPECTED_VALUE: begin
              if (str[idx] == "]") begin
                if (trailing_comma) begin
                  return `JSON_SYNTAX_ERR(JSON_ERR_TRAILING_COMMA, str, idx);
                end
                break; // empty array parsed
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

  end_pos = idx;
  return json_result::ok(json_array::create(values));
endfunction : parse_array


function json_result json_decoder::parse_string(
  const ref string str,
  input int unsigned start_pos,
  output int unsigned end_pos
);
  enum {
    EXPECT_DOUBLE_QUOTE,
    SCAN_CHARS,
    PARSE_ESCAPE,
    PARSE_UNICODE
  } state = EXPECT_DOUBLE_QUOTE;

  string value;
  json_err_e scan_err;
  int unsigned idx = start_pos;
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
            end_pos = idx;
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


function json_result json_decoder::parse_number(
  const ref string str,
  input int unsigned start_pos,
  output int unsigned end_pos
);
  real real_value;
  longint int_value;
  string value = "";
  int unsigned len = str.len();
  int unsigned idx = start_pos;

  while ((str[idx] inside {this.number_chars}) && (idx < len)) begin
    value = {value, str[idx]};
    idx++;
  end
  end_pos = idx - 1;

  if ($sscanf(value, "%d", int_value) > 0) begin
    return json_result::ok(json_int::create(int_value));
  end else if ($sscanf(value, "%f", real_value) > 0) begin
    return json_result::ok(json_real::create(real_value));
  end else begin
    return `JSON_SYNTAX_ERR(JSON_ERR_INVALID_NUMBER, str, end_pos);
  end
endfunction : parse_number


function json_result json_decoder::parse_literal(
  const ref string str,
  input int unsigned start_pos,
  output int unsigned end_pos
);
  string literal;
  string literal_expected;
  json_result ok_result;
  int unsigned idx = start_pos;

  case (str[idx])
    "t": begin
      end_pos = idx + 3;
      literal_expected = "true";
      ok_result = json_result::ok(json_bool::create(1));
    end

    "f": begin
      end_pos = idx + 4;
      literal_expected = "false";
      ok_result = json_result::ok(json_bool::create(0));
    end

    "n": begin
      end_pos = idx + 3;
      literal_expected = "null";
      ok_result = json_result::ok(null);
    end

    default: return `JSON_INTERNAL_ERR("Unreachable case branch");
  endcase

  literal = str.substr(idx, end_pos);
  if (literal == "") begin
    return `JSON_SYNTAX_ERR(JSON_ERR_EOF_LITERAL, str, idx);
  end else if (literal != literal_expected)begin
    return `JSON_SYNTAX_ERR(JSON_ERR_INVALID_LITERAL, str, idx);
  end else begin
    return ok_result;
  end
endfunction : parse_literal

*/
