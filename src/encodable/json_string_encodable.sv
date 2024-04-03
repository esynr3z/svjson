// Interface for a class that can be encoded as JSON string
interface class json_string_encodable extends json_value_encodable;
  // Get native value of string
  pure virtual function string get_value();
endclass : json_string_encodable
