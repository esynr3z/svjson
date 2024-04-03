// Interface for a class that can be encoded as JSON bool
interface class json_bool_encodable extends json_value_encodable;
  // Get native value of bit
  pure virtual function bit get_value();
endclass : json_bool_encodable
