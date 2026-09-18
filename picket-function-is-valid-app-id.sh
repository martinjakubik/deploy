#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# sets up defaults
appId=''
is_valid_app_id=0

# parses and reads command line arguments
appId="$1"
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

if [[ ! "${appId}" ]] ; then
    echo "app ID cannot be empty; exiting"
    exit 1
fi

if [[ $DEBUG -eq 1 ]] ; then echo "testing app id: '${appId}'" ; fi

if [[ "${appId}" =~ .*\ .* ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "app id has blank '${appId}'" ; fi
    is_valid_app_id=0
elif [[ "${#appId}" -gt 29 ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "app id too long '${appId}'" ; fi
    is_valid_app_id=0
else
    is_valid_app_id=1
fi

if [[ $is_valid_app_id -eq 0 ]] ; then
    echo $is_valid_app_id
    exit 1
fi

echo $is_valid_app_id
exit 0
