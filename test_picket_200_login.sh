#!/bin/bash

saved_picket_path_to_configuration_file="${picket_path_to_configuration_file}"
export picket_path_to_configuration_file=./testing-config.0.picket

run_count=0
success_count=0
fail_count=0

test_case="no arguments"
./setup_test_case.sh "$test_case"
input=""
expected="usage: ./picket-login.sh --userId userId -d|--debug"
actual=$(./picket-login.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="valid username"
./setup_test_case.sh "$test_case"
input="--userId your_name"
expected="[ Logging in. ]"
actual=$(./picket-login.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="invalid username: plus character"
./setup_test_case.sh "$test_case"
input="--userId +"
expected="The user name is invalid. Use only letters without accents, arabic digits and start with a letter."
actual=$(./picket-login.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

echo "number of tests:  " $run_count
echo "succeeded:        " $success_count
echo "failed:           " $fail_count

picket_path_to_configuration_file="${saved_picket_path_to_configuration_file}"
