#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

file_listing_sites=$HOME/.picket/sites.db/sites
parent_path_to_file_listing_sites=$(dirname "${file_listing_sites}")

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

echo $does_site_exist_in_database
exit 0
