#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
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

file_listing_sites="${path_to_picket_database}"/sites.db/sites
parent_path_to_file_listing_sites=$(dirname "${file_listing_sites}")

existing_site_array=()
if [[ -f "${file_listing_sites}" ]] ; then
    finished_reading_file=false
    until $finished_reading_file; do
        read -r || finished_reading_file=true
        existing_site_array+=("$REPLY")
    done < "${file_listing_sites}"
fi

if printf '%s\0' "${existing_site_array[@]}" | grep -Fxqz -- "${siteId}" ; then
    does_site_exist_in_database=1
else
    does_site_exist_in_database=0
fi

echo $does_site_exist_in_database
exit 0
