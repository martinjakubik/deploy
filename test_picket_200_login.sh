#!/bin/bash

run_count=0
success_count=0
fail_count=0

test_case="no arguments"
echo case $test_case
input=""
expected="usage: ./picket-login.sh --userId userId -d|--debug"
actual=$(./picket-login.sh $input 2>&1)
run_count=$(( run_count+1 ))
if [[ ! $actual = $expected ]] ; then
    fail_count=$(( fail_count+1 ))
    echo failed
    echo "actual:   " "$actual"
    echo "expected: " "$expected"
    echo
else
    echo succeeded
    success_count=$(( success_count+1 ))
    echo
fi

test_case="valid username"
echo case $test_case
input="--userId your_name"
expected="logging in"
actual=$(./picket-login.sh $input 2>&1)
run_count=$(( run_count+1 ))
if [[ ! $actual = $expected ]] ; then
    fail_count=$(( fail_count+1 ))
    echo failed
    echo "actual:   " "$actual"
    echo "expected: " "$expected"
    echo
else
    echo succeeded
    success_count=$(( success_count+1 ))
    echo
fi

test_case="invalid username: plus character"
echo case $test_case
input="--userId +"
expected="The user name is invalid. Use only letters without accents, arabic digits and start with a letter."
actual=$(./picket-login.sh $input 2>&1)
run_count=$(( run_count+1 ))
if [[ ! $actual = $expected ]] ; then
    fail_count=$(( fail_count+1 ))
    echo failed
    echo "actual:   " "$actual"
    echo "expected: " "$expected"
    echo
else
    echo succeeded
    success_count=$(( success_count+1 ))
    echo
fi

echo "number of tests:  " $run_count
echo "succeeded:        " $success_count
echo "failed:           " $fail_count
