`ifndef TEST_UTILS_IMPL_SVH
`define TEST_UTILS_IMPL_SVH

`include "color.svh"

int __failed_count = 0;
int __number_of_test = 0;
string __test_section_name = "";
int __test_section_valid = 0;
int __enable_fatal = 0;
int __enable_immidiate_exit = 0;

string __test_log_path = "";
int __fd = 0;

task automatic __initialize_test();
    __failed_count = 0;
    __number_of_test = 0;
    __test_section_name = "";
    __test_section_valid = 0;
    __enable_fatal = 0;
    __enable_immidiate_exit = 0;

    if (__test_log_path != "") begin
        $fclose(__fd);
    end
    __test_log_path = "";
    __fd = 0;
endtask

task automatic __test_start(string test_log_path);
    __initialize_test();

    __test_log_path = test_log_path;
    __fd = $fopen(__test_log_path, "w");
    `GREEN_COLOR
    $display("Test Start: %0s", __test_log_path);
    `RESET_COLOR
endtask

task automatic __test_result();
    if (__failed_count > 0) begin
        `RED_COLOR
        $display("Test Failed: passed = %0d, failed = %0d", __number_of_test - __failed_count,
                 __failed_count);
        $fwrite(__fd, "Test Failed: passed = %0d, failed = %0d\n",
                __number_of_test - __failed_count, __failed_count);
        __pre_exit();
        __fatal_exit();
    end else begin
        `GREEN_COLOR
        $display("Test Passed");
        $fwrite(__fd, "Test Passed\n");
        __pre_exit();
        __exit();
    end
endtask

task automatic __exit();
    $finish(0);
    $c("std::exit(0);");
endtask

task automatic __pre_exit();
    `RESET_COLOR
    $fclose(__fd);
endtask

task automatic __fatal_exit();
    if (__enable_fatal) begin
        $fatal;
    end else begin
        __exit();
    end
endtask

task automatic __immidiate_exit();
    if (__enable_immidiate_exit) begin
        __test_result();
    end
endtask

`define TEST_SECTION_START_IMPL(section_name) \
    __test_section_name = section_name; \
    __test_section_valid = 1; \

`define TEST_SECTION_END_IMPL() \
    __test_section_valid = 0; \

`define ENABLE_FATAL_IMPL() \
    __enable_fatal = 1;

`define DISABLE_FATAL_IMPL() \
    __enable_fatal = 0;

`define ENABLE_IMMIDIATE_EXIT_IMPL() \
    __enable_immidiate_exit = 1;

`define DISABLE_IMMIDIATE_EXIT_IMPL() \
    __enable_immidiate_exit = 0;


`define TEST_START_IMPL(test_log_path) \
    __test_start(test_log_path);

// using macro because of unexpected type is not fixed but cannot use variadic
// type in task
`define TEST_EXPECTED_IMPL(expected, actual, message, file = `__FILE__, line = `__LINE__) \
    __number_of_test++; \
    if (expected != actual) begin \
        __failed_count++; \
        `RED_COLOR \
        if (__test_section_valid) begin \
            $display(     "[%s] Error: %s, expected = %0h, actual = %0h(file:%0s line:%0d)", \
                __test_section_name, message, expected, actual, file, line); \
            $fwrite(__fd, "[%s] Error: %s, expected = %0h, actual = %0h(file:%0s line:%0d)\n", \
                __test_section_name, message, expected, actual, file, line); \
        end else begin \
            $display(     "Error: %s, expected = %0h, actual = %0h(file:%0s line:%0d)", \
                message, expected, actual, file, line); \
            $fwrite(__fd, "Error: %s, expected = %0h, actual = %0h(file:%0s line:%0d)\n", \
                message, expected, actual, file, line); \
        end \
        `RESET_COLOR \
        __immidiate_exit(); \
    end

// using macro because of unexpected type is not fixed but cannot use variadic
// type in task
`define TEST_UNEXPECTED_IMPL(unexpected, actual, message, file = `__FILE__, line = `__LINE__) \
    __number_of_test++; \
    if (unexpected == actual) begin \
        __failed_count++; \
        `RED_COLOR \
        if (__test_section_valid) begin \
            $display(     "[%s] Error: %s, unexpected = %0d, actual = %0d(file:%0s line:%0d)", \
                __test_section_name, message, unexpected, actual, file, line); \
            $fwrite(__fd, "[%s] Error: %s, unexpected = %0d, actual = %0d(file:%0s line:%0d)\n", \
                __test_section_name, message, unexpected, actual, file, line); \
        end else begin \
            $display(     "Error: %s, unexpected = %0d, actual = %0d(file:%0s line:%0d)", \
                message, unexpected, actual, file, line); \
            $fwrite(__fd, "Error: %s, unexpected = %0d, actual = %0d(file:%0s line:%0d)\n", \
                message, unexpected, actual, file, line); \
        end \
        `RESET_COLOR \
        __immidiate_exit(); \
    end


`define TEST_RESULT_IMPL() \
    __test_result();

`endif
