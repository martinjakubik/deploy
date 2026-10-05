#!/bin/bash

# runs all test files and aggregates results

# initializes counters
total_tests=0
total_success=0
total_failures=0

# array of test files to run
test_files=(
  "test_picket_000_picket_commands.sh"
  "test_picket_110_function_is-ipv6.sh"
  "test_picket_120_function_is-valid-site-id.sh"
  "test_picket_200_login.sh"
  "test_picket_210_logout.sh"
)

# runs each test file
for test_file in "${test_files[@]}"; do
  echo "Running $test_file..."
  echo "----------------------------------------"
  # runs the test file and captures the output
  output=$(./$test_file 2>&1)
  echo "$output"
  echo "----------------------------------------"
  echo

  # extracts success and failure counts from the output
  # The format is: "number of tests: X succeeded: Y failed: Z"
  # uses grep to extract these values
  success_count=$(echo "$output" | grep -o "succeeded: *[0-9]*" | grep -o "[0-9]*")
  failure_count=$(echo "$output" | grep -o "failed: *[0-9]*" | grep -o "[0-9]*")
  test_count=$(echo "$output" | grep -o "number of tests: *[0-9]*" | grep -o "[0-9]*")

  # accumulates totals
  total_tests=$((total_tests + test_count))
  total_success=$((total_success + success_count))
  total_failures=$((total_failures + failure_count))
done

# prints aggregated results
echo "========================================"
echo "AGGREGATED RESULTS"
echo "========================================"
echo "Total tests run:    $total_tests"
echo "Total succeeded:    $total_success"
echo "Total failed:       $total_failures"
echo "========================================"

# exits with non-zero status if any failures
if [ $total_failures -gt 0 ] ; then
  exit 1
fi
