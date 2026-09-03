#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# sets up defaults
siteId=''
is_valid_site_id=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
    case "$1" in
        (*) siteId=$1;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
        (-*) echo >&2 ${USAGE}
        exit 1;;
    esac
    shift
done

if [[ ! "${siteId}" ]] ; then
    echo >&2 ${USAGE}
    exit 1
fi

if [[ "${siteId}" =~ .*\ .* ]] ; then
    is_valid_site_id=0
    exit 1
elif [[ "${#siteId}" -gt 29 ]] ; then
    is_valid_site_id=0
    exit 1
else
    is_valid_site_id=1
fi

echo $is_valid_site_id
exit 0
