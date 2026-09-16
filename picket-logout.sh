#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# set up defaults
DEBUG=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

if [[ -f $HOME/.picket/user && $(wc -c < ~/.picket/user) -gt 0 ]] ; then
    echo "Logging out."
    rm $HOME/.picket/user
else
    echo "There is no user logged in."
    exit 1
fi
exit 0
