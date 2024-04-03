// Interface for a class that can be encoded as JSON number (real)
interface class json_real_encodable extends json_value_encodable;
  // Get native value of real
  pure virtual function real get_value();
endclass : json_real_encodable
