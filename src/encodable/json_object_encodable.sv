// Interface for a class that can be encoded as JSON object
interface class json_object_encodable extends json_value_encodable;
  typedef json_value_encodable values_t[string];

  // Get associative array with all key-value pairs of this JSON object
  pure virtual function values_t get_values();
endclass : json_object_encodable
