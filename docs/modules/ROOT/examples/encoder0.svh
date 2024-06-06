json_object jobject;
string data;

jobject = json_object::from(
  '{
    "recipeName": json_string::from("Meatballs"),
    "servings": json_int::from(8),
    "isVegan": json_bool::from(0)
  }
);

// Try to dump to string in the most compact way and get `json_result`,
// which can be either `json_error` or `string`.
// Here unwrap() is required to get `string` and avoid error handling.
// Displays:
//{"isVegan":false,"recipeName":"Meatballs","servings":8}
data = json_encoder::dump_string(jobject).unwrap();
$display(data);

// Try to dump using 2 spaces for indentation
// Displays:
//{
//  "isVegan": false,
//  "recipeName": "Meatballs",
//  "servings": 8
//}
data = json_encoder::dump_string(jobject, .indent_spaces(2)).unwrap();
$display(data);