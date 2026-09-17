#!/bin/bash
# sets up usage
USAGE="usage: $0 -a|--appId appId"

unset appId

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-a) appId="$2"; shift;;
        (--appId) appId="$2"; shift;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

if [[ -z "${appId}" ]] ; then
	echo "app ID cannot be empty; exiting"
	exit 1
fi

file_listing_apps=$HOME/.picket/apps.db/apps
parent_path_to_file_listing_apps=$(dirname "${file_listing_apps}")

if [[ ! -d "${parent_path_to_file_listing_apps}" ]] ; then
    echo "no app database was found; check if $HOME/.picket/apps.db exists"
    exit 1
fi

sudo touch "${file_listing_apps}".without_deleted_app
sudo chmod a+w "${file_listing_apps}".without_deleted_app

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

if [[ $does_app_exist_in_database -eq 0 ]] ; then
    echo "app does not exist"
else
	finished_reading_file=false
	until $finished_reading_file; do
		read -r || finished_reading_file=true
		if [[ ! "$REPLY" =~ ^"${appId}"$ && ! "$REPLY" =~ ^" *"$ ]] ; then
			echo "$REPLY"
		fi
	done < "${file_listing_apps}" > "${file_listing_apps}".without_deleted_app

	echo "Really delete the app \'${appId}\'?"
	select strictreply in "Yes" "No"; do
		relaxedreply=${strictreply:-$REPLY}
		case $relaxedreply in
			(Yes | yes | Y | y) echo "deleting app"; sudo mv "${file_listing_apps}".without_deleted_app "${file_listing_apps}"; break;;
			(No  | no  | N | n) echo "app was not deleted"; sudo rm "${file_listing_apps}".without_deleted_app; exit 0;;
		esac
	done

fi

exit 0
