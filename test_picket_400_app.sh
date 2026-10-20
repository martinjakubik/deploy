#!/bin/bash

saved_picket_path_to_configuration_file="${picket_path_to_configuration_file}"
export picket_path_to_configuration_file=./testing-config.0.picket

run_count=0
success_count=0
fail_count=0

test_case="get app project root from ID"
./setup_test_case.sh "$test_case"
input="app0"
expected="app0"
actual=$(./picket-function-get-app-project-root-from-id.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="get app project root from ID, invalid app ID"
./setup_test_case.sh "$test_case"
input="invalid_app"
expected="App does not exist. Stopping."
actual=$(./picket-function-get-app-project-root-from-id.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="create app no arguments"
./setup_test_case.sh "$test_case"
input=""
expected="App ID cannot be empty. Exiting."$'\n'"usage: ./picket-create-app.sh -a|--appId appId -d|--debug"
actual=$(./picket-create-app.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="add app no arguments"
./setup_test_case.sh "$test_case"
input=""
expected="usage: ./picket-add-app.sh --userId userId --siteId siteId --appId appId -d|--debug"
actual=$(./picket-add-app.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="delete unused app"
./setup_test_case.sh "$test_case"
input="--appId app0"
expected="[ App \"app0\" deleted. ]"
actual=$(./picket-delete-app.sh $input 2>&1)
./cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

echo "number of tests:  " $run_count
echo "succeeded:        " $success_count
echo "failed:           " $fail_count

picket_path_to_configuration_file="${saved_picket_path_to_configuration_file}"
