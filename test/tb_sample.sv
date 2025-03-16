// tb_decoder.sv
`include "test_utils.svh"
module tb_sample ();
    initial begin
        `TEST_START("sample.log");
        #1;
        `ENABLE_FATAL();
        `ENABLE_IMMIDIATE_EXIT();

        `TEST_EXPECTED(1, 1, "1 == 1");
        `TEST_UNEXPECTED(1, 2, "1 == 2");

        `TEST_SECTION_START("section1");
        `TEST_EXPECTED(1, 1, "1 == 1");
        `TEST_UNEXPECTED(1, 2, "1 == 2");
        `TEST_SECTION_END();

        `TEST_RESULT();
        $finish;
    end
endmodule
