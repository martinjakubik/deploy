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

file_listing_apps=$HOME/.picket/apps.db/apps
parent_path_to_file_listing_apps=$(dirname "${file_listing_apps}")

existing_app_array=()
finished_reading_file=false
until $finished_reading_file; do
    read -r || finished_reading_file=true
    existing_app_array+=("$REPLY")
done < "${file_listing_apps}"

if printf '%s\0' "${existing_app_array[@]}" | grep -Fxqz -- "${appId}" ; then
    does_app_exist_in_database=1
else
    does_app_exist_in_database=0
fi

echo $does_app_exist_in_database
exit 0
