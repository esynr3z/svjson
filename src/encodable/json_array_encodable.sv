// Interface for a class that can be encoded as JSON array
interface class json_array_encodable extends json_value_encodable;
  typedef json_value_encodable values_t[$];

  // Get queue with values of this JSON array
  pure virtual function values_t get_values();
endclass : json_array_encodable
