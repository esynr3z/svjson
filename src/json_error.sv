// Generic JSON error
class json_error;
  // Width of context for printing JSON errors.
  // It controls how long would be part of a JSON string to show the context.
  // Why 80? Just a reasonable number for a message in CLI.
  static int unsigned ctx_width = 80;

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
    INVALID_CHAR,
    INVALID_LITERAL,
    INVALID_NUMBER,
    INVALID_OBJECT_KEY,
    TRAILING_COMMA,
    TRAILING_CHARS,
    DEEP_NESTING,
    // IO and generic errors
    TYPE_CONVERSION,
    FILE_NOT_OPENED,
    NOT_IMPLEMENTED,
    INTERNAL
  } kind_e;

  // Error properties
  const string info [kind_e];
  kind_e kind;
  string description;
  string file;
  int line;
  string json_str;
  int json_pos;

  // Create empty error
  extern function new();

  // Create error
  extern static function json_error create(
    kind_e kind,
    string description="",
    string json_str="",
    int json_pos=-1,
    string source_file="",
    int source_line=-1
  );

  // Report error
  extern virtual function void throw_error();

  // Report fatal
  extern virtual function void throw_fatal();

  // Convert error to printable string
  extern virtual function string to_string();

  // Try to extract context for error from provided JSON string
  extern protected virtual function string extract_err_context();

  // Make error context human readable
  extern protected virtual function string prettify_err_context(string err_ctx, int err_pos, int err_line_idx);
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
  this.info[INVALID_CHAR] =                 "Unexpected control character";
  this.info[INVALID_LITERAL] =              "Invaid literal that should be 'true', 'false', or 'null'";
  this.info[INVALID_NUMBER] =               "Invaid number";
  this.info[INVALID_OBJECT_KEY] =           "String must be used as a key";
  this.info[TRAILING_COMMA] =               "Unexpected comma after the last value";
  this.info[TRAILING_CHARS] =               "Unexpected characters after the JSON value";
  this.info[DEEP_NESTING] =                 "This JSON value exceeds nesing limit for a decoder";
  this.info[TYPE_CONVERSION] =              "Type conversion failed";
  this.info[FILE_NOT_OPENED] =              "File opening failed";
  this.info[NOT_IMPLEMENTED] =              "Feature is not implemented";
  this.info[INTERNAL] =                     "Unspecified internal error";
endfunction : new


function json_error json_error::create(
  kind_e kind,
  string description="",
  string json_str="",
  int json_pos=-1,
  string source_file="",
  int source_line=-1
);
   json_error err = new(kind);
   err.description = description;
   err.json_str = json_str;
   err.json_pos = json_pos;
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
  string str = "JSON error";

  // Add information about file and line where error was raised if this was provided
  if (this.file != "") begin
    str = {str, $sformatf(" raised from %s", this.file)};
    if (this.line >= 0) begin
      str = {str, $sformatf(":%0d", this.line)};
    end
  end

  // Add error kind and base information
  str = {str, $sformatf(":\n%s: %s", this.kind.name(), this.info[this.kind])};

  // Add custom description if exists
  if (this.description != "") begin
    str = {str, $sformatf("\n%s", this.description)};
  end

  // Provide context from JSON error if context was provided
  if ((this.json_pos >= 0) && (this.json_str.len() > 0) && (this.json_pos < this.json_str.len())) begin
    string err_ctx = this.extract_err_context();
    str = {str, {"\n", err_ctx}};
  end

  return str;
endfunction : to_string


function string json_error::extract_err_context();
  int ctx_start_idx = 0;
  int ctx_end_idx = this.json_str.len() - 1;

  int err_pos;
  int err_line_idx;
  string err_ctx;

  // Locate line with error
  foreach (json_str[i]) begin
    if (json_str[i] == "\n") begin
      ctx_end_idx = i;
      if (ctx_end_idx >= this.json_pos) begin
        break;
      end
      ctx_start_idx = i + 1;
      err_line_idx++;
    end
  end

  // Extract this line
  err_ctx = this.json_str.substr(ctx_start_idx, ctx_end_idx);
  err_pos = this.json_pos - ctx_start_idx;

  // Make the error context more human readable
  return prettify_err_context(err_ctx, err_pos, err_line_idx);
endfunction : extract_err_context


function string json_error::prettify_err_context(string err_ctx, int err_pos, int err_line_idx);
  int ctx_width_half = ctx_width / 2 - 1;
  string pretty_ctx;
  int pretty_start_idx;
  int pretty_end_idx;
  string pointer_offset;

  // Cut off line to fit context width window
  pretty_start_idx = (err_pos - ctx_width_half) < 0 ? 0 : err_pos - ctx_width_half;
  pretty_end_idx = (err_ctx.len() - pretty_start_idx - 1) < 78 ? err_ctx.len() - 1 :
                                                                 pretty_start_idx + ctx_width_half * 2;
  if (err_ctx[pretty_end_idx] == "\n") begin
    pretty_end_idx--; // there might be a single newline character that has to be handled
  end

  // Prepare final context line
  pretty_ctx = err_ctx.substr(pretty_start_idx, pretty_end_idx);
  if (pretty_start_idx > 0) begin
    for (int i = 0; i < 3; i++) begin
      pretty_ctx[i] = "."; // just to show that error is far away from line start
    end
  end
  if (pretty_end_idx < (err_ctx.len() - 2)) begin
    for (int i = pretty_ctx.len() - 3; i < pretty_ctx.len(); i++) begin
      pretty_ctx[i] = "."; // just to show that error is far away from line end
    end
  end

  // Prepare offset for error pointer
  repeat(err_pos - pretty_start_idx) begin
    pointer_offset = {pointer_offset, " "};
  end

  return $sformatf(
    "JSON string line %0d symbol %0d:\n%s\n%s\n%s",
    err_line_idx + 1, // lines and symbols in text are usually counted from 1 by a normal human
    err_pos + 1,
    pretty_ctx,
    {pointer_offset, "^"},
    {pointer_offset, "|"}
  );
endfunction : prettify_err_context
