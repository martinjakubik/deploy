#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# exit codes for this function
#   0 = valid
#   1 = invalid arguments on command line
#   2 = invalid character used
#   3 = input is too long

# sets up defaults
userId=''
is_valid_user_id=0

# parses and reads command line arguments
userId="$1"
shift

while [ $# -gt 0 ]
do
    case "$1" in
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
        (-*) echo >&2 ${USAGE}
        exit 1;;
    esac
    shift
done

if [[ $DEBUG -eq 1 ]] ; then echo "testing user id: '${userId}'" ; fi

if [[ ! "${userId}" =~ [ascdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789][ascdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]* ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "user id has an invalid character '${userId}'" ; fi
    is_valid_user_id=0
    echo $is_valid_user_id
    exit 2
elif [[ "${#userId}" -gt 29 ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "user id too long '${userId}'" ; fi
    is_valid_user_id=0
    echo $is_valid_user_id
    exit 3
else
    is_valid_user_id=1
fi

echo $is_valid_user_id
exit 0
