class json_error;
  // All types of JSON related errors
  typedef enum {
    // JSON syntax errors
    EOF_VALUE,
    EOF_OBJECT,
    EOF_ARRAY,
    EOF_STRING,
    EOF_LITERAL,
    EXPECTED_TOKEN,
    EXPECTED_COLON,
    EXPECTED_OBJECT_COMMA_OR_END,
    EXPECTED_ARRAY_COMMA_OR_END,
    EXPECTED_DOUBLE_QUOTE,
    EXPECTED_VALUE,
    INVALID_ESCAPE,
    INVALID_UNICODE,
    INVALID_LITERAL,
    INVALID_NUMBER,
    INVALID_OBJECT_KEY,
    TRAILING_COMMA,
    TRAILING_CHARS,
    // IO and generic errors
    TYPE_CONVERSION,
    FILE_NOT_OPENED,
    NOT_IMPLEMENTED,
    INTERNAL
  } kind_e;

  const string info [kind_e];

  kind_e kind;
  string description;
  string file;
  int line;
  string json_str;
  int json_idx;

  // Create empty error
  extern function new();

  // Create error
  extern static function json_error create(
    kind_e kind,
    string description="",
    string json_str="",
    int json_idx=-1,
    string source_file="",
    int source_line=-1
  );

  // Report error
  extern function void throw_error();

  // Report fatal
  extern function void throw_fatal();

  // Convert error to printable string
  extern function string to_string();

  // Extract context for error from JSON string
  extern protected function string extract_json_context();
endclass : json_error


function json_error::new(kind_e kind);
  this.kind = kind;

  this.info[EOF_VALUE] =                    "EOF while parsing some JSON value";
  this.info[EOF_OBJECT] =                   "EOF while parsing an object";
  this.info[EOF_ARRAY] =                    "EOF while parsing an array";
  this.info[EOF_STRING] =                   "EOF while parsing a string";
  this.info[EOF_LITERAL] =                  "EOF while parsing a literal";
  this.info[EXPECTED_TOKEN] =               "Current character should be some expected token";
  this.info[EXPECTED_COLON] =               "Current character should be ':'";
  this.info[EXPECTED_OBJECT_COMMA_OR_END] = "Current character should be either ',' or '}'";
  this.info[EXPECTED_ARRAY_COMMA_OR_END] =  "Current character should be either ',' or ']'";
  this.info[EXPECTED_DOUBLE_QUOTE] =        "Current character should be '\"'";
  this.info[EXPECTED_VALUE] =               "Current character should start some JSON value";
  this.info[INVALID_ESCAPE] =               "Invaid escape code";
  this.info[INVALID_UNICODE] =              "Invaid characters in unicode";
  this.info[INVALID_LITERAL] =              "Invaid literal that should be 'true', 'false', or 'null'";
  this.info[INVALID_NUMBER] =               "Invaid number";
  this.info[INVALID_OBJECT_KEY] =           "String must be used as a key";
  this.info[TRAILING_COMMA] =               "Unexpected comma after the last value";
  this.info[TRAILING_CHARS] =               "Unexpected characters after the JSON value";
  this.info[TYPE_CONVERSION] =              "Type conversion failed";
  this.info[FILE_NOT_OPENED] =              "File opening failed";
  this.info[NOT_IMPLEMENTED] =              "Feature is not implemented";
  this.info[INTERNAL] =                     "Unspecified internal error";
endfunction : new


function json_error json_error::create(
  kind_e kind,
  string description="",
  string json_str="",
  int json_idx=-1,
  string source_file="",
  int source_line=-1
);
   json_error err = new(kind);
   err.description = description;
   err.json_str = json_str;
   err.json_idx = json_idx;
   err.file = source_file;
   err.line = source_line;
   return err;
endfunction : create


function void json_error::throw_error();
  $error(this.to_string());
endfunction : throw_error


function void json_error::throw_fatal();
  $fatal(0, this.to_string());
endfunction : throw_fatal


function string json_error::to_string();
  string str = $sformatf("JSON error %s: %s", this.kind.name(), this.info[this.kind]);

  if (this.file != "") begin
    str = {str, $sformatf("\n%s", this.file)};
    if (this.line >= 0) begin
      str = {str, $sformatf(":%0d", this.line)};
    end
  end

  if (this.description != "") begin
    str = {str, $sformatf("\n%s", this.description)};
  end

  if (this.json_idx >= 0) begin
    str = {str, {"\n", this.extract_json_context()}};
  end

  return str;
endfunction : to_string


function string json_error::extract_json_context();
  int ctx_start_idx = 0;
  int ctx_end_idx = this.json_str.len() - 1;
  int line_ends[$];
  string pointer_offset = "";
  string line;

  // Locate all line endings
  foreach (json_str[i]) begin
    if (json_str[i] == "\n") begin
      line_ends.push_back(i);
    end
  end

  // Locate line with context
  foreach (line_ends[i]) begin
    if (line_ends[i] < this.json_idx) begin
      ctx_start_idx = line_ends[i];
    end else if (line_ends[i] >= this.json_idx) begin
      ctx_end_idx = line_ends[i];
    end
  end

  // Cut off line to fit 80 symbols
  ctx_start_idx = (this.json_idx - 40) < ctx_start_idx ? ctx_start_idx : this.json_idx - 40;
  ctx_end_idx = (this.json_idx + 39) > ctx_end_idx ? ctx_end_idx : this.json_idx + 39;

  // Prepare context line
  line = this.json_str.substr(ctx_start_idx, ctx_end_idx);
  if (ctx_start_idx > 0) begin
    for (int i = 0; i < 3;i++) begin
      line[i] = ".";
    end
  end

  // Prepare offset for pointer
  repeat(this.json_idx % 80) begin
    pointer_offset = {pointer_offset, " "};
  end

  return $sformatf("%s\n%s\n%s", line, {pointer_offset, "^"}, {pointer_offset, "|"});
endfunction : extract_json_context
