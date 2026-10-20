#!/bin/bash

saved_picket_path_to_configuration_file="${picket_path_to_configuration_file}"
export picket_path_to_configuration_file=./testing-config.0.picket

run_count=0
success_count=0
fail_count=0

test_case="no arguments"
./setup_test_case.sh "$test_case"
input=""
expected="usage: ./picket-function-is-valid-site-id.sh -d|--debug"
actual=$(./picket-function-is-valid-site-id.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="valid site id"
./setup_test_case.sh "$test_case"
input="site0"
expected="1"
actual=$(./picket-function-is-valid-site-id.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="valid site id: maximum length"
./setup_test_case.sh "$test_case"
input="124566789x123456789x123456789"
expected="1"
actual=$(./picket-function-is-valid-site-id.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="invalid site id: is 1-space blank"
./setup_test_case.sh "$test_case"
input_with_blank=' '
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="invalid site id: is 3-space blank"
./setup_test_case.sh "$test_case"
input_with_blank='   '
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="invalid site id: starts with blank"
./setup_test_case.sh "$test_case"
input_with_blank=" a"
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="invalid site id: ends with blank"
./setup_test_case.sh "$test_case"
input_with_blank="a "
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="invalid site id: has blank"
./setup_test_case.sh "$test_case"
input_with_blank="a a"
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="invalid site id: too long"
./setup_test_case.sh "$test_case"
input="123456789x123456789x123456789x"
expected="0"
actual=$(./picket-function-is-valid-site-id.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

echo "number of tests:  " $run_count
echo "succeeded:        " $success_count
echo "failed:           " $fail_count

picket_path_to_configuration_file="${saved_picket_path_to_configuration_file}"
