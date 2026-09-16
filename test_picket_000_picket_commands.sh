#!/bin/bash

run_count=0
success_count=0
fail_count=0

test_case="no arguments"
./setup_test_case.sh "$test_case"
input=""
expected="usage: ./picket.sh <command> | help | -s|--siteId siteId | -u|--userId userId --ip ipAddress -c|--incremental -t|--throttle -d|--debug --help"
actual=$(./picket.sh $input 2>&1)
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

test_case="command login, no arguments"
./setup_test_case.sh "$test_case"
input="login"
expected="You did not provide a user ID. Use ''picket login --userId your_name'' to log in permanently."
actual=$(./picket.sh $input 2>&1)
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

test_case="command logout, no arguments; no user logged in"
./setup_test_case.sh "$test_case"
input="logout"
expected="There is no user logged in."
actual=$(./picket.sh $input 2>&1)
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

test_case="command logout, no arguments; user logged in"
./setup_test_case.sh "$test_case"
input="logout"
expected="Logging out."
actual=$(./picket.sh $input 2>&1)
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

test_case="command deploy, no arguments"
./setup_test_case.sh "$test_case"
input="deploy"
expected="You did not select a site. Use ''picket <command> --siteId wxyz'' to choose a site to work with."
actual=$(./picket.sh $input 2>&1)
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
./setup_test_case.sh "$test_case"
input="deploy --siteId wxyz -d"
expected="You did not provide a user ID. Use ''picket <command> --siteId ... --userId your_name --ip 192.0.2.0'', or type ''picket login your_name'' to log in permanently."
actual=$(./picket.sh $input 2>&1)
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
./setup_test_case.sh "$test_case"
input="deploy --siteId wxyz --userId your_name --ip 192.0.2.0"
expected="Trying to deploy site ''wxyz''. Site does not exist. Stopping."
actual=$(./picket.sh $input 2>&1)
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
./setup_test_case.sh "$test_case"
input="undeploy"
expected="You did not select a site. Use ''picket <command> --siteId wxyz'' to choose a site to work with."
actual=$(./picket.sh $input 2>&1)
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

test_case="command stage, no arguments"
./setup_test_case.sh "$test_case"
input="stage"
expected="You did not select a site. Use ''picket <command> --siteId wxyz'' to choose a site to work with."
actual=$(./picket.sh $input 2>&1)
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

test_case="command stage, valid site argument; user file too big"
./setup_test_case.sh "$test_case"
input="stage --siteId wxyz"
expected="There is a problem with the user record. Use ''picket login --userId your_name'' to log in again."
actual=$(./picket.sh $input 2>&1)
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

test_case="command unstage, no arguments"
./setup_test_case.sh "$test_case"
input="unstage"
expected="You did not select a site. Use ''picket <command> --siteId wxyz'' to choose a site to work with."
actual=$(./picket.sh $input 2>&1)
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

test_case="command delete, no arguments"
./setup_test_case.sh "$test_case"
input="delete"
expected="You did not select a site. Use ''picket <command> --siteId wxyz'' to choose a site to work with."
actual=$(./picket.sh $input 2>&1)
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
./setup_test_case.sh "$test_case"
input="think"
expected="usage: ./picket.sh <command> | help | -s|--siteId siteId | -u|--userId userId --ip ipAddress -c|--incremental -t|--throttle -d|--debug --help"
actual=$(./picket.sh $input 2>&1)
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
