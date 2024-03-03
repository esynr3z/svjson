class json_object extends json_value;
  protected json_value values[string];

  static function json_object create(json_value values[string]);
  endfunction
endclass : json_object
