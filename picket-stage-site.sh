#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId -u|--userId userId --ip ipAddress -c|--incremental -d|--debug --help"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
        (-u) userId="$2"; shift;;
        (--userId) userId="$2"; shift;;
        (--ip) ipAddress="$2"; shift;;
		(-c) incremental=1;;
		(--incremental) incremental=1;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

argument_value_incremental=""
if [[ $incremental -eq 1 ]] ; then
    argument_value_incremental="--incremental"
fi

argument_value_debug=""
if [[ $DEBUG -eq 1 ]] ; then
    argument_value_debug="--debug"
fi

all_project_root=~/code/gitwork
siteNickname="$(picket-function-get-site-nickname-from-id $siteId)"
project_root_directory="${all_project_root}"/"$(picket-function-get-site-project-root-from-id $siteId $argument_value_debug)"

echo
echo staging site \"${siteId}\"
picket-function-upload --inputDir "$project_root_directory" --siteId "$siteId" --siteNickname "$siteNickname" --userId "${userId}" --ip $ipAddress $argument_value_incremental $argument_value_debug
echo ... done
echo 

exit 0
