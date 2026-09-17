#!/bin/bash
# sets up usage
USAGE="usage: $0 -a|--appId appId"

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

is_valid_app_id=false
if [[ ! $(picket-function-is-valid-app-id "${appId}") ]] ; then
    echo app id is not valid, exiting
    exit 1
fi

echo creating app \"${appId}\"

file_listing_apps=$HOME/.picket/apps.db/apps
parent_path_to_file_listing_apps=$(dirname "${file_listing_apps}")

if [[ ! -d "${parent_path_to_file_listing_apps}" ]] ; then
    mkdir -p "${parent_path_to_file_listing_apps}"
fi

if [[ ! -e "${file_listing_apps}" ]] ; then
    touch "${file_listing_apps}"
fi

does_app_exist_in_database=$(picket-function-does-app-exist-in-database --appId "${appId}")

if [[ $does_app_exist_in_database -eq 0 ]] ; then
    echo "app does not exist; creating it"
    echo "${appId}" >> "${file_listing_apps}"
else
    echo "app already exists; not creating it"
fi

exit 0
