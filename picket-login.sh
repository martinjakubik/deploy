#!/bin/bash
# sets up usage
USAGE="usage: $0 --userId userId -d|--debug"

# set up defaults
DEBUG=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
        (-u) userId="$2"; shift;;
        (--userId) userId="$2"; shift;;
		(-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

argument_value_debug=""
if [[ $DEBUG -eq 1 ]] ; then
    argument_value_debug="--debug"
fi

if [[ ! "${userId}" ]] ; then
    echo >&2 ${USAGE}
    exit 1
fi

is_valid_user_id=$(picket-function-is-valid-user-id "${userId}")

if [[ $is_valid_user_id -eq 1 ]] ; then
    echo "logging in"
    echo $userId > $HOME/.picket/user
else
    echo "The user name is invalid. Use only letters without accents, arabic digits and start with a letter."
    exit 1
fi

exit 0
