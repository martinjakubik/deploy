# sets up colors
col0=''
col1=''
col2=''

# activates colors only if output is going to a terminal
if [[ -t 1 ]] ; then
    col0='\033[0m'
    col1='\033[0;33m'
    col2='\033[0;34m'
fi

run_count=$(( run_count+1 ))
if [[ ! "$actual" = "$expected" ]] ; then
    fail_count=$(( fail_count+1 ))
    echo failed
    # echo -e "${col1}hello${col0} ${col2}color${col0}"
    echo -e "actual:   \"${col1}$actual${col0}\""
    echo -e "expected: \"${col2}$expected${col0}\""
    echo
else
    echo succeeded
    success_count=$(( success_count+1 ))
    echo
fi
