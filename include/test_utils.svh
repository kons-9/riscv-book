`ifndef TEST_UTILS_SVH
`define TEST_UTILS_SVH

`include "test_utils_impl.svh"

// interface

`define TEST_SECTION_START(section_name) \
    `TEST_SECTION_START_IMPL(section_name)

`define TEST_SECTION_END() \
    `TEST_SECTION_END_IMPL()

`define ENABLE_FATAL() \
    `ENABLE_FATAL_IMPL()

`define DISABLE_FATAL() \
    `DISABLE_FATAL_IMPL()

`define ENABLE_IMMIDIATE_EXIT() \
    `ENABLE_IMMIDIATE_EXIT_IMPL()

`define DISABLE_IMMIDIATE_EXIT() \
    `DISABLE_IMMIDIATE_EXIT_IMPL()

`define TEST_START(test_log_path) \
    `TEST_START_IMPL(test_log_path)

`define TEST_EXPECTED(expected, actual, message, file = `__FILE__, line = `__LINE__) \
    `TEST_EXPECTED_IMPL(expected, actual, message, file, line)

`define TEST_UNEXPECTED(unexpected, actual, message, file = `__FILE__, line = `__LINE__) \
    `TEST_UNEXPECTED_IMPL(unexpected, actual, message, file, line)

`define TEST_RESULT() \
    `TEST_RESULT_IMPL()

`endif

