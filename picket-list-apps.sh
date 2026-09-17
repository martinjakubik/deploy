#!/bin/bash
# sets up usage
USAGE="usage: $0 [ -s|--siteId siteId ]"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
    	(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

is_list_for_single_site=0
file_listing_apps=$HOME/.picket/apps.db/apps
if [[ -n "${siteId}" ]] ; then
    file_listing_apps=$HOME/.picket/sites.db/"${siteId}"
    is_list_for_single_site=1
fi
parent_path_to_file_listing_apps=$(dirname "${file_listing_apps}")

if [[ $is_list_for_single_site -eq 1 ]] ; then
    does_site_exist_in_database=$(picket-function-does-site-exist-in-database --siteId "${siteId}")
    if [[ $does_site_exist_in_database -eq 0 ]] ; then
        echo "Site does not exist. Stopping."
        exit 1
    fi
fi


if [[ ! -d "${parent_path_to_file_listing_apps}" ]] ; then
    echo "no app database was found; check if $file_listing_apps exists"
    exit 1
fi

echo
if [[ $is_list_for_single_site -eq 0 ]] ; then
    echo "listing apps"
else
    echo "listing apps for site \"${siteId}\""
fi
echo

existing_app_array=()
finished_reading_file=false
until $finished_reading_file; do
    read -r || finished_reading_file=true
    if [[ -n "$REPLY" ]] ; then
        existing_app_array+=("$REPLY")
    fi
done < "${file_listing_apps}"

app_count=0
for appId in "${existing_app_array[@]}" ; do
    app_count_padded=$app_count
    if [[ ${#app_count_padded} -lt 2 ]] ; then
        app_count_padded=00${app_count_padded}
    elif [[ ${#app_count_padded} -lt 3 ]] ; then
        app_count_padded=0${app_count_padded}
    fi
    echo ${app_count_padded}. "${appId}"
    app_count=$(( app_count+1 ))
done

if [[ $app_count -gt 0 ]] ; then
    echo
    if [[ $app_count -eq 1 ]] ; then
        echo "... 1 app found"
    else
        echo "... $app_count apps found"
    fi
fi

exit 0
