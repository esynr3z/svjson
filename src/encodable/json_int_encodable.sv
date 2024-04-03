// Interface for a class that can be encoded as JSON number (integer)
interface class json_int_encodable extends json_value_encodable;
  // Get native value of int
  pure virtual function longint get_value();
endclass : json_int_encodable
