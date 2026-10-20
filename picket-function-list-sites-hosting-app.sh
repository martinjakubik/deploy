#!/bin/bash
# sets up usage
USAGE="usage: $0 -a|--appId appId -d|--debug"

unset appId

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-a) appId="$2"; shift;;
        (--appId) appId="$2"; shift;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

if [[ -z "${appId}" ]] ; then
	echo "app ID cannot be empty; exiting"
	exit 1
fi

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

if [[ ! -d "${parent_path_to_file_listing_sites}" || ! -f  ${file_listing_sites} ]] ; then
    echo "Error: No site database was found. Check if ${path_to_picket_database}/sites.db/sites exists."
    exit 1
fi

existing_site_array=()
if [[ $DEBUG -eq 1 ]] ; then echo "Existing site array: \"${existing_site_array[@]}\"." ; fi
finished_reading_file=false
until $finished_reading_file; do
    read -r || finished_reading_file=true
    if [[ -n "$REPLY" ]] ; then
        existing_site_array+=("$REPLY")
    fi
done < "${file_listing_sites}"

sites_hosting_app=()
for siteId in ${existing_site_array[@]} ; do
    file_listing_apps_in_site="${path_to_picket_database}"/sites.db/"${siteId}"
    if [[ -f "${file_listing_apps_in_site}" ]] ; then
        finished_reading_file=false
        until $finished_reading_file; do
            read -r || finished_reading_file=true
            if [[ -n "$REPLY" && "$REPLY" = "${appId}" ]] ; then
                sites_hosting_app+=("$siteId")
            fi
        done < "${file_listing_apps_in_site}"
    fi
done

echo $sites_hosting_app
