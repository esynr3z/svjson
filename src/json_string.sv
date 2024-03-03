class json_string extends json_value;
  protected string value;

  function string unwrap();
    return this.value;
  endfunction : unwrap
endclass : json_string