#!/bin/bash
# sets up usage
USAGE="usage: $0 -a|--appId appId -s|--siteId siteId"

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

is_valid_app_id=false
if [[ ! $(picket-function-is-valid-app-id "${appId}") ]] ; then
    echo app id is not valid, exiting
    exit 1
fi

is_valid_site_id=false
if [[ ! $(picket-function-is-valid-site-id "${siteId}") ]] ; then
    echo site id is not valid, exiting
    exit 1
fi

does_app_exist_in_database=$(picket-function-does-app-exist-in-database --appId "${appId}")
if [[ $does_app_exist_in_database -eq 0 ]] ; then
    echo "App does not exist. Stopping."
    exit 1
fi

does_site_exist_in_database=$(picket-function-does-site-exist-in-database --siteId "${siteId}")
if [[ $does_site_exist_in_database -eq 0 ]] ; then
    echo "Site does not exist. Stopping."
    exit 1
fi

echo adding app \"${appId}\" to site \"${siteId}\"

file_listing_apps_in_site=$HOME/.picket/sites.db/"${siteId}"
parent_path_to_file_listing_apps_in_site=$(dirname "${file_listing_apps_in_site}")

if [[ ! -f "${file_listing_apps_in_site}" ]] ; then
    touch "${file_listing_apps_in_site}"
fi

existing_app_in_site_array=()
finished_reading_file=false
until $finished_reading_file; do
    read -r || finished_reading_file=true
    existing_app_in_site_array+=("$REPLY")
done < "${file_listing_apps_in_site}"

if printf '%s\0' "${existing_app_in_site_array[@]}" | grep -Fxqz -- "${appId}" ; then
    does_app_exist_in_database=1
else
    does_app_exist_in_database=0
fi

if [[ $does_app_exist_in_database -eq 1 ]] ; then
    echo "App already exists in site. Stopping."
    exit 1
else
    existing_app_in_site_array+=" ${appId}"
    echo -n > "${file_listing_apps_in_site}"
    for existingAppId in ${existing_app_in_site_array[@]} ; do
        echo "${existingAppId}" >> "${file_listing_apps_in_site}"
    done
fi

exit 0
