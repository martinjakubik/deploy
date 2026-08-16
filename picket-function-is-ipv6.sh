#!/bin/bash
# sets up usage
USAGE="usage: $0 --ip ipAddress -d|--debug"

# sets up defaults
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

ip -6 route get "$1"/128 >/dev/null 2>&1  
case "$?" in
    (0|2) is_ipv6=0;;
    (1) is_ipv6=1;;
esac

echo $is_ipv6
