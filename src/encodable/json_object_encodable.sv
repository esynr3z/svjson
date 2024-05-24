// Interface for a class that can be encoded as JSON object
interface class json_object_encodable extends json_value_encodable;
  typedef json_value_encodable values_t[string];

  // Get value encodable as JSON object
  pure virtual function values_t to_json_encodable();
endclass : json_object_encodable
