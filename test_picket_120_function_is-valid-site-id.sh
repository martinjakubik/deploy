#!/bin/bash

run_count=0
success_count=0
fail_count=0

test_case="no arguments"
echo case $test_case
input=""
expected="usage: ./picket-function-is-valid-site-id.sh -d|--debug"
actual=$(./picket-function-is-valid-site-id.sh $input 2>&1)
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

test_case="valid site id"
echo case $test_case
input="abcd"
expected="1"
actual=$(./picket-function-is-valid-site-id.sh $input 2>&1)
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

test_case="valid site id: maximum length"
echo case $test_case
input="124566789x123456789x123456789"
expected="1"
actual=$(./picket-function-is-valid-site-id.sh $input 2>&1)
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

test_case="invalid site id: is 1-space blank"
echo case $test_case
input_with_blank=' '
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
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

test_case="invalid site id: is 3-space blank"
echo case $test_case
input_with_blank='   '
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
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

test_case="invalid site id: starts with blank"
echo case $test_case
input_with_blank=" a"
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
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

test_case="invalid site id: ends with blank"
echo case $test_case
input_with_blank="a "
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
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

test_case="invalid site id: has blank"
echo case $test_case
input_with_blank="a a"
expected="0"
actual=$(./picket-function-is-valid-site-id.sh "$input_with_blank" 2>&1)
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

test_case="invalid site id: too long"
echo case $test_case
input="123456789x123456789x123456789x"
expected="0"
actual=$(./picket-function-is-valid-site-id.sh $input 2>&1)
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
