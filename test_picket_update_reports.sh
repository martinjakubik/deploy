run_count=$(( run_count+1 ))
if [[ ! "$actual" = "$expected" ]] ; then
    fail_count=$(( fail_count+1 ))
    echo failed
    echo "actual:   \"$actual\""
    echo "expected: \"$expected\""
    echo
else
    echo succeeded
    success_count=$(( success_count+1 ))
    echo
fi
