#!/bin/bash

saved_picket_path_to_configuration_file="${picket_path_to_configuration_file}"
export picket_path_to_configuration_file=./testing-config.0.picket

run_count=0
success_count=0
fail_count=0

test_case="get app project root from ID"
./test_picket_setup_test_case.sh "$test_case"
input="app0"
expected="app0"
actual=$(./picket-function-get-app-project-root-from-id.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="get app project root from ID, invalid app ID"
./test_picket_setup_test_case.sh "$test_case"
input="invalid_app"
expected="App does not exist. Stopping."
actual=$(./picket-function-get-app-project-root-from-id.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="create app no arguments"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="App ID cannot be empty. Exiting."$'\n'"usage: ./picket-create-app.sh -a|--appId appId [--path path] -d|--debug"
actual=$(./picket-create-app.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="add app no arguments"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="App ID cannot be empty. Exiting."$'\n'"usage: ./picket-add-app.sh -a|--appId appId -s|--siteId siteId [-d|--debug]"
actual=$(./picket-add-app.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="delete unused app"
./test_picket_setup_test_case.sh "$test_case"
input="--appId app0 --force"
expected="[ App \"app0\" deleted. ]"
actual=$(./picket-delete-app.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="delete unused app, no database set up"
./test_picket_setup_test_case.sh "$test_case"
input="--appId app0"
expected="App does not exist. Stopping."
actual=$(./picket-delete-app.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="list apps, empty"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="[ Listing apps. ]"$'\n\n'"[ ... 0 apps found. ]"
actual=$(./picket-list-apps.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="list apps, one app"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="[ Listing apps. ]"$'\n\n'"000. app0"$'\n\n'"[ ... 1 app found. ]"
actual=$(./picket-list-apps.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="list apps, two apps"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="[ Listing apps. ]"$'\n\n'"000. app0"$'\n'"001. app1"$'\n\n'"[ ... 2 apps found. ]"
actual=$(./picket-list-apps.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="list apps, one app for site"
./test_picket_setup_test_case.sh "$test_case"
input="--siteId site0"
expected="[ Listing apps for site \"site0\". ]"$'\n\n'"000. app0"$'\n\n'"[ ... 1 app found. ]"
actual=$(./picket-list-apps.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

echo "number of tests:  " $run_count
echo "succeeded:        " $success_count
echo "failed:           " $fail_count

picket_path_to_configuration_file="${saved_picket_path_to_configuration_file}"
