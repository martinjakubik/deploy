#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId -u|--userId userId --ip ipAddress -c|--incremental -t|--throttle -d|--debug --help"

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
		(-t) THROTTLE=1;;
        (--throttle) THROTTLE=1;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

picket_configuration_file="/etc/picket/config.picket"
if [[ -f "$HOME/.config/picket/config.picket" ]] ; then
    picket_configuration_file="$HOME/.config/picket/config.picket"
fi
if [[ -n "${picket_path_to_configuration_file}" && -f "${picket_path_to_configuration_file}" ]] ; then
    picket_configuration_file="${picket_path_to_configuration_file}"
fi

source picket-function-read-configuration "${picket_configuration_file}"

argument_value_incremental=""
if [[ $incremental -eq 1 ]] ; then
    argument_value_incremental="--incremental"
fi

argument_value_throttle=""
if [[ $THROTTLE -eq 1 ]] ; then
    argument_value_throttle="--throttle"
fi

argument_value_debug=""
if [[ $DEBUG -eq 1 ]] ; then
    argument_value_debug="--debug"
fi

siteNickname="$(picket-function-get-site-nickname-from-id $siteId)"
project_root_directory="${root_path_to_all_projects}"/"$(picket-function-get-site-project-root-from-id $siteId $argument_value_debug)"

does_site_exist_in_database=$(picket-function-does-site-exist-in-database --siteId "${siteId}")
if [[ $does_site_exist_in_database -eq 0 ]] ; then
    echo "Site does not exist. Stopping."
    exit 1
fi

echo
echo "[ Staging site \"${siteId}\. ]"
picket-function-upload --inputDir "$project_root_directory" --siteId "$siteId" --siteNickname "$siteNickname" --userId "${userId}" --ip $ipAddress $argument_value_incremental $argument_value_throttle $argument_value_debug
echo

exit 0
