#!/bin/bash
# sets up usage
USAGE="usage: $0"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
        (-u) userId="$2"; shift;;
        (--userId) userId="$2"; shift;;
        (--ip) ipAddress="$2"; shift;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

file_listing_sites=/etc/picket/sites.db/sites
parent_path_to_file_listing_sites=$(dirname "${file_listing_sites}")

if [[ ! -d "${parent_path_to_file_listing_sites}" ]] ; then
    echo "no site database was found; check if /etc/picket/sites.db exists"
    exit 1
fi

echo
echo listing sites
echo

existing_site_array=()
finished_reading_file=false
until $finished_reading_file; do
    read -r || finished_reading_file=true
    existing_site_array+=("$REPLY")
done < "${file_listing_sites}"

site_count=0
for siteId in "${existing_site_array[@]}" ; do
    echo "${siteId}"
    site_count=$(( site_count+1 ))
done

if [[ $site_count -gt 0 ]] ; then
    if [[ $site_count -eq 1 ]] ; then
        echo "1 site found"
    else
        echo "$site_count sites found"
    fi
fi

exit 0
