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

file_listing_sites=$HOME/.picket/sites.db/sites
parent_path_to_file_listing_sites=$(dirname "${file_listing_sites}")

if [[ ! -d "${parent_path_to_file_listing_sites}" ]] ; then
    echo "no site database was found; check if $HOME/.picket/sites.db exists"
    exit 1
fi

existing_site_array=()
finished_reading_file=false
until $finished_reading_file; do
    read -r || finished_reading_file=true
    if [[ -n "$REPLY" ]] ; then
        existing_site_array+=("$REPLY")
    fi
done < "${file_listing_sites}"

sites_hosting_app=()
for siteId in ${existing_site_array[@]} ; do
    file_listing_apps_in_site=$HOME/.picket/sites.db/"${siteId}"
    if [[ -f "${file_listing_apps_in_site}" ]] ; then
        finished_reading_file=false
        until $finished_reading_file; do
            read -r || finished_reading_file=true
            if [[ -n "$REPLY" ]] ; then
                sites_hosting_app+=("$siteId")
            fi
        done < "${file_listing_apps_in_site}"
    fi
done

echo $sites_hosting_app
