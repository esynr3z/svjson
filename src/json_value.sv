// Base JSON value
virtual class json_value;
  pure virtual function json_value clone();
  pure virtual function bit compare(json_value value);
  pure virtual function json_value_e kind();

  extern function json_value as_json_value();
  extern function json_object as_json_object();
  //extern function json_array as_json_array();
  extern function json_string as_json_string();
  //extern function json_int as_json_int();
  //extern function json_real as_json_real();
  //extern function json_bool as_json_bool();
  //extern function json_null as_json_null();

  extern function bit is_json_object();
  //extern function bit is_json_array();
  extern function bit is_json_string();
  //extern function bit is_json_int();
  //extern function bit is_json_real();
  //extern function bit is_json_bool();
  //extern function bit is_json_null();


  // Scan string symbol by symbol to encounter and extract JSON values recursively.
  extern local static function json_result parse_value(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  // Parse JSON object from provided string.
  // String must start from '{' (`start_idx`) and consist a pair symbol '}' (`end_idx`).
  extern local static function json_result parse_object(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );

  local static function json_result parse_array(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );
  endfunction

  local static function json_result parse_string(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );
  endfunction

  local static function json_result parse_number(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );
  endfunction

  local static function json_result parse_bool(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );
  endfunction

  local static function json_result parse_null(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx
  );
  endfunction

  // Scan input string char by char ignoring any whitespaces and stop at first non-whitespace char.
  // Return 0 and error code if non-whitespace char was not found or do not match expected ones.
  // Return 1 and position of found char within string otherwise.
  extern local static function bit scan_until_token(
    const ref string str,
    input int unsigned start_idx,
    output int unsigned end_idx,
    output json_err_e err_kind,
    input byte expected_tokens [] = '{}
  );
endclass : json_value


function json_value json_value::as_json_value();
  return this;
endfunction : as_json_value


function json_object json_value::as_json_object();
  $cast(as_json_object, this);
endfunction : as_json_object


function json_string json_value::as_json_string();
  $cast(as_json_string, this);
endfunction : as_json_string


function bit json_value::is_json_object();
  return (this.kind() == JSON_VALUE_OBJECT);
endfunction : is_json_object

function bit json_value::is_json_string();
  return (this.kind() == JSON_VALUE_STRING);
endfunction : is_json_string


function json_result json_value::parse_value(
  const ref string str,
  input int unsigned start_idx=0,
  output int unsigned end_idx
);
  const byte value_start_tokens[] = '{
    "{", "[", "\"", "n", "t", "f", "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
  };
  json_err_e scan_err;
  int unsigned idx = start_idx;

  // Skip all whitespaces until valid token
  if (!scan_until_token(str, idx, idx, scan_err, value_start_tokens)) begin
    case (scan_err)
      JSON_ERR_EXPECTED_TOKEN: begin
        return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_VALUE, str, idx);
      end
      JSON_ERR_EOF_VALUE: begin
        return `JSON_SYNTAX_ERR(JSON_ERR_EOF_VALUE, str, idx);
      end
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
    "-", ["0":"9"]: return parse_number(str, idx, idx);

    default: return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_VALUE, str, idx);
  endcase
endfunction : parse_value


function json_result json_value::parse_object(
  const ref string str,
  input int unsigned start_idx,
  output int unsigned end_idx
);
  enum {
    EXPECT_QUOTE_OR_RIGHT_CURLY,
    PARSE_KEY,
    EXPECT_COLON,
    PARSE_VALUE,
    EXPECT_COMMA_OR_RIGHT_CURLY,
    RETURN_OK,
    RETURN_ERR
  } state = EXPECT_QUOTE_OR_RIGHT_CURLY;

  string key;
  json_value values [string];
  json_err_e scan_err;
  int unsigned idx = start_idx;
  bit trailing_comma = 0;

  forever begin
    case (state)
      EXPECT_QUOTE_OR_RIGHT_CURLY: begin
        if (!scan_until_token(str, idx, idx, scan_err, '{"\"", "}"})) begin
          case (scan_err)
            JSON_ERR_EXPECTED_TOKEN: begin
              return `JSON_SYNTAX_ERR(JSON_ERR_INVALID_OBJECT_KEY, str, idx);
            end
            JSON_ERR_EOF_VALUE: begin
              return `JSON_SYNTAX_ERR(JSON_ERR_EOF_OBJECT, str, idx);
            end
            default: return `JSON_INTERNAL_ERR("Unreachable case branch");
          endcase
        end

        if (str[idx] == "}") begin
          if (trailing_comma) begin
            return `JSON_SYNTAX_ERR(JSON_ERR_TRAILING_COMMA, str, idx);
          end else begin
            break;
          end
        end else begin
          trailing_comma = 0;
          state = PARSE_KEY;
        end
      end

      PARSE_KEY: begin
        json_result result = parse_string(str, idx, idx);
        if (result.is_err()) begin
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
            JSON_ERR_EXPECTED_TOKEN: begin
              return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_COLON, str, idx);
            end
            JSON_ERR_EOF_VALUE: begin
              return `JSON_SYNTAX_ERR(JSON_ERR_EOF_OBJECT, str, idx);
            end
            default: return `JSON_INTERNAL_ERR("Unreachable case branch");
          endcase
        end
        idx++; // move from colon to next character
        state = PARSE_VALUE;
      end

      PARSE_VALUE: begin
        // Parse value
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
            JSON_ERR_EXPECTED_TOKEN: begin
              return `JSON_SYNTAX_ERR(JSON_ERR_EXPECTED_OBJECT_COMMA_OR_END, str, idx);
            end
            JSON_ERR_EOF_VALUE: begin
              return `JSON_SYNTAX_ERR(JSON_ERR_EOF_OBJECT, str, idx);
            end
            default: return `JSON_INTERNAL_ERR("Unreachable case branch");
          endcase
        end

        if (str[idx] == "}") begin
          break;
        end else begin
          trailing_comma = 1;
          state = EXPECT_QUOTE_OR_RIGHT_CURLY;
        end
      end
    endcase
  end

  end_idx = idx;
  return json_result::ok(json_object::create(values));
endfunction : parse_object


function bit json_value::scan_until_token(
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
    end_idx = start_idx;
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
