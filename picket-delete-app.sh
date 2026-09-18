#!/bin/bash
# sets up usage
USAGE="usage: $0 -a|--appId appId -s|--siteId siteId -d|--debug"

unset appId

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

is_site_selected=0
if [[ -n "${siteId}" ]] ; then
    is_site_selected=1
fi

is_valid_app_id=false
if [[ ! $(picket-function-is-valid-app-id "${appId}") ]] ; then
    echo "App id is not valid. Exiting."
    exit 1
fi

is_valid_site_id=false
if [[ ${is_site_selected} -eq 1 && ! $(picket-function-is-valid-site-id "${siteId}") ]] ; then
    echo "Site id is not valid. Exiting."
    exit 1
fi

does_app_exist_in_database=$(picket-function-does-app-exist-in-database --appId "${appId}")
if [[ $does_app_exist_in_database -eq 0 ]] ; then
    echo "App does not exist. Stopping."
    exit 1
fi

does_site_exist_in_database=$(picket-function-does-site-exist-in-database --siteId "${siteId}")
if [[ ${is_site_selected} -eq 1 && $does_site_exist_in_database -eq 0 ]] ; then
    echo "Site does not exist. Stopping."
    exit 1
fi

does_app_exist_in_site_database=$(picket-function-does-app-exist-in-database --siteId ${siteId} --appId "${appId}")
if [[ ${is_site_selected} -eq 1 && ${does_app_exist_in_site_database} -eq 0 ]] ; then
    echo "App does not exist in site \"${siteId}\". Stopping."
    exit 1
fi

if [[ ${is_site_selected} -eq 1 ]] ; then
    echo "Deleting app \"${appId}\" from site \"${siteId}\"."
else
    echo "Deleting app \"${appId}\"."
fi

if [[ $does_app_exist_in_database -eq 0 ]] ; then
    echo "App does not exist."
    exit 1
elif [[ ${is_site_selected} -eq 1 ]] ; then
    file_listing_apps="$HOME/.picket/sites.db/${siteId}"
    parent_path_to_file_listing_apps=$(dirname "${file_listing_apps}")

    if [[ ! -d "${parent_path_to_file_listing_apps}" ]] ; then
        echo "No app database was found for this site; check if $HOME/.picket/${siteId} exists."
        exit 1
    fi

    touch "${file_listing_apps}".without_deleted_app
    chmod a+w "${file_listing_apps}".without_deleted_app

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

   	finished_reading_file=false
   	until $finished_reading_file; do
  		read -r || finished_reading_file=true
  		if [[ ! "$REPLY" =~ ^"${appId}"$ && ! "$REPLY" =~ ^"\ *"$ ]] ; then
 			echo "$REPLY"
  		fi
   	done < "${file_listing_apps}" > "${file_listing_apps}".without_deleted_app

   	echo "Really delete the app \"${appId}\" from site \"${siteId}\"?"
   	select strictreply in "Yes" "No"; do
  		relaxedreply=${strictreply:-$REPLY}
  		case $relaxedreply in
 			(Yes | yes | Y | y) echo "deleting app"; mv "${file_listing_apps}".without_deleted_app "${file_listing_apps}"; break;;
 			(No  | no  | N | n) echo "app was not deleted"; rm "${file_listing_apps}".without_deleted_app; exit 0;;
  		esac
   	done
else
    file_listing_apps=$HOME/.picket/apps.db/apps
    parent_path_to_file_listing_apps=$(dirname "${file_listing_apps}")

    if [[ ! -d "${parent_path_to_file_listing_apps}" ]] ; then
        echo "No app database was found; check if $HOME/.picket/apps.db exists."
        exit 1
    fi

    touch "${file_listing_apps}".without_deleted_app
    chmod a+w "${file_listing_apps}".without_deleted_app

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

    read -a list_sites_hosting_app < <(picket-function-list-sites-hosting-app --appId "${appId}")
    if [[ $DEBUG -eq 1 ]] ; then echo "number of sites hosting app: \"${#list_sites_hosting_app[@]}\"" ; fi
    echo $list_sites_hosting_app

    if [[ "${#list_sites_hosting_app[@]}" -eq 0 ]] ; then
    	finished_reading_file=false
    	until $finished_reading_file; do
    		read -r || finished_reading_file=true
    		if [[ ! "$REPLY" =~ ^"${appId}"$ && ! "$REPLY" =~ ^"\ *"$ ]] ; then
    			echo "$REPLY"
    		fi
    	done < "${file_listing_apps}" > "${file_listing_apps}".without_deleted_app

    	echo "Really delete the app \"${appId}\"?"
    	select strictreply in "Yes" "No"; do
    		relaxedreply=${strictreply:-$REPLY}
    		case $relaxedreply in
    			(Yes | yes | Y | y) echo "deleting app"; mv "${file_listing_apps}".without_deleted_app "${file_listing_apps}"; break;;
    			(No  | no  | N | n) echo "app was not deleted"; rm "${file_listing_apps}".without_deleted_app; exit 0;;
    		esac
    	done
    else
         echo "Some sites still host this app. Use ''picket delete-app --siteId your_site'' to remove the app from those sites first."
         exit 1
    fi
fi

exit 0
