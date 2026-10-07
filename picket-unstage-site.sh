#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId -u|--userId userId --ip ipAddress -d|--debug --help"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
        (-u) userId="$2"; shift;;
        (--userId) userId="$2"; shift;;
        (--ip) ipAddress="$2"; shift;;
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

argument_value_debug=""
if [[ $DEBUG -eq 1 ]] ; then
    argument_value_debug="--debug"
fi

echo
echo "[ Unstaging site \"${siteId}\". ]"
picket-function-delete-stage --siteId "$siteId" --userId "${userId}" --ip $ipAddress $argument_value_debug
echo ... done
echo

exit 0
