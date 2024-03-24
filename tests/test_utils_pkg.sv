package test_utils_pkg;
  import json_pkg::*;

  // Checker that expected JSON string parsing finishes with OK status.
  // It also compares parsed value with the golden one, if the latest is provided.
  // Returns error message if something is wrong.
  function automatic string expect_ok_load_str(string raw, json_value golden);
    json_error err;
    json_value val;
    json_result parsed = json_decoder::load_string(raw);

    case (1)
      parsed.matches_err(err): begin
        return err.to_string();
      end
      parsed.matches_ok(val): begin
        if (val.compare(golden) || (golden == null)) begin
          return "";
        end else begin
          return "Loaded JSON value do not match the golden one!";
        end
      end
    endcase
  endfunction : expect_ok_load_str
endpackage : test_utils_pkg
