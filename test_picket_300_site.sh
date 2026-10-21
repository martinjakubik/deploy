#!/bin/bash

saved_picket_path_to_configuration_file="${picket_path_to_configuration_file}"
export picket_path_to_configuration_file=./testing-config.0.picket

run_count=0
success_count=0
fail_count=0

test_case="list sites, empty"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="[ Listing sites. ]"$'\n\n'"[ ... 0 sites found. ]"
actual=$(./picket-list-sites.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="list sites, one site"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="[ Listing sites. ]"$'\n\n'"000. site0"$'\n\n'"[ ... 1 site found. ]"
actual=$(./picket-list-sites.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

test_case="list sites, two sites"
./test_picket_setup_test_case.sh "$test_case"
input=""
expected="[ Listing sites. ]"$'\n\n'"000. site0"$'\n'"001. site1"$'\n\n'"[ ... 2 sites found. ]"
actual=$(./picket-list-sites.sh $input 2>&1)
./test_picket_cleanup_test_case.sh "$test_case"
source ./test_picket_update_reports.sh

echo "number of tests:  " $run_count
echo "succeeded:        " $success_count
echo "failed:           " $fail_count

picket_path_to_configuration_file="${saved_picket_path_to_configuration_file}"
