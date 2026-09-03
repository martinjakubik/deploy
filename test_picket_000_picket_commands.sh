#!/bin/bash

run_count=0
success_count=0
fail_count=0

test_case="no arguments"
echo case $test_case
input=""
expected="usage: ./picket.sh deploy | undeploy | stage | unstage | create-site | delete-site | list-sites | help | -s|--siteId siteId | -u|--userId userId --ip ipAddress -c|--incremental -d|--debug --help"
actual=$(./picket.sh "$input" 2>&1)
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

test_case="command deploy, no arguments"
echo case $test_case
input="deploy"
expected="You did not select a site. Use ''picket deploy --siteId wxyz'' to choose a site to deploy."
actual=$(./picket.sh "$input" 2>&1)
run_count=$(( run_count+1 ))
if [[ ! "$actual" = "$expected" ]] ; then
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

test_case="command deploy, user not logged in, valid site argument"
echo case $test_case
input="deploy --siteId wxyz"
expected="You did not provide a user ID. Use ''picket deploy --siteId ... --userId your_name --ip 192.0.2.0'', or type ''picket login your_name'' to log in permanently."
actual=$(./picket.sh "$input" 2>&1)
run_count=$(( run_count+1 ))
if [[ ! "$actual" = "$expected" ]] ; then
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

test_case="command deploy, user logged in, valid site argument but site does not exist"
echo case $test_case
input="deploy --siteId wxyz --userId your_name --ip 192.0.2.0"
expected="Trying to deploy site ''wxyz''. Site does not exist. Stopping."
actual=$(./picket.sh "$input" 2>&1)
run_count=$(( run_count+1 ))
if [[ ! "$actual" = "$expected" ]] ; then
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

test_case="command undeploy, no arguments"
echo case $test_case
input="undeploy"
expected="You did not select a site. Use ''picket undeploy --siteId wxyz'' to choose a site to undeploy."
actual=$(./picket.sh "$input" 2>&1)
run_count=$(( run_count+1 ))
if [[ ! "$actual" = "$expected" ]] ; then
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

test_case="incorrect command"
echo case $test_case
input="think"
expected="usage: ./picket.sh deploy | undeploy | stage | unstage | create-site | delete-site | list-sites | help | -s|--siteId siteId | -u|--userId userId --ip ipAddress -c|--incremental -d|--debug --help"
actual=$(./picket.sh "$input" 2>&1)
run_count=$(( run_count+1 ))
if [[ ! "$actual" = "$expected" ]] ; then
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
