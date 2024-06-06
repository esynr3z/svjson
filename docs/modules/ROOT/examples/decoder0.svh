string data =
    "{\"recipeName\":\"Vegetarian Pizza\",\"servings\":4,\"isVegan\":true}";

json_object jobject;
string recipe_name;

// Try to load string and get `json_result`, which can be either `json_error`
// or `json_value`. First unwrap() is required to get `json_value` from
// load result and avoid error handling. Second unwrap() is implicit and required
// to avoid error handling of possible unsuccessfull cast to `json_object`.
jobject = json_decoder::load_string(data).unwrap().into_object();

// Try to get a string for recipe name.
// unwrap() here is implicit to avoid error handling of possible unsuccessfull
// cast to `json_string`.
recipe_name = jobject.get("recipeName").into_string().get();

$display("Recipe name is %s", recipe_name);