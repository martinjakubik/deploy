#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# sets up defaults
path_to_app_project=''
is_valid_path_to_app_project=0

# parses and reads command line arguments
path_to_app_project="$1"
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

if [[ ! "${path_to_app_project}" ]] ; then
    echo "path to app project cannot be empty; exiting"
    exit 1
fi

if [[ $DEBUG -eq 1 ]] ; then echo "testing path to app project: '${path_to_app_project}'" ; fi

if [[ "${path_to_app_project}" =~ .*\ .* ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "path to app project has blank '${path_to_app_project}'" ; fi
    is_valid_path_to_app_project=0
elif [[ "${#path_to_app_project}" -gt 49 ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "path to app project too long '${path_to_app_project}'" ; fi
    is_valid_path_to_app_project=0
elif [[ ! "${path_to_app_project}" =~ [ascdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789][ascdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]* ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "path to app project has an invalid character" ; fi
    is_valid_path_to_app_project=0
else
    is_valid_path_to_app_project=1
fi

if [[ $is_valid_path_to_app_project -eq 0 ]] ; then
    echo $is_valid_path_to_app_project
    exit 1
fi

echo $is_valid_path_to_app_project
exit 0
