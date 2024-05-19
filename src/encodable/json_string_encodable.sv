// Interface for a class that can be encoded as JSON string
interface class json_string_encodable extends json_value_encodable;
  // Get value encodable as JSON string
  pure virtual function string to_json_encodable();
endclass : json_string_encodable
