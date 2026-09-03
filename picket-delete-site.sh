#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId"

unset siteId

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

if [[ -z "${siteId}" ]] ; then
	echo "site ID cannot be empty; exiting"
	exit 1
fi

file_listing_sites=$HOME/.picket/sites.db/sites
parent_path_to_file_listing_sites=$(dirname "${file_listing_sites}")

if [[ ! -d "${parent_path_to_file_listing_sites}" ]] ; then
    echo "no site database was found; check if $HOME/.picket/sites.db exists"
    exit 1
fi

sudo touch "${file_listing_sites}".without_site
sudo chmod a+w "${file_listing_sites}".without_site

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
    echo "site does not exist"
else
	finished_reading_file=false
	until $finished_reading_file; do
		read -r || finished_reading_file=true
		if [[ ! "$REPLY" =~ ^"${siteId}"$ && ! "$REPLY" =~ ^" *"$ ]] ; then
			echo "$REPLY"
		fi
	done < "${file_listing_sites}" > "${file_listing_sites}".without_site

	echo "Really delete the site \'${siteId}\'?"
	select strictreply in "Yes" "No"; do
		relaxedreply=${strictreply:-$REPLY}
		case $relaxedreply in
			(Yes | yes | Y | y) echo "deleting site"; sudo mv "${file_listing_sites}".without_site "${file_listing_sites}"; break;;
			(No  | no  | N | n) echo "site was not deleted"; sudo rm "${file_listing_sites}".without_site; exit 0;;
		esac
	done
	
fi

exit 0
