`include "svunit_defines.svh"
`include "test_utils_macros.svh"

// Basic tests of `json_decoder` is used to parse JSON
module json_load_basic_unit_test;
  import svunit_pkg::svunit_testcase;
  import json_pkg::*;

  string name = "json_load_basic_ut";
  svunit_testcase svunit_ut;

  function void build();
    svunit_ut = new(name);
  endfunction

  task setup();
    svunit_ut.setup();
  endtask

  task teardown();
    svunit_ut.teardown();
  endtask

  `SVUNIT_TESTS_BEGIN


  `SVTEST(null_test)
  begin
    `EXPECT_OK_LOAD_STR("null", json_null::create())
    `EXPECT_OK_LOAD_STR(" null ", json_null::create())
    `EXPECT_OK_LOAD_STR(" \nnull\n \t ", json_null::create())
  end
  `SVTEST_END


  `SVTEST(bool_test)
  begin
    `EXPECT_OK_LOAD_STR("true", json_bool::from(1))
    `EXPECT_OK_LOAD_STR("false", json_bool::from(0))
    `EXPECT_OK_LOAD_STR(" true ", json_bool::from(1))
    `EXPECT_OK_LOAD_STR(" false ", json_bool::from(0))
    `EXPECT_OK_LOAD_STR(" \n\n\t true\n \n ", json_bool::from(1))
    `EXPECT_OK_LOAD_STR(" \n false\n    \t", json_bool::from(0))
  end
  `SVTEST_END


  `SVTEST(int_test)
  begin
    `EXPECT_OK_LOAD_STR("42", json_int::from(42))
    `EXPECT_OK_LOAD_STR("0", json_int::from(0))
    `EXPECT_OK_LOAD_STR("-1", json_int::from(-1))
    `EXPECT_OK_LOAD_STR("137438953472", json_int::from(64'd137438953472))
    `EXPECT_OK_LOAD_STR("-213787953472", json_int::from(-64'd213787953472))
    `EXPECT_OK_LOAD_STR(" 123213 ", json_int::from(123213))
    `EXPECT_OK_LOAD_STR(" \n-123213\n\n\t   ", json_int::from(-123213))
  end
  `SVTEST_END


  `SVTEST(real_test)
  begin
    `EXPECT_OK_LOAD_STR("3.14", json_real::from(3.14))
    `EXPECT_OK_LOAD_STR("0.02132", json_real::from(0.02132))
    `EXPECT_OK_LOAD_STR("-0.6", json_real::from(-0.6))
    `EXPECT_OK_LOAD_STR("-10002.32", json_real::from(-10002.32))
    `EXPECT_OK_LOAD_STR("28.8299", json_real::from(28.8299))
    `EXPECT_OK_LOAD_STR("42e3", json_real::from(42e3))
    `EXPECT_OK_LOAD_STR("15e-6", json_real::from(15e-6))
    `EXPECT_OK_LOAD_STR("0.3E3", json_real::from(0.3E3))
    `EXPECT_OK_LOAD_STR("-0.001E-4", json_real::from(-0.001E-4))
    `EXPECT_OK_LOAD_STR(" 0.1234 ", json_real::from(0.1234))
    `EXPECT_OK_LOAD_STR(" \n\t\r-10.875\n \n ", json_real::from(-10.875))
  end
  `SVTEST_END


   `SVTEST(string_test)
  begin
    `EXPECT_OK_LOAD_STR("\"\"", json_string::from(""))
    `EXPECT_OK_LOAD_STR("\" \"", json_string::from(" "))
    `EXPECT_OK_LOAD_STR("\"\n\"", json_string::from("\n"))
    `EXPECT_OK_LOAD_STR("\"a\"", json_string::from("a"))
    `EXPECT_OK_LOAD_STR("\"abc [klm] {xyz}\"", json_string::from("abc [klm] {xyz}"))
    `EXPECT_OK_LOAD_STR("\"true, false, null\"", json_string::from("true, false, null"))
    `EXPECT_OK_LOAD_STR("\"1234abcABC!@#$^&*\"", json_string::from("1234abcABC!@#$^&*"))
    `EXPECT_OK_LOAD_STR(" \n\n\t \"hello\"\n \n ", json_string::from("hello"))
  end
  `SVTEST_END


  `SVTEST(empty_object_test)
  begin
    json_object golden = json_object::from('{});
    `EXPECT_OK_LOAD_STR("{}", golden)
    `EXPECT_OK_LOAD_STR("{ }", golden)
    `EXPECT_OK_LOAD_STR("{\n}", golden)
    `EXPECT_OK_LOAD_STR("{\t}", golden)
    `EXPECT_OK_LOAD_STR("{ \n \n \n   }", golden)
    `EXPECT_OK_LOAD_STR(" {}   \n\n", golden)
    `EXPECT_OK_LOAD_STR("\n\n{\n}\n\n", golden)
    `EXPECT_OK_LOAD_STR("\n\r{  }  \n", golden)
  end
  `SVTEST_END


  `SVTEST(simple_object_test)
  begin
    json_object golden = json_object::from('{"the_answer": json_int::from(42)});
    `EXPECT_OK_LOAD_STR("{\"the_answer\":42}", golden)
    `EXPECT_OK_LOAD_STR(" {\n  \"the_answer\": 42\n}\n\n ", golden)
    `EXPECT_OK_LOAD_STR(" {\n  \"the_answer\": 42   \n}  \n\n ", golden)
    `EXPECT_OK_LOAD_STR(" {\n  \"the_answer\"  :   \t\n42\n}\n\n ", golden)
    `EXPECT_OK_LOAD_STR("\n{\n\"the_answer\"\n:\n42\n}\n", golden)
  end
  `SVTEST_END


//  `SVTEST(normal_object_test)
//  begin
//    json_object golden = json_object::from('{
//      "jint": json_int::from(42),
//      "jreal": json_real::from(3.14),
//      "jstring": json_string::from("XyZ"),
//      "jbool": json_bool::from(1),
//      "jnull": null
//    });
//    `EXPECT_OK_LOAD_STR("{\"jint\":42,\"jreal\":3.14,\"jstring\":\"XyZ\",\"jbool\":true,\"jnull\":null}", golden)
//    `EXPECT_OK_LOAD_STR(
//      "{\"jint\":42\n, \"jreal\" : 3.14\t, \"jstring\" :  \"XyZ\"\n,\n  \"jbool\" :true,   \"jnull\":   null}",
//      golden
//    )
//  end
//  `SVTEST_END


//  `SVTEST(nested_object_test)
//  begin
//    json_object golden = json_object::from('{
//      "jbool": json_bool::from(1),
//      "jobj1": json_object::from('{
//        "jobj2": json_object::from('{}),
//        "jnull": null
//      })
//    });
//    `EXPECT_OK_LOAD_STR("{\"jbool\":true,\"jobj1\":{\"jobj2\":{},\"jnull\":null}}", golden)
//    `EXPECT_OK_LOAD_STR("{\"jbool\":true , \"jobj1\" :\n{\n  \"jobj2\" : {   }\n , \"jnull\" : null}}", golden)
//  end
//  `SVTEST_END


  `SVTEST(empty_array_test)
  begin
    json_array golden = json_array::from('{});
    `EXPECT_OK_LOAD_STR("[]", golden)
    `EXPECT_OK_LOAD_STR("[ ]", golden)
    `EXPECT_OK_LOAD_STR("[\n]", golden)
    `EXPECT_OK_LOAD_STR("[\t]", golden)
    `EXPECT_OK_LOAD_STR("[ \n \n \n   ]", golden)
    `EXPECT_OK_LOAD_STR(" []   \n\n", golden)
    `EXPECT_OK_LOAD_STR("\n\n[\n]\n\n", golden)
    `EXPECT_OK_LOAD_STR("\n\r[  ]  \n", golden)
  end
  `SVTEST_END


  `SVTEST(simple_array_test)
  begin
    json_array golden = json_array::from('{json_int::from(777)});
    `EXPECT_OK_LOAD_STR("[777]", golden)
    `EXPECT_OK_LOAD_STR(" [  777 ] ", golden)
    `EXPECT_OK_LOAD_STR(" \n[  777 ]\n  ", golden)
    `EXPECT_OK_LOAD_STR("\n[\n777\n]\n", golden)
  end
  `SVTEST_END


//  `SVTEST(normal_array_test)
//  begin
//    json_array golden = json_array::from('{
//      json_int::from(42),
//      json_real::from(3.14),
//      json_string::from("XyZ"),
//      json_bool::from(1),
//      null
//    });
//    `EXPECT_OK_LOAD_STR("[42,3.14,\"XyZ\",true,null]", golden)
//    `EXPECT_OK_LOAD_STR(" [ 42 , 3.14 , \"XyZ\" , true , null ] ", golden)
//    `EXPECT_OK_LOAD_STR("\n[\n42,\n3.14,\n\"XyZ\",\ntrue,\nnull\n]\n", golden)
//  end
//  `SVTEST_END


//  `SVTEST(nested_array_test)
//  begin
//    json_array golden = json_array::from('{
//      json_bool::from(0),
//      json_array::from('{
//        null,
//        json_array::from('{})
//      })
//    });
//    `EXPECT_OK_LOAD_STR("[false,[null,[]]]", golden)
//    `EXPECT_OK_LOAD_STR(" [ false , [  null ,  [  ] ]  ]", golden)
//    `EXPECT_OK_LOAD_STR("\r [ false\n, [\t null,\n  [\n\n] \r] \n]\n\n", golden)
//  end
//  `SVTEST_END


//  `SVTEST(mixed_test)
//  begin
//    `EXPECT_OK_LOAD_STR(
//      "[[1, 2, 3], { \"key\": \"value\" }]",
//      json_array::from('{
//        json_array::from('{
//          json_int::from(1),
//          json_int::from(2),
//          json_int::from(3)
//        }),
//        json_object::from('{
//          "key": json_string::from("value")
//        })
//      })
//    )
//
//    `EXPECT_OK_LOAD_STR(
//      "{\"arr\":[null, true], \"obj\": { \"key\": \"value\" }]",
//      json_array::from('{
//        "arr": json_array::from('{
//          null,
//          json_bool::from(1)
//        }),
//        "obj": json_object::from('{
//          "key": json_string::from("value")
//        })
//      })
//    )
//  end
//  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule : json_load_basic_unit_test
