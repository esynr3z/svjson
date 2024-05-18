// Interface for a class that can be encoded as JSON number (integer)
interface class json_int_encodable extends json_value_encodable;
  // Get value encodable as JSON integer number
  pure virtual function longint to_json_encodable();
endclass : json_int_encodable
