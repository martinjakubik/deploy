#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId -u|--userId userId --ip ipAddress --help"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
        (-u) userId="$2"; shift;;
        (--userId) userId="$2"; shift;;
        (--ip) ipAddress="$2"; shift;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

echo
echo staging site \"${siteId}\"
echo need picket-function-upload --inputDir "$project_root_directory" --siteId $siteId --siteNickname "$siteNickname" --userId "${userId}" --ip $ipAddress
echo ... done
echo 

exit 0
