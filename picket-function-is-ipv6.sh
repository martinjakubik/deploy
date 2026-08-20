#!/bin/bash
# sets up usage
USAGE="usage: $0 --ip ipAddress -d|--debug"

# sets up defaults
ipAddress=""
is_ipv6=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
    case "$1" in
        (--ip) ipAddress="$2"; shift;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
        (-*) echo >&2 ${USAGE}
        exit 1;;
    esac
    shift
done

if [[ ! "$ipAddress" ]] ; then
    echo >&2 ${USAGE}
    exit 1
fi

if [[ "$ipAddress" =~ .*:.* ]] ; then
    is_ipv6=1
fi

echo $is_ipv6
