#!/bin/bash

test_case="$1"
echo case "$test_case"

command_stage__no_arguments__user_file_too_big() {
    echo -n > ~/.picket/user
    for (( i=0 ; i < 128 ; i=i+1 )) ; do
        echo -n 0 >> ~/.picket/user
    done
}

command_logout__no_arguments__no_user_logged_in() {
    echo -n > ~/.picket/user
}

case "$test_case" in
    ("command stage, valid site argument; user file too big") command_stage__no_arguments__user_file_too_big;;
    ("command logout, no arguments; no user logged in") command_logout__no_arguments__no_user_logged_in;;
esac

exit 0
