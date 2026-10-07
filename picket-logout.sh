#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# set up defaults
DEBUG=0
configuration_file_argument=""

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

picket_configuration_file="/etc/picket/config.picket"
if [[ -f "$HOME/.config/picket/config.picket" ]] ; then
    picket_configuration_file="$HOME/.config/picket/config.picket"
fi
if [[ -n "${picket_path_to_configuration_file}" && -f "${picket_path_to_configuration_file}" ]] ; then
    picket_configuration_file="${picket_path_to_configuration_file}"
fi

source picket-function-read-configuration "${picket_configuration_file}"

is_valid_picket_database=$(picket-function-is-valid-path-to-picket-database "${path_to_picket_database}")

if [[ $is_valid_picket_database -eq 1 ]] ; then
    if [[ ! -e "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
else
    echo "The picket database path is invalid. Add the line \"path_to_picket_database=$HOME/.picket\" to your \"$HOME/config/picket/config.picket\" file."
    exit 1
fi

if [[ -f "${path_to_picket_database}"/user && $(wc -c < "${path_to_picket_database}"/user) -gt 0 ]] ; then
    echo "[ Logging out. ]"
    rm "${path_to_picket_database}"/user
else
    echo "There is no user logged in."
    exit 1
fi
exit 0
