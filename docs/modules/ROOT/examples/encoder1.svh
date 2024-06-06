json_object jobject;
json_error jerror;
json_result#(string) dump_res;
string data;

jobject = json_object::from('{"the_answer": json_int::from(42)});

// Try to dump file and get `json_result`,
// which can be either `json_error` or dumped `string`.
dump_res = json_encoder::dump_file(jobject, "answer.json");

// Use "pattern matching" to get value and handle errors
case (1)
  dump_res.matches_ok(data): begin
    //Dumped data is:
    //{"the_answer":42}
    $display("Dumped data is:\n%s", data);
  end

  dump_res.matches_err_eq(json_error::FILE_NOT_OPENED, jerror): begin
    $display("Something wrong with a file!");
  end

  dump_res.matches_err(jerror): begin
    $fatal(jerror.to_string());
  end
endcase