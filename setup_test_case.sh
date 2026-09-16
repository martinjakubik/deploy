#!/bin/bash

test_case="$1"
echo case "$test_case"

command_stage__no_arguments__user_file_too_big() {
    echo -n > ~/.picket/user
    for (( i=0 ; i < 128 ; i=i+1 )) ; do
        echo -n 0 >> ~/.picket/user
    done
}

case "$test_case" in
    ("command stage, valid site argument; user file too big") command_stage__no_arguments__user_file_too_big;
esac

exit 0
