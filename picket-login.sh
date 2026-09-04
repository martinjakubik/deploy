#!/bin/bash
# sets up usage
USAGE="usage: $0 userId -d|--debug"

# set up defaults
DEBUG=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
        (*) userId="$2"; shift;;
		(-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

echo "logging in"
exit 0
