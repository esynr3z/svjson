string data = "{\"recipeName\":\"Vegetarian Pizza\",\"servings\":4,\"isVegan\":true}";

// Try to load string and get `json_result`, which can be either `json_error` or `json_value`.
// First unwrap is required to get `json_value` from load result and avoid error handling.
// Second unwrap is required to avoid error handling of possible unsuccessfull cast to `json_object`.
json_object jobject = json_decoder::load_string(data).unwrap().as_json_object().unwrap();

// Try to get a string for recipe name.
// Unwrap is here to avoid error handling of possible unsuccessfull cast to `json_string`.
string recipe_name = jobject.get("recipeName").as_json_string().unwrap().get();
$display("Recipe name is %s", recipe_name);