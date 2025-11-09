#!/bin/bash

# Test runner for shuffle.sh
# This script should be in the same directory as shuffle.sh
# To run: ./test_shuffle.sh

# Path to the script to be tested
SHUFFLE_SCRIPT="./shuffle.sh"

# Make sure the script we are testing is executable
if [ ! -f "$SHUFFLE_SCRIPT" ]; then
    echo "Error: shuffle.sh not found in the current directory."
    exit 1
fi
chmod +x "$SHUFFLE_SCRIPT"

# Counters for test results
passed_tests=0
failed_tests=0
total_tests=0

# Function to run a single test case
run_test() {
  ((total_tests++))
  local test_name="$1"
  local input="$2"
  local expected_output="$3"

  # Run the script and capture the output
  actual_output=$($SHUFFLE_SCRIPT "$input")

  # Check if the actual output matches the expected output
  if [ "$actual_output" == "$expected_output" ]; then
    echo "✅ PASS: $test_name"
    ((passed_tests++))
  else
    echo "❌ FAIL: $test_name"
    echo "     Input:    '$input'"
    echo "     Expected: '$expected_output'"
    echo "     Actual:   '$actual_output'"
    ((failed_tests++))
  fi
}

# --- Test Cases ---

echo "Running tests for shuffle.sh..."
echo "---------------------------------"

# Test 1: No arguments
((total_tests++))
output=$($SHUFFLE_SCRIPT 2>&1) # Capture stdout and stderr
exit_code=$?
expected_usage="Usage: $0 <string>"
if [[ "$output" == "$expected_usage" ]] && [ $exit_code -eq 1 ]; then
    echo "✅ PASS: No arguments provided"
    ((passed_tests++))
else
    echo "❌ FAIL: No arguments provided"
    echo "     Expected exit code: 1, Got: $exit_code"
    echo "     Expected output: '$expected_usage', Got: '$output'"
    ((failed_tests++))
fi

# Test 2: Empty string
run_test "Empty string" "" ""

# Test 3: Simple lowercase string
run_test "Simple lowercase" "abc" "bcd"

# Test 4: Simple uppercase string
run_test "Simple uppercase" "ABC" "BCD"

# Test 5: Lowercase with wrap-around
run_test "Lowercase wrap-around" "xyz" "yza"

# Test 6: Uppercase with wrap-around
run_test "Uppercase wrap-around" "XYZ" "YZA"

# Test 7: Mixed case string
run_test "Mixed case" "aBcDe" "bCdEf"

# Test 8: String with numbers and symbols
run_test "String with numbers and symbols" "Hello-123!" "Ifmmp-123!"

# Test 9: String with spaces
run_test "String with spaces" "Hello World" "Ifmmp Xpsme"

# Test 10: String with various special characters
run_test "String with various special characters" "`!@#$%^&*()_+-=[]{};':,./<>?~" "`!@#$%^&*()_+-=[]{};':,./<>?~"

# --- Test Summary ---

echo "---------------------------------"
echo "Test Summary:"
echo "Total tests: $total_tests"
echo "Passed: $passed_tests"
echo "Failed: $failed_tests"
echo "---------------------------------"

if [ "$failed_tests" -ne 0 ]; then
  exit 1
fi

exit 0
