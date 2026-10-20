#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
        (--siteNickname) argument_value_siteNickname="$2"; shift;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

if [[ -z "${siteId}" ]] ; then
	echo "Site ID cannot be empty; exiting."
	exit 1
fi

is_valid_site_id=false
if [[ ! $(picket-function-is-valid-site-id "${siteId}") ]] ; then
    echo site id is not valid, exiting
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

siteNickname="${siteId}"
if [[ "${argument_value_siteNickname}" ]] ; then
    siteNickname="${argument_value_siteNickname}"
fi

file_listing_sites="${path_to_picket_database}"/sites.db/sites
parent_path_to_file_listing_sites=$(dirname "${file_listing_sites}")

if [[ ! -d "${parent_path_to_file_listing_sites}" ]] ; then
    mkdir -p "${parent_path_to_file_listing_sites}"
fi

if [[ ! -e "${file_listing_sites}" ]] ; then
    touch "${file_listing_sites}"
fi

does_site_exist_in_database=$(picket-function-does-site-exist-in-database --siteId "${siteId}")

if [[ $does_site_exist_in_database -eq 0 ]] ; then
    echo "${siteId}" >> "${file_listing_sites}"
    echo "[ Site \"${siteId}\" created. ]"
else
    echo "site already exists; not creating it"
fi

exit 0
