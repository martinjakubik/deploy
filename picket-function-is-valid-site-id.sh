#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# sets up defaults
siteId=''
is_valid_site_id=0

# parses and reads command line arguments
siteId="$1"
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

if [[ ! "${siteId}" ]] ; then
    echo >&2 ${USAGE}
    exit 1
fi

if [[ $DEBUG -eq 1 ]] ; then echo "testing site id: '${siteId}'" ; fi

if [[ "${siteId}" =~ .*\ .* ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "site id has blank '${siteId}'" ; fi
    is_valid_site_id=0
elif [[ "${#siteId}" -gt 29 ]] ; then
    if [[ $DEBUG -eq 1 ]] ; then echo "site id too long '${siteId}'" ; fi
    is_valid_site_id=0
else
    is_valid_site_id=1
fi

if [[ $is_valid_site_id -eq 0 ]] ; then
    echo $is_valid_site_id
    exit 1
fi

echo $is_valid_site_id
exit 0
