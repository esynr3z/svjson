class json_error;
  // All types of JSON related errors
  typedef enum {
    // JSON syntax errors
    EOF_VALUE,                     // EOF while parsing some JSON value
    EOF_OBJECT,                    // EOF while parsing an object
    EOF_ARRAY,                     // EOF while parsing an array
    EOF_STRING,                    // EOF while parsing a string
    EOF_LITERAL,                   // EOF while parsing a literal
    EXPECTED_TOKEN,                // Current character should be some expected token
    EXPECTED_COLON,                // Current character should be ':'
    EXPECTED_OBJECT_COMMA_OR_END,  // Current character should be either ',' or '}'
    EXPECTED_ARRAY_COMMA_OR_END,   // Current character should be either ',' or ']'
    EXPECTED_DOUBLE_QUOTE,         // Current character should be '"'
    EXPECTED_VALUE,                // Current character should start some JSON value
    INVALID_ESCAPE,                // Invaid escape code
    INVALID_UNICODE,               // Invaid characters in unicode
    INVALID_LITERAL,               // Invaid number
    INVALID_NUMBER,                // Invaid number
    INVALID_OBJECT_KEY,            // String must be used as a key
    TRAILING_COMMA,                // Unexpected comma after the last value of object/array
    TRAILING_CHARS,                // Unexpected characters after the JSON value
    // IO and generic errors
    FILE_NOT_OPENED,               // File opening failed
    NOT_IMPLEMENTED,               // Feature is not implemented
    INTERNAL                       // Unspecified internal error
  } kind_e;

  kind_e kind;
  string description;
  string file;
  int line;
  string json_str;
  int json_idx;

  // Create empty error
  extern function new();

  // Create error
  extern function json_error create(
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
endclass : json_error


function json_error::new(kind_e kind);
  this.kind = kind;
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
  $fatal(0, "not implemented");
endfunction : to_string
