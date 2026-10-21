#!/bin/bash

saved_picket_path_to_configuration_file="${picket_path_to_configuration_file}"
export picket_path_to_configuration_file=./testing-config.0.picket

run_count=0
success_count=0
fail_count=0

test_case="no arguments"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="usage: ./picket-function-is-ipv6.sh --ip ipAddress -d|--debug"
actual=$(./picket-function-is-ipv6.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="well-formed ip v4"
./test_picket_setup_test_case.sh "$test_case"
input="--ip 192.0.0.1"
expected="0"
actual=$(./picket-function-is-ipv6.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="well-formed ip v6"
./test_picket_setup_test_case.sh "$test_case"
input="--ip 1111:2222:aaaa::1111:1"
expected="1"
actual=$(./picket-function-is-ipv6.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="ill-formed address"
./test_picket_setup_test_case.sh "$test_case"
input="--ip Q"
expected="0"
actual=$(./picket-function-is-ipv6.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

echo "number of tests:  " $run_count
echo "succeeded:        " $success_count
echo "failed:           " $fail_count

picket_path_to_configuration_file="${saved_picket_path_to_configuration_file}"
