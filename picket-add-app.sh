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
    echo "App id is not valid, exiting."
    exit 1
fi

is_valid_site_id=false
if [[ ! $(picket-function-is-valid-site-id "${siteId}") ]] ; then
    echo "Site id is not valid, exiting."
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

echo "Adding app \"${appId}\" to site \"${siteId}\"."

file_listing_apps_in_site=$HOME/.picket/sites.db/"${siteId}"

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
    all_project_root=~/code/gitwork
    app_project_root_directory="${all_project_root}"/"$(picket-function-get-app-project-root-from-id $appId $argument_value_debug)"
    file_listing_files_to_add="${app_project_root_directory}"/"${appId}"-custom-source-code-files

    app_file_array=()
    finished_reading_file=false
    until $finished_reading_file; do
        read -r || finished_reading_file=true
        app_file_array+=("${REPLY/\\n/}")
    done < "$file_listing_files_to_add"

    site_project_root="${all_project_root}"/$(picket-function-get-site-project-root-from-id "${siteId}")
    if [[ ! -d "${site_project_root}/site/apps/${appId}/app" ]] ; then
        mkdir -p "${site_project_root}/site/apps/${appId}/app"
    fi
    for app_file in "${app_file_array[@]}" ; do
        if [[ -n "${app_file}" ]] ; then
            cp "${app_file}" "${site_project_root}/site/apps/${appId}/app/"
        fi
    done
    existing_app_in_site_array+=" ${appId}"
    echo -n > "${file_listing_apps_in_site}"
    for existingAppId in ${existing_app_in_site_array[@]} ; do
        echo "${existingAppId}" >> "${file_listing_apps_in_site}"
    done
fi

exit 0
