#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# exit codes for this function
#   0 = valid
#   1 = invalid arguments on command line
#   2 = invalid character used
#   3 = input is too long

# sets up defaults
path_to_picket_database=''
is_valid_path_to_picket_database=0

# parses and reads command line arguments
path_to_picket_database="$1"
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

if [[ $DEBUG -eq 1 ]] ; then echo "testing user id: '${path_to_picket_database}'" ; fi

if [[ ! "${path_to_picket_database}" =~ [ascdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789][ascdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]* ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "user id has an invalid character '${path_to_picket_database}'" ; fi
    is_valid_path_to_picket_database=0
    echo $is_valid_path_to_picket_database
    exit 2
elif [[ "${#path_to_picket_database}" -gt 300 ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "path to picket database is too long" ; fi
    is_valid_path_to_picket_database=0
    echo $is_valid_path_to_picket_database
    exit 3
else
    is_valid_path_to_picket_database=1
fi

echo $is_valid_path_to_picket_database
exit 0
