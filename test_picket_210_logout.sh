#!/bin/bash

saved_picket_path_to_configuration_file="${picket_path_to_configuration_file}"
export picket_path_to_configuration_file=./testing-config.0.picket

run_count=0
success_count=0
fail_count=0

test_case="no arguments"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="[ Logging out. ]"
actual=$(./picket-logout.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

echo "number of tests:  " $run_count
echo "succeeded:        " $success_count
echo "failed:           " $fail_count

picket_path_to_configuration_file="${saved_picket_path_to_configuration_file}"
