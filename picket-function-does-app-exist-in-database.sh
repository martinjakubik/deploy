#!/bin/bash
# sets up usage
USAGE="usage: $0 -a|--appId appId -s|--siteId siteId -d|--debug"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-a) appId="$2"; shift;;
        (--appId) appId="$2"; shift;;
        (-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

is_site_selected=0
if [[ -n "${siteId}" ]] ; then
    is_site_selected=1
fi

picket_configuration_file="/etc/picket/config.picket"
if [[ -f "$HOME/.config/picket/config.picket" ]] ; then
    picket_configuration_file="$HOME/.config/picket/config.picket"
fi
if [[ -n "${picket_path_to_configuration_file}" && -f "${picket_path_to_configuration_file}" ]] ; then
    picket_configuration_file="${picket_path_to_configuration_file}"
fi

source picket-function-read-configuration "${picket_configuration_file}"

file_listing_apps="${path_to_picket_database}"/apps.db/apps
if [[ $is_site_selected -eq 1 ]] ; then
    file_listing_apps="${path_to_picket_database}"/sites.db/${siteId}
else
    file_listing_apps="${path_to_picket_database}"/apps.db/apps
fi

existing_app_array=()
if [[ -f "${file_listing_apps}" ]] ; then
    finished_reading_file=false
    until $finished_reading_file; do
        read -r || finished_reading_file=true
        line="${REPLY}"

        # skips comments and empty lines
        if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$line" ]]; then
            continue
        fi

        # parses key-value pairs
        if [[ "$line" =~ ^[[:space:]]*([^=]+)=(.*)$ ]]; then
            value="${BASH_REMATCH[2]}"

            # trims whitespace from value
            value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            existing_app_array+=("${value}")
        fi
    done < "${file_listing_apps}"
fi

if printf '%s\0' "${existing_app_array[@]}" | grep -Fxqz -- "${appId}" ; then
    does_app_exist_in_database=1
else
    does_app_exist_in_database=0
fi

echo $does_app_exist_in_database
exit 0
