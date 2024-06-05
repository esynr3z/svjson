// Content of example.json:
// {
//     "recipeName": "Vegetarian Pizza",
//     "servings": 4,
//     "isVegan": true
// }

json_error jerror;
json_value jvalue;

// Try to load file and get `json_result`, which can be either `json_error` or `json_value`.
json_result#(json_value) load_res = json_decoder::load_file("example.json");

// Use "pattern matching" to get value
case (1)
  load_res.matches_err(jerror): $fatal(jerror.to_string());

  load_res.matches_ok(jvalue): begin
    json_object jobject;
    json_result#(json_object) cast_res = jvalue.as_json_object();

    // Traditional if..else can be used as well
    if (cast_res.matches_err(jerror)) begin
      $fatal(jerror.to_string());
    end else if (cast_res.matches_ok(jobject)) begin
      $display("Keys of an object: %p", jobject.get_keys());
    end
  end
endcase