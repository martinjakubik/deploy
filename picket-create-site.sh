#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
        (-i) argument_value_project_root_directory="${2%\/}"; shift;;
        (--inputDir) argument_value_project_root_directory="${2%\/}"; shift;;
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
        (--siteNickname) argument_value_siteNickname="$2"; shift;;
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

project_root_directory="${siteId}"
if [[ "${argument_value_project_root_directory}" ]] ; then
    project_root_directory="${argument_value_project_root_directory}"
fi

siteNickname="${siteId}"
if [[ "${argument_value_siteNickname}" ]] ; then
    siteNickname="${argument_value_siteNickname}"
fi

is_valid_site_id=false
if [[ ! $(picket-function-is-valid-site-id "${siteId}") ]] ; then
    echo site id is not valid, exiting
    exit 1
fi

echo creating site \"${siteId}\"

file_listing_sites=/etc/picket/sites.db/sites
parent_path_to_file_listing_sites=$(dirname "${file_listing_sites}")

if [[ ! -d "${parent_path_to_file_listing_sites}" ]] ; then
    sudo mkdir -p "${parent_path_to_file_listing_sites}"
fi

if [[ ! -e "${file_listing_sites}" ]] ; then
    sudo touch "${file_listing_sites}"
    sudo chmod a+w "${file_listing_sites}"
fi

existing_site_array=()
finished_reading_file=false
until $finished_reading_file; do
    read -r || finished_reading_file=true
    existing_site_array+=("$REPLY")
done < "${file_listing_sites}"

if printf '%s\0' "${existing_site_array[@]}" | grep -Fxqz -- "${siteId}" ; then
    does_site_exist_in_database=1
else
    does_site_exist_in_database=0
fi

if [[ $does_site_exist_in_database -eq 0 ]] ; then
    echo "site does not exist; creating it"
    sudo echo "${siteId}" >> "${file_listing_sites}"
else
    echo "site already exists; not creating it"
fi

exit 0

