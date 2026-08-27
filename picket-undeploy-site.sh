#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

echo
echo undeploying site \"${siteId}\"
echo ...done
echo

exit 0
